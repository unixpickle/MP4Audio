//
//  ANMovie.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/10/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANMovie.h"

@interface ANMovie (Private)

- (BOOL)loadAtoms;

- (ANTrackAtom *)firstAudioTrack;
- (AudioFileID)openM4AOutput:(NSString *)path;

- (void)addLength:(NSInteger)length toAtomInFile:(ANMovieAtom *)atom;
- (void)writeLength:(NSUInteger)length forAtomInFile:(ANMovieAtom *)atom;
- (void)updateChunkOffsetsBytesAdded:(NSInteger)count atIndex:(NSUInteger)index;

@end

@implementation ANMovie

@synthesize atoms;
@synthesize tracks;

- (id)initWithFile:(NSString *)file {
    if ((self = [super init])) {
        store = [[ANMovieStoreFile alloc] initWithPath:file];
        if (!store) return nil;
        
        if (![self loadAtoms]) return nil;
    }
    return self;
}

- (void)close {
    [store closeStore];
    store = nil;
}

#pragma mark Private

- (BOOL)loadAtoms {
    NSMutableArray * mAtoms = [[NSMutableArray alloc] init];
    NSInteger offset = 0;
    while (offset < [store length]) {
        ANMovieAtom * atom = [ANAtomReader readAtomFromStore:store index:offset];
        if (!atom) return NO;
        [mAtoms addObject:atom];
        offset = [atom contentOffset] + [atom contentLength];
    }
    
    atoms = [[NSArray alloc] initWithArray:mAtoms];
    for (ANMovieAtom * atom in atoms) {
        if (atom.typeField == 'moov') {
            movieAtom = (ANMovieAtomGroup *)atom;
            break;
        }
    }
    tracks = [movieAtom subAtomsOfType:'trak'];
    return YES;
}

#pragma mark - Audio -

- (ANMP4ASampleDescription *)aacSampleDescription {
    ANSampleDescriptionAtom * descAtom = [[[self firstAudioTrack] sampleTable] sampleDescriptionAtom];
    ANSampleDescription * description = [[descAtom sampleDescriptions] lastObject];
    if (![description isKindOfClass:[ANMP4ASampleDescription class]]) return nil;
    return (ANMP4ASampleDescription *)description;
}

- (BOOL)bufferAACAudioData:(void (^)(NSData * data, NSInteger packetIndex, NSInteger totalPackets))callback {
    ANSampleTableAtom * sampleTable = [[self firstAudioTrack] sampleTable];
    ANChunkOffsetAtom * chunkOffset = [sampleTable chunkOffsetAtom];
    ANSampleToChunkAtom * sampleToChunk = [sampleTable sampleToChunkAtom];
    ANSampleSizeAtom * sizeAtom = [sampleTable sampleSizeAtom];
    ANMP4ASampleDescription * sampleDescription = [self aacSampleDescription];
    if (!sampleDescription || !sizeAtom || !sampleToChunk || !chunkOffset) return NO;
    
    NSUInteger sampleCount = [sampleToChunk numberOfSamplesIfNumberOfChunks:[chunkOffset.offsets count]];
    for (NSUInteger i = 0; i < sampleCount; i++) {
        NSUInteger chunkIndex = [sampleToChunk chunkIndexForSample:i];
        NSUInteger sampleIndex = [sampleToChunk sampleIndexInChunk:i];
        NSUInteger fileOffset = 0;
        
        if (sampleIndex > 0) {
            fileOffset = [sizeAtom sizeOfSamplesInRange:NSMakeRange(i - sampleIndex, sampleIndex)];
        }
        
        fileOffset += [[[chunkOffset offsets] objectAtIndex:chunkIndex] unsignedIntegerValue];
        NSUInteger sampleSize = [sizeAtom sizeOfSampleAtIndex:i];
        NSData * data = [[sampleTable store] dataAtOffset:fileOffset withLength:sampleSize];
        
        callback(data, i, sampleCount);
    }
    
    return YES;
}

