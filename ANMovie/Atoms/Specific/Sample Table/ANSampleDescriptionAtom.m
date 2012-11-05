//
//  ANSampleDescriptionAtom.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/11/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANSampleDescriptionAtom.h"

@interface ANSampleDescriptionAtom (Private)

- (BOOL)readFields;

@end

@implementation ANSampleDescriptionAtom

@synthesize numberOfEntries;
@synthesize sampleDescriptions;

+ (UInt32)specificType {
    return 'stsd';
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
    if ([self contentLength] < 8) return NO;
    NSData * countData = [store dataAtOffset:([self contentOffset] + 4)
                                  withLength:4];
    numberOfEntries = CFSwapInt32BigToHost(*((const UInt32 *)[countData bytes]));
    
    // read the sample descriptions
    NSMutableArray * mSampleDescriptions = [[NSMutableArray alloc] initWithCapacity:numberOfEntries];
    NSUInteger offset = ([self contentOffset] + 8);
    NSUInteger maxOffset = [self contentOffset] + [self contentLength];
    for (NSUInteger i = 0; i < numberOfEntries; i++) {
        ANSampleDescription * desc = [ANSampleDescription sampleDescriptionWithStore:store
                                                                             atIndex:offset
                                                                           maxLength:(maxOffset - offset)];
        if (!desc) return NO;
        [mSampleDescriptions addObject:desc];
        offset = [desc contentOffset] + [desc contentLength];
    }
    
    sampleDescriptions = [[NSArray alloc] initWithArray:mSampleDescriptions];
    return YES;
}

@end
