//
//  ANChunkOffsetAtom.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/11/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANChunkOffsetAtom.h"

@interface ANChunkOffsetAtom (Private)

- (BOOL)readFields32;

@end

@implementation ANChunkOffsetAtom

@synthesize numberOfEntries;
@synthesize offsets;

+ (UInt32)specificType {
    return 'stco';
}

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index maxLength:(NSUInteger)maxLength {
    if ((self = [super initWithStore:theStore atIndex:index maxLength:maxLength])) {
        if (![self readFields32]) return nil;
    }
    return self;
}

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index {
    if ((self = [super initWithStore:theStore atIndex:index])) {
        if (![self readFields32]) return nil;
    }
    return self;
}

- (BOOL)readFields32 {
    if ([self contentLength] < 8) return NO;
    NSData * bodyData = [store dataAtOffset:([self contentOffset] + 4)
                                 withLength:([self contentLength] - 4)];
    const char * bytes = (const char *)[bodyData bytes];
    
    numberOfEntries = CFSwapInt32BigToHost(*((const UInt32 *)bytes));
    if (numberOfEntries == 0) {
        offsets = [NSArray new];
        return YES;
    }
    
    if (4 + (4 * numberOfEntries) < [bodyData length]) return NO;
    
    NSMutableArray * mOffsets = [[NSMutableArray alloc] initWithCapacity:numberOfEntries];
    const UInt32 * offsetsPtr = &((const UInt32 *)bytes)[1];
    for (NSUInteger i = 0; i < numberOfEntries; i++) {
        UInt32 offset = CFSwapInt32BigToHost(offsetsPtr[i]);
        [mOffsets addObject:[NSNumber numberWithUnsignedLong:offset]];
    }
    
    offsets = [[NSArray alloc] initWithArray:mOffsets];
    return YES;
}

- (NSUInteger)sizePerOffset {
    return 4;
}

- (NSUInteger)storeOffsetForFirstOffsetValue {
    return [self contentOffset] + 8;
}

@end
