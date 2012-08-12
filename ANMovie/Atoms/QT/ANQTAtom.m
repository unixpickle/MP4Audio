//
//  ANQTAtom.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/10/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANQTAtom.h"

@implementation ANQTAtom

@synthesize store;
@synthesize storeOffset;
@synthesize size;
@synthesize type;
@synthesize atomID;
@synthesize reserved1;
@synthesize childCount;
@synthesize reserved2;
@synthesize children;

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index {
    if ((self = [super init])) {
        if (index + 20 > [theStore length]) return nil;
        
        store = theStore;
        storeOffset = index;
        
        NSData * headerData = [theStore dataAtOffset:index withLength:20];
        const char * bytes = [headerData bytes];
        size = CFSwapInt32BigToHost(*((const UInt32 *)bytes));
        type = CFSwapInt32BigToHost(((const UInt32 *)bytes)[1]);
        atomID = CFSwapInt32BigToHost(((const UInt32 *)bytes)[2]);
        reserved1 = CFSwapInt16BigToHost(((const UInt16 *)bytes)[6]);
        childCount = CFSwapInt16BigToHost(((const UInt16 *)bytes)[7]);
        reserved2 = CFSwapInt32BigToHost(((const UInt32 *)bytes)[4]);
        
        if (childCount > 0) {
            NSMutableArray * mChildren = [[NSMutableArray alloc] initWithCapacity:childCount];
            NSUInteger offset = [self contentOffset];
            for (int i = 0; i < childCount; i++) {
                NSUInteger maxLen = [self contentLength] - (offset - [self contentOffset]);
                ANQTAtom * subAtom = [[ANQTAtom alloc] initWithStore:store atIndex:offset maxLength:maxLen];
                if (!subAtom) return nil;
                [mChildren addObject:subAtom];
            }
            children = [[NSArray alloc] initWithArray:mChildren];
        }
    }
    return self;
}

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index maxLength:(NSUInteger)maxLength {
    if ((self = [self initWithStore:theStore atIndex:index])) {
        if ([self contentLength] + [self contentOffset] - index > maxLength) {
            return nil;
        }
    }
    return self;
}

- (NSUInteger)contentOffset {
    return storeOffset + 20;
}

- (NSUInteger)contentLength {
    return size - 20;
}

@end
