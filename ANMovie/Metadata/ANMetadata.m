//
//  ANMetadata.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/12/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANMetadata.h"

@interface ANMetadata (Private)

- (ANEncodingFullAtom *)handlerAtom;
- (NSArray *)generateEvilAppleTags;
- (NSArray *)generateTagsForKeys;
- (ANEncodingAtom *)encodeObject:(NSObject *)object withTag:(UInt32)tag;
- (ANEncodingAtom *)encodeString:(NSString *)string withTag:(UInt32)tag;
- (ANEncodingAtom *)encodeData:(NSData *)data withKnownType:(UInt32)theType tag:(UInt32)tag;

@end

@implementation ANMetadata

@synthesize artist;
@synthesize album;
@synthesize title;
@synthesize genre;
@synthesize year;
@synthesize albumCover;
@synthesize trackNumber;

- (NSData *)encodeMetadata {
    ANEncodingAtom * handler = [self handlerAtom];
    NSArray * userKeys = [self generateTagsForKeys];
    // NSArray * itunesKeys = [self generateEvilAppleTags];
    //NSArray * listItems = [itunesKeys arrayByAddingObjectsFromArray:userKeys];
    ANEncodingAtomGroup * ilist = [[ANEncodingAtomGroup alloc] initWithType:'ilst' subAtoms:userKeys];
    
    NSMutableData * data = [[NSMutableData alloc] init];
    [data appendData:[handler encode]];
    [data appendData:[ilist encode]];
    
    return [data copy];
}

- (ANEncodingAtom *)metadataAtom {
    NSData * metadataContents = [self encodeMetadata];
    return [[ANEncodingFullAtom alloc] initWithType:'meta' version:0 flags:0 body:metadataContents];
}

#pragma mark - Private -

- (ANEncodingFullAtom *)handlerAtom {
    NSMutableData * handlerData = [[NSMutableData alloc] init];
    UInt32 zero = 0;
    UInt32 handlerType = CFSwapInt32HostToBig('mdir');
    [handlerData appendBytes:&zero length:4];
    [handlerData appendBytes:&handlerType length:4];
    // reserved
    [handlerData appendBytes:"appl" length:4];
    [handlerData appendBytes:&zero length:4];
    [handlerData appendBytes:&zero length:4];
    // handler name
    [handlerData appendData:[@"Alex Is The Man" dataUsingEncoding:NSUTF8StringEncoding]];
    [handlerData appendBytes:&zero length:2];
    return [[ANEncodingFullAtom alloc] initWithType:'hdlr' version:0 flags:0 body:[handlerData copy]];
}

- (NSArray *)generateEvilAppleTags {
    ANEncodingFullAtom * mean = [[ANEncodingFullAtom alloc] initWithType:'mean'
                                                                 version:0
                                                                   flags:0
                                                                    body:[@"com.apple.iTunes" dataUsingEncoding:NSASCIIStringEncoding]];
    ANEncodingFullAtom * smpbName = [[ANEncodingFullAtom alloc] initWithType:'name'
                                                                     version:0
                                                                       flags:0
                                                                        body:[@"iTunSMPB" dataUsingEncoding:NSASCIIStringEncoding]];
    ANEncodingFullAtom * normName = [[ANEncodingFullAtom alloc] initWithType:'name'
                                                                     version:0
                                                                       flags:0
                                                                        body:[@"iTunNORM" dataUsingEncoding:NSASCIIStringEncoding]];
    NSData * smpbData = [NSData dataWithBytes:"\x00\x00\x00\x01\x00\x00\x00\x00\x20\x30\x30\x30\x30\x30\x30\x30\x30\x20\x30\x30\x30\x30\x30\x38\x34\x30\x20\x30\x30\x30\x30\x30\x33\x30\x46\x20\x30\x30\x30\x30\x30\x30\x30\x30\x30\x30\x38\x32\x44\x43\x42\x31\x20\x30\x30\x30\x30\x30\x30\x30\x30\x20\x30\x30\x30\x30\x30\x30\x30\x30\x20\x30\x30\x30\x30\x30\x30\x30\x30\x20\x30\x30\x30\x30\x30\x30\x30\x30\x20\x30\x30\x30\x30\x30\x30\x30\x30\x20\x30\x30\x30\x30\x30\x30\x30\x30\x20\x30\x30\x30\x30\x30\x30\x30\x30\x20\x30\x30\x30\x30\x30\x30\x30\x30" length:0x7c];
    NSData * normData = [NSData dataWithBytes:"\x00\x00\x00\x01\x00\x00\x00\x00\x20\x30\x30\x30\x30\x31\x41\x42\x44\x20\x30\x30\x30\x30\x31\x42\x34\x35\x20\x30\x30\x30\x30\x36\x37\x32\x30\x20\x30\x30\x30\x30\x37\x37\x39\x41\x20\x30\x30\x30\x32\x43\x34\x33\x35\x20\x30\x30\x30\x31\x39\x39\x34\x30\x20\x30\x30\x30\x30\x37\x46\x45\x32\x20\x30\x30\x30\x30\x37\x46\x45\x33\x20\x30\x30\x30\x30\x36\x45\x34\x42\x20\x30\x30\x30\x30\x36\x38\x37\x44" length:0x62];
    ANEncodingAtom * smpbDataAtom = [[ANEncodingAtom alloc] initWithType:'data' body:smpbData];
    ANEncodingAtom * normDataAtom = [[ANEncodingAtom alloc] initWithType:'data' body:normData];
    
    ANEncodingAtomGroup * smpbGroup = [[ANEncodingAtomGroup alloc] initWithType:'----' subAtoms:@[mean, smpbName, smpbDataAtom]];
    ANEncodingAtomGroup * normGroup = [[ANEncodingAtomGroup alloc] initWithType:'----' subAtoms:@[mean, normName, normDataAtom]];
    
    return @[smpbGroup, normGroup];
}

