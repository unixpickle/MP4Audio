//
//  ANMovieStore.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/10/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANMovieStore.h"

@implementation ANMovieStore

- (NSUInteger)length {
    [self doesNotRecognizeSelector:@selector(length)];
    return 0;
}

- (NSData *)dataAtOffset:(NSUInteger)offset withLength:(NSUInteger)length {
    [self doesNotRecognizeSelector:@selector(dataAtOffset:withLength:)];
    return nil;
}

- (void)resizeStore:(NSUInteger)newSize {
    [self doesNotRecognizeSelector:@selector(resizeStore:)];
}

- (void)setData:(NSData *)data atOffset:(NSUInteger)offset {
    [self doesNotRecognizeSelector:@selector(setData:atOffset:)];
}

- (void)moveDataInRange:(NSRange)range toOffset:(NSUInteger)offset {
    NSUInteger sourceOffset = 0;
    NSUInteger destOffset = 0;
    NSInteger hop = 0;
    NSInteger currentHop = 0;
    NSUInteger buffersLeft = 0;
    
    if (range.location > offset) {
        sourceOffset = range.location;
        destOffset = offset;
        // calculate statistics for copying buffers
        hop = kANMovieStoreBufferSize;
        buffersLeft = range.length / hop;
        currentHop = range.length % hop;
        if (currentHop != 0) {
            buffersLeft += 1;
        } else {
            currentHop = hop;
        }
    } else {
        // calculate statistics for copying buffers
        hop = -kANMovieStoreBufferSize;
        buffersLeft = range.length / ABS(hop);
        currentHop = -((NSInteger)range.length % ABS(hop));
        if (currentHop != 0) {
            buffersLeft += 1;
        } else {
            currentHop = hop;
        }
        
        sourceOffset = range.location + range.length - ABS(currentHop);
        destOffset = offset + range.length - ABS(currentHop);
    }
    
    while (buffersLeft > 0) {
        buffersLeft--;

        NSData * buffer = [self dataAtOffset:sourceOffset withLength:ABS(currentHop)];
        [self setData:buffer atOffset:destOffset];
        
        if (currentHop < 0) {
            currentHop = hop;
        }
        sourceOffset += currentHop;
        destOffset += currentHop;
        if (currentHop > 0) {
            currentHop = hop;
        }
    }
}

- (void)closeStore {
    [self doesNotRecognizeSelector:@selector(closeStore)];
}

@end