- (BOOL)exportAACToFile:(NSString *)m4aFile {
    AudioFileID output = [self openM4AOutput:m4aFile];
    if (!output) return NO;
    BOOL result = [self bufferAACAudioData:^(NSData * data, NSInteger packetIndex, NSInteger totalPackets) {
        UInt32 numBytes = (UInt32)[data length];
        UInt32 numPackets = 1;
        AudioStreamPacketDescription packet;
        packet.mDataByteSize = numBytes;
        packet.mStartOffset = 0;
        packet.mVariableFramesInPacket = 0;
        OSStatus err = AudioFileWritePackets(output, FALSE, numBytes, &packet, packetIndex, &numPackets, [data bytes]);
        if (err != noErr) {
            NSLog(@"Failed to encode with CoreAudio error %x", (unsigned int)err);
        }
    }];
    
    AudioFileClose(output);
    return result;
}

#pragma mark Private

- (ANTrackAtom *)firstAudioTrack {
    for (ANTrackAtom * track in tracks) {
        ANMovieAtomGroup * mdia = [[track subAtomsOfType:'mdia'] lastObject];
        ANDataHandlerReference * ref = [[mdia subAtomsOfType:'hdlr'] lastObject];
        if (ref.componentSubtype == 'soun' && ref) return track;
    }
    return nil;
}

- (AudioFileID)openM4AOutput:(NSString *)path {
    ANMP4ASampleDescription * sampleDescription = [self aacSampleDescription];
    
    AudioStreamBasicDescription outputFormat;
    outputFormat.mFormatID = kAudioFormatMPEG4AAC;
    outputFormat.mSampleRate = [sampleDescription sampleRateDouble];
    outputFormat.mChannelsPerFrame = [sampleDescription numberOfChannels];
    // outputFormat.mBitsPerChannel = [sampleDescription sampleSize];
    outputFormat.mBitsPerChannel = 0;
    outputFormat.mBytesPerPacket = 0;
    outputFormat.mBytesPerFrame = 0;
    outputFormat.mFramesPerPacket = 1024;
    outputFormat.mFormatFlags = 0;
    
    AudioStreamBasicDescription destFormat;
    destFormat.mFormatID = kAudioFormatLinearPCM;
    destFormat.mSampleRate = [sampleDescription sampleRateDouble];
    destFormat.mChannelsPerFrame = 2;
    destFormat.mBitsPerChannel = sizeof(AudioSampleType) * 8;
    destFormat.mBytesPerPacket = sizeof(AudioSampleType) * 2;
    destFormat.mBytesPerFrame = sizeof(AudioSampleType) * 2;
    destFormat.mFramesPerPacket = 1;
    destFormat.mFormatFlags = kAudioFormatFlagsCanonical;
    
    AudioConverterRef converter;
    OSStatus err = AudioConverterNew(&destFormat, &outputFormat, &converter);
    if (err != noErr) return NULL;
    UInt32 cookieLen = 0;
    char cookieData[64];
    UInt32 len = 0;
    err = AudioConverterGetPropertyInfo(converter, kAudioConverterCompressionMagicCookie, &cookieLen, NULL);
    if (err != noErr) return NULL;
    len = cookieLen;
    err = AudioConverterGetProperty(converter, kAudioConverterCompressionMagicCookie, &len, cookieData);
    if (err != noErr) return NULL;
    
    NSURL * fileURL = [NSURL fileURLWithPath:path];
    AudioFileID audioFile;
    err = AudioFileCreateWithURL((__bridge CFURLRef)fileURL, kAudioFileM4AType,
                                 &outputFormat, kAudioFileFlags_EraseFile, &audioFile);
    if (err != noErr) return NULL;
    
    // set the magic cookie
    err = AudioFileSetProperty(audioFile, kAudioFilePropertyMagicCookieData, cookieLen, cookieData);
    if (err != noErr) return NULL;
    
    return audioFile;
}

#pragma mark - Modification -

- (void)appendData:(NSData *)data toAtom:(ANMovieAtom *)atom {
    // make room in our store for the new data
    NSUInteger oldLength = [store length];
    [store resizeStore:(oldLength + [data length])];
    NSUInteger startOffset = [atom contentOffset] + [atom contentLength];
    NSRange moveRange = NSMakeRange(startOffset, oldLength - startOffset);
    [store moveDataInRange:moveRange toOffset:(startOffset + [data length])];
    
    [store setData:data atOffset:startOffset];
    [self addLength:[data length] toAtomInFile:atom];
    
    // reload the atoms so that this atom has the new length
    [self loadAtoms];
    
    // change the chunk offsets
    [self updateChunkOffsetsBytesAdded:[data length] atIndex:startOffset];
    [self loadAtoms];
}

