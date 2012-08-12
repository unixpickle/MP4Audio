//
//  ANChunkOffset64Atom.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/11/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANChunkOffset64Atom.h"

@interface ANChunkOffset64Atom (Private)

- (BOOL)readFields64;

@end

@implementation ANChunkOffset64Atom

+ (UInt32)specificType {
    return 'co64';
}

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index maxLength:(NSUInteger)maxLength {
    if ((self = [super initWithStore:theStore atIndex:index maxLength:maxLength])) {
        if (![self readFields64]) return nil;
    }
    return self;
}

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index {
    if ((self = [super initWithStore:theStore atIndex:index])) {
        if (![self readFields64]) return nil;
    }
    return self;
}

- (BOOL)readFields64 {
    if ([self contentLength] < 8) return NO;
    NSData * bodyData = [store dataAtOffset:([self contentOffset] + 4)
                                 withLength:([self contentLength] - 4)];
    const char * bytes = (const char *)[bodyData bytes];
    
    numberOfEntries = CFSwapInt32BigToHost(*((const UInt32 *)bytes));
    if (numberOfEntries == 0) {
        offsets = [NSArray new];
        return YES;
    }
    
    if (4 + (8 * numberOfEntries) < [bodyData length]) return NO;
    
    NSMutableArray * mOffsets = [[NSMutableArray alloc] initWithCapacity:numberOfEntries];
    const UInt64 * offsetsPtr = (const UInt64 *)(&bytes[4]);
    for (NSUInteger i = 0; i < numberOfEntries; i++) {
        UInt64 offset = CFSwapInt64BigToHost(offsetsPtr[i]);
        [mOffsets addObject:[NSNumber numberWithUnsignedLongLong:offset]];
    }
    
    offsets = [[NSArray alloc] initWithArray:mOffsets];
    return YES;
}

- (NSUInteger)sizePerOffset {
    return 8;
}

- (NSUInteger)storeOffsetForFirstOffsetValue {
    return [self contentOffset] + 8;
}

@end
