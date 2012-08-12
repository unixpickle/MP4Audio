//
//  ANSampleToChunkAtom.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/11/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANFullAtom.h"
#import "ANSampleToChunkEntry.h"

@interface ANSampleToChunkAtom : ANFullAtom {
    UInt32 numberOfEntries;
    NSArray * entries;
    
    // cache for chunkIndexForSample:
    NSInteger cacheSample;
    NSInteger cacheChunk;
    
    // cache for samplesInChunkNumber:
    NSInteger cacheChunkIndex;
    NSInteger cacheSTCIndex;
}

@property (readonly) UInt32 numberOfEntries;
@property (readonly) NSArray * entries;

- (NSUInteger)samplesInChunkNumber:(NSUInteger)chunkIndex;
- (NSUInteger)chunkIndexForSample:(NSUInteger)sampleIndex;
- (NSUInteger)sampleIndexInChunk:(NSUInteger)sampleIndex;
- (NSUInteger)numberOfSamplesIfNumberOfChunks:(NSUInteger)chunkCount;

@end
