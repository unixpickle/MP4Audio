//
//  ANSampleSizeAtom.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/11/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANSampleSizeAtom.h"

@interface ANSampleSizeAtom (Private)

- (BOOL)readFields;

@end

@implementation ANSampleSizeAtom

@synthesize sampleSize;
@synthesize numberOfEntries;
@synthesize sizes;

+ (UInt32)specificType {
    return 'stsz';
}

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index {
    if ((self = [super initWithStore:theStore atIndex:index])) {
        if (![self readFields]) return nil;
    }
    return self;
}

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index maxLength:(NSUInteger)maxLength {
    if ((self = [super initWithStore:theStore atIndex:index maxLength:maxLength])) {
        if (![self readFields]) return nil;
    }
    return self;
}

- (BOOL)readFields {
    if ([self contentLength] < 12) return NO;
    NSData * bodyData = [store dataAtOffset:([self contentOffset] + 4)
                                 withLength:([self contentLength] - 4)];
    const char * bytes = (const char *)[bodyData bytes];
    sampleSize = CFSwapInt32BigToHost(*((const UInt32 *)bytes));
    numberOfEntries = CFSwapInt32BigToHost(((const UInt32 *)bytes)[1]);
    
    if (numberOfEntries * 4 + 8 < [bodyData length]) return NO;
    
    const UInt32 * entries = &(((const UInt32 *)bytes)[2]);
    NSMutableArray * mSizes = [[NSMutableArray alloc] initWithCapacity:numberOfEntries];
    for (int i = 0; i < numberOfEntries; i++) {
        UInt32 entry = CFSwapInt32BigToHost(entries[i]);
        [mSizes addObject:[NSNumber numberWithUnsignedLong:entry]];
    }
    sizes = [[NSArray alloc] initWithArray:mSizes];
    return YES;
}

- (NSUInteger)sizeOfSampleAtIndex:(NSUInteger)sampleIndex {
    if (sampleSize) return sampleSize;
    if (sampleIndex >= [sizes count]) return 0;
    return [[sizes objectAtIndex:sampleIndex] unsignedIntegerValue];
}

- (NSUInteger)sizeOfSamplesInRange:(NSRange)range {
    if (sampleSize) return range.length * sampleSize;
    NSUInteger size = 0;
    for (NSUInteger i = range.location; i < range.location + range.length; i++) {
        size += [self sizeOfSampleAtIndex:i];
    }
    return size;
}

@end
