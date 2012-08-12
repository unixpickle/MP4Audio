//
//  ANMovieAtom.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/10/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANMovieAtom.h"

@implementation ANMovieAtom

@synthesize parentAtom;
@synthesize store;
@synthesize storeOffset;
@synthesize lengthField;
@synthesize typeField;
@synthesize extendedLength;

+ (UInt32)specificType {
    return 0;
}

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index {
    if ((self = [super init])) {
        if (index + 8 >= [theStore length]) return nil;
        store = theStore;
        storeOffset = index;
        
        NSData * headerData = [store dataAtOffset:index withLength:8];
        if ([headerData length] != 8) return nil;
        
        const UInt32 * fields = (const UInt32 *)[headerData bytes];
        lengthField = CFSwapInt32BigToHost(fields[0]);
        typeField = CFSwapInt32BigToHost(fields[1]);
        if (lengthField == 1) {
            if (index + 16 >= [theStore length]) return nil;
            NSData * extField = [theStore dataAtOffset:(index + 8) withLength:8];
            if ([extField length] != 8) return nil;
            extendedLength = CFSwapInt64BigToHost(*(const UInt64 *)[extField bytes]);
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

- (NSInteger)contentOffset {
    if (lengthField == 1) return storeOffset + 16;
    return storeOffset + 8;
}

- (NSInteger)contentLength {
    if (lengthField == 1) {
        return extendedLength - 16;
    } else if (lengthField == 0) {
        return [store length] - [self contentOffset];
    }
    return lengthField - 8;
}

- (NSRange)rangeInStore {
    return NSMakeRange(storeOffset, [self contentLength] + [self contentOffset] - storeOffset);
}

- (NSString *)description {
    char typeStr[5];
    typeStr[4] = 0;
    UInt32 typeOrig = CFSwapInt32HostToBig(typeField);
    memcpy(typeStr, &typeOrig, 4);
    return [NSString stringWithFormat:@"<%@ type=%s>", NSStringFromClass([self class]), typeStr];
}

@end
