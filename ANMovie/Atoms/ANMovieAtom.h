//
//  ANMovieAtom.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/10/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANMovieStore.h"

@interface ANMovieAtom : NSObject {
    __weak ANMovieAtom * parentAtom;
    __weak ANMovieStore * store;
    NSUInteger storeOffset;
    
    UInt32 lengthField;
    UInt32 typeField;
    UInt64 extendedLength;
}

@property (readwrite) __weak ANMovieAtom * parentAtom;
@property (readonly) ANMovieStore * store;
@property (readonly) NSUInteger storeOffset;

@property (readonly) UInt32 lengthField;
@property (readonly) UInt32 typeField;
@property (readonly) UInt64 extendedLength;

+ (UInt32)specificType;

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index;
- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index maxLength:(NSUInteger)maxLength;
- (NSInteger)contentOffset;
- (NSInteger)contentLength;
- (NSRange)rangeInStore;

@end
