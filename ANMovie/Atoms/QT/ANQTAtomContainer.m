//
//  ANQTAtomContainer.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/10/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANQTAtomContainer.h"

@implementation ANQTAtomContainer

@synthesize store;
@synthesize storeOffset;
@synthesize lockCount;
@synthesize atom;

- (char *)reserved {
    return reserved;
}

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index {
    if ((self = [super init])) {
        if (index + 12 < [theStore length]) return nil;
        NSData * headerData = [theStore dataAtOffset:index withLength:12];
        memcpy(reserved, [headerData bytes], 10);
        lockCount = CFSwapInt16BigToHost(((const UInt16 *)[headerData bytes])[5]);
        atom = [[ANQTAtom alloc] initWithStore:theStore atIndex:(index + 12)];
        if (!atom) return nil;
    }
    return self;
}

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index maxLength:(NSUInteger)maxLength {
    if ((self = [self initWithStore:theStore atIndex:index])) {
        if ([atom contentLength] + [atom contentOffset] - index > maxLength) {
            return nil;
        }
    }
    return self;
}

@end