- (void)deleteDataInRange:(NSRange)range fromAtom:(ANMovieAtom *)atom {
    // remove our additional data
    NSUInteger oldLength = [store length];
    NSRange moveRange = NSMakeRange(range.location + range.length, oldLength - (range.location + range.length));
    [store moveDataInRange:moveRange toOffset:range.location];
    [store resizeStore:(oldLength - range.length)];
    
    // shrink the atom and reload all atoms
    [self addLength:-((NSInteger)range.length) toAtomInFile:atom];
    [self loadAtoms];
    
    // change the chunk offsets
    [self updateChunkOffsetsBytesAdded:-((NSInteger)range.length) atIndex:range.location];
    [self loadAtoms];
}

#pragma mark Private

- (void)addLength:(NSInteger)length toAtomInFile:(ANMovieAtom *)atom {
    ANMovieAtom * theAtom = atom;
    while (theAtom != nil) {
        NSUInteger newLen = ([theAtom contentOffset] + [theAtom contentLength]) - [theAtom storeOffset];
        newLen += length;
        [self writeLength:newLen forAtomInFile:theAtom];
        theAtom = theAtom.parentAtom;
    }
}

- (void)writeLength:(NSUInteger)length forAtomInFile:(ANMovieAtom *)atom {
    NSUInteger offset = 0;
    NSData * data = nil;
    if ([atom lengthField] == 1) {
        offset = [atom storeOffset] + 8;
        UInt64 len = CFSwapInt64HostToBig(length);
        data = [NSData dataWithBytes:&len length:8];
    } else {
        offset = [atom storeOffset];
        UInt32 len = CFSwapInt32HostToBig((UInt32)length);
        data = [NSData dataWithBytes:&len length:4];
    }
    [[atom store] setData:data atOffset:offset];
}

- (void)updateChunkOffsetsBytesAdded:(NSInteger)count atIndex:(NSUInteger)index {
    for (ANTrackAtom * track in tracks) {
        ANChunkOffsetAtom * offsetAtom = [[track sampleTable] chunkOffsetAtom];
        NSUInteger valueSize = [offsetAtom sizePerOffset];
        for (NSUInteger i = 0; i < [offsetAtom.offsets count]; i++) {
            NSNumber * value = [offsetAtom.offsets objectAtIndex:i];
            if ((NSUInteger)[value unsignedLongLongValue] < index) continue;
            
            NSUInteger fileOffset = [offsetAtom storeOffsetForFirstOffsetValue] + (valueSize * i);
            NSUInteger newValue = (NSUInteger)([value unsignedLongLongValue] + count);
            NSData * valueData = nil;
            
            if (valueSize == 4) {
                UInt32 val = CFSwapInt32HostToBig((UInt32)newValue);
                valueData = [NSData dataWithBytes:&val length:4];
            } else if (valueSize == 8) {
                UInt64 val = CFSwapInt64HostToBig((UInt64)newValue);
                valueData = [NSData dataWithBytes:&val length:8];
            }
            
            [store setData:valueData atOffset:fileOffset];
        }
    }
}

#pragma mark - Metadata -

- (void)setMovieMetadata:(ANMetadata *)metadata {
    ANEncodingAtom * encoding = [metadata metadataAtom];
    
    ANMovieAtomGroup * udata = [[movieAtom subAtomsOfType:'udta'] lastObject];
    if (udata) {
        NSLog(@"removing userdata atom");
        [self deleteDataInRange:[udata rangeInStore] fromAtom:udata.parentAtom];
    }
    
//    NSMutableData * freeData = [[NSMutableData alloc] init];
//    [freeData appendBytes:"\x00\x00\x00\xFF" length:4];
//    [freeData appendBytes:"free" length:4];
//    for (int i = 8; i < 0xff; i++) {
//        [freeData appendBytes:"\x00" length:1];
//    }
//    [self appendData:freeData toAtom:movieAtom];
//    return;
    
    
    
    ANEncodingAtomGroup * userdataAtom = [[ANEncodingAtomGroup alloc] initWithType:'udta' subAtoms:@[encoding]];
    NSData * userdataEncoded = [userdataAtom encode];
    
    // userdataEncoded = [NSData dataWithContentsOfFile:@"/Users/alex/Desktop/mediainfo"];
    
    // NSMutableData * myUdata = [[NSMutableData alloc] init];
    [self appendData:userdataEncoded toAtom:movieAtom];
    
}

@end
