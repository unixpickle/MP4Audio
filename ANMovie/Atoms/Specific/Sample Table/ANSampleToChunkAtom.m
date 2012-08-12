//
//  ANSampleToChunkAtom.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/11/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANSampleToChunkAtom.h"

@interface ANSampleToChunkAtom (Private)

- (BOOL)readFields;

@end

@implementation ANSampleToChunkAtom

@synthesize numberOfEntries;
@synthesize entries;

+ (UInt32)specificType {
    return 'stsc';
}

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index {
    if ((self = [super initWithStore:theStore atIndex:index])) {
        if (![self readFields]) return nil;
        cacheSample = -1;
        cacheChunk = -1;
        cacheChunkIndex = 1;
        cacheSTCIndex = 1;
    }
    return self;
}

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index maxLength:(NSUInteger)maxLength {
    if ((self = [super initWithStore:theStore atIndex:index maxLength:maxLength])) {
        if (![self readFields]) return nil;
        cacheSample = -1;
        cacheChunk = -1;
    }
    return self;
}

- (BOOL)readFields {
    if ([self contentLength] < 8) return NO;
    NSData * bodyData = [store dataAtOffset:([self contentOffset] + 4)
                                 withLength:([self contentLength] - 4)];
    const char * bytes = [bodyData bytes];
    numberOfEntries = CFSwapInt32BigToHost(*((const UInt32 *)bytes));
    if (numberOfEntries * 12 + 4 > [bodyData length]) return NO;
    
    NSMutableArray * mEntries = [[NSMutableArray alloc] initWithCapacity:numberOfEntries];
    for (int i = 0; i < numberOfEntries; i++) {
        NSInteger offset = 4 + (i * 12);
        ANSampleToChunkEntry * entry = [[ANSampleToChunkEntry alloc] initWithBytes:&bytes[offset]];
        [mEntries addObject:entry];
    }
    
    entries = [[NSArray alloc] initWithArray:mEntries];
    return YES;
}

#pragma mark - Lookup -

- (NSUInteger)samplesInChunkNumber:(NSUInteger)chunkIndex {
    if ([entries count] == 0) return 1;
    if ([entries count] == 1) {
        ANSampleToChunkEntry * entry = [entries lastObject];
        return [entry samplesPerChunk];
    }
    NSUInteger startIndex = 1;
    if (cacheChunkIndex <= chunkIndex) {
        startIndex = cacheSTCIndex;
    }
    ANSampleToChunkEntry * lastEntry = [entries objectAtIndex:(startIndex - 1)];
    for (NSUInteger i = startIndex; i < [entries count]; i++) {
        ANSampleToChunkEntry * entry = [entries objectAtIndex:i];
        if ([entry firstChunk] > chunkIndex) {
            cacheSTCIndex = i;
            cacheChunkIndex = chunkIndex;
            break;
        }
        lastEntry = entry;
    }
    return [lastEntry samplesPerChunk];
}

- (NSUInteger)chunkIndexForSample:(NSUInteger)sampleIndex {
    NSUInteger chunkNumber = 1;
    NSUInteger sampleCount = 0;
    if (sampleIndex >= cacheSample) {
        chunkNumber = cacheChunk;
        sampleCount = cacheSample;
    }
    while (sampleCount <= sampleIndex) {
        NSUInteger numSamples = [self samplesInChunkNumber:chunkNumber];
        if (sampleCount <= sampleIndex && sampleIndex < sampleCount + numSamples) {
            break;
        }
        chunkNumber++;
        sampleCount += numSamples;
    }
    cacheChunk = chunkNumber;
    cacheSample = sampleCount;
    return chunkNumber - 1;
}

- (NSUInteger)sampleIndexInChunk:(NSUInteger)sampleIndex {
    NSUInteger chunkNumber = 1;
    NSUInteger sampleCount = 0;
    while (sampleCount <= sampleIndex) {
        NSUInteger numSamples = [self samplesInChunkNumber:chunkNumber];
        if (sampleCount <= sampleIndex && sampleIndex < sampleCount + numSamples) {
            break;
        }
        chunkNumber++;
        sampleCount += numSamples;
    }
    return sampleIndex - sampleCount;
}

- (NSUInteger)numberOfSamplesIfNumberOfChunks:(NSUInteger)chunkCount {
    NSUInteger sampleCount = 0;
    for (NSUInteger i = 0; i < chunkCount; i++) {
        sampleCount += [self samplesInChunkNumber:(i + 1)];
    }
    return sampleCount;
}

@end