- (NSArray *)generateTagsForKeys {
    NSMutableArray * mAtoms = [[NSMutableArray alloc] init];
    
    if (title) [mAtoms addObject:[self encodeObject:title withTag:'\xA9nam']];
    if (artist) {
        [mAtoms addObject:[self encodeObject:artist withTag:'\xA9\x41\x52\x54']];
        [mAtoms addObject:[self encodeObject:artist withTag:'aART']];
    }
    if (album) [mAtoms addObject:[self encodeObject:album withTag:'\xA9\x61\x6C\x62']];
    if (genre) [mAtoms addObject:[self encodeObject:genre withTag:'\xA9\x67\x65\x6E']];
    if (trackNumber) [mAtoms addObject:[self encodeObject:trackNumber withTag:'trkn']];
    if (year) [mAtoms addObject:[self encodeObject:year withTag:'\xA9\x64\x61\x79']];
    if (albumCover) [mAtoms addObject:[self encodeObject:albumCover withTag:'covr']];
    
    return [mAtoms copy];
}

- (ANEncodingAtom *)encodeObject:(NSObject *)object withTag:(UInt32)tag {
    if ([object isKindOfClass:[NSString class]]) {
        return [self encodeString:(NSString *)object withTag:tag];
    } else if ([object isKindOfClass:[ANMetadataImage class]]) {
        ANMetadataImage * image = (ANMetadataImage *)object;
        return [self encodeData:image.imageData withKnownType:image.type tag:tag];
    } else if ([object isKindOfClass:[ANMetadataTrack class]]) {
        ANMetadataTrack * track = (ANMetadataTrack *)object;
        return [self encodeData:[track encodeTrackInfo] withKnownType:0 tag:tag];
    }
    return nil;
}

- (ANEncodingAtom *)encodeString:(NSString *)string withTag:(UInt32)tag {
    NSData * buffer = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self encodeData:buffer withKnownType:1 tag:tag];
}

- (ANEncodingAtom *)encodeData:(NSData *)data withKnownType:(UInt32)theType tag:(UInt32)tag {
    NSMutableData * dataBody = [[NSMutableData alloc] init];
    UInt32 type = CFSwapInt32HostToBig(theType);
    UInt32 locale = 0;
    [dataBody appendBytes:&type length:4];
    [dataBody appendBytes:&locale length:4];
    [dataBody appendData:data];
    ANEncodingAtom * dataAtom = [[ANEncodingAtom alloc] initWithType:'data' body:[dataBody copy]];
    return [[ANEncodingAtomGroup alloc] initWithType:tag subAtoms:@[dataAtom]];
}

@end
