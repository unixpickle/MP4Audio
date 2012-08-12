//
//  ANQTAtom.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/10/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANMovieStore.h"

@interface ANQTAtom : NSObject {
    __weak ANMovieStore * store;
    NSUInteger storeOffset;
    
    UInt32 size;
    UInt32 type;
    UInt32 atomID;
    UInt16 reserved1;
    UInt16 childCount;
    UInt32 reserved2;
    
    NSArray * children;
}

@property (readonly) __weak ANMovieStore * store;
@property (readonly) NSUInteger storeOffset;

@property (readonly) UInt32 size;
@property (readonly) UInt32 type;
@property (readonly) UInt32 atomID;
@property (readonly) UInt16 reserved1;
@property (readonly) UInt16 childCount;
@property (readonly) UInt32 reserved2;

@property (readonly) NSArray * children;

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index;
- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index maxLength:(NSUInteger)maxLength;

- (NSUInteger)contentOffset;
- (NSUInteger)contentLength;

@end
