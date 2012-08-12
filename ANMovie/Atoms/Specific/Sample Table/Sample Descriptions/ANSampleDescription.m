//
//  ANSampleDescription.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/11/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANSampleDescription.h"
#import "ANMP4ASampleDescription.h"

@implementation ANSampleDescription

@synthesize store;
@synthesize storeOffset;
@synthesize descriptionSize;
@synthesize dataFormat;
@synthesize dataReferenceIndex;
@synthesize descriptionBody;

- (const char *)reserved {
    return reserved;
}

+ (UInt32)specificDataFormat {
    return 0;
}

+ (id)sampleDescriptionWithStore:(ANMovieStore *)store atIndex:(NSUInteger)index maxLength:(NSUInteger)maxLength {
    if (maxLength < 16) return nil;
    Class customClasses = [NSArray arrayWithObject:[ANMP4ASampleDescription class]];
    NSData * formatDat = [store dataAtOffset:(index + 4) withLength:maxLength];
    UInt32 format = CFSwapInt32BigToHost(*((const UInt32 *)[formatDat bytes]));
    for (Class aClass in customClasses) {
        if ([aClass specificDataFormat] == format) {
            return [[aClass alloc] initWithStore:store atIndex:index maxLength:maxLength];
        }
    }
    return [[ANSampleDescription alloc] initWithStore:store atIndex:index maxLength:maxLength];
}

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index maxLength:(NSUInteger)maxLength {
    if ((self = [super init])) {
        storeOffset = index;
        store = theStore;
        
        if (maxLength < 16) return nil;
        NSData * headerData = [theStore dataAtOffset:index withLength:16];
        const char * bytes = (const char *)[headerData bytes];
        descriptionSize = CFSwapInt32BigToHost(*((const UInt32 *)bytes));
        if (descriptionSize > maxLength || descriptionSize < 16) return nil;
        dataFormat = CFSwapInt32BigToHost(((const UInt32 *)bytes)[1]);
        memcpy(reserved, &bytes[8], 6);
        dataReferenceIndex = CFSwapInt16BigToHost(((const UInt16 *)bytes)[5]);
        descriptionBody = [theStore dataAtOffset:(index + 16)
                                      withLength:(descriptionSize - 16)];
    }
    return self;
}

- (NSUInteger)contentOffset {
    return storeOffset + 16;
}

- (NSUInteger)contentLength {
    return descriptionSize - 16;
}

@end
