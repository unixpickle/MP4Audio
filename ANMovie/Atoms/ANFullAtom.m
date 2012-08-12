//
//  ANVersionedAtom.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/11/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANFullAtom.h"

@implementation ANFullAtom

@synthesize version;
@synthesize flags;

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index {
    if ((self = [super initWithStore:theStore atIndex:index])) {
        if ([self contentLength] < 4) return nil;
        NSData * fullData = [store dataAtOffset:[self contentOffset]
                                     withLength:4];
        const char * bytes = (const char *)[fullData bytes];
        version = bytes[0];
        flags = CFSwapInt32BigToHost(*((const UInt32 *)bytes)) & 0xFFFFFF;
    }
    return self;
}

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index maxLength:(NSUInteger)maxLength {
    if ((self = [super initWithStore:theStore atIndex:index maxLength:maxLength])) {
        if ([self contentLength] < 4) return nil;
        NSData * fullData = [store dataAtOffset:[self contentOffset]
                                     withLength:4];
        const char * bytes = (const char *)[fullData bytes];
        version = bytes[0];
        flags = CFSwapInt32BigToHost(*((const UInt32 *)bytes)) & 0xFFFFFF;
    }
    return self;
}

@end
