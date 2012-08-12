//
//  ANSampleDescription.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/11/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANMovieStore.h"

@interface ANSampleDescription : NSObject {
    __weak ANMovieStore * store;
    NSUInteger storeOffset;
    
    UInt32 descriptionSize;
    UInt32 dataFormat;
    char reserved[6];
    UInt16 dataReferenceIndex;
    NSData * descriptionBody;
}

@property (readonly) ANMovieStore * store;
@property (readonly) NSUInteger storeOffset;

@property (readonly) UInt32 descriptionSize;
@property (readonly) UInt32 dataFormat;
@property (readonly) const char * reserved;
@property (readonly) UInt16 dataReferenceIndex;
@property (readonly) NSData * descriptionBody;

+ (UInt32)specificDataFormat;
+ (id)sampleDescriptionWithStore:(ANMovieStore *)store atIndex:(NSUInteger)index maxLength:(NSUInteger)maxLength;

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index maxLength:(NSUInteger)maxLength;
- (NSUInteger)contentOffset;
- (NSUInteger)contentLength;

@end
