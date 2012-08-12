//
//  ANQTAtomContainer.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/10/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANQTAtom.h"

@interface ANQTAtomContainer : NSObject {
    __weak ANMovieStore * store;
    NSUInteger storeOffset;
    
    char reserved[10];
    UInt16 lockCount;
    ANQTAtom * atom;
}

@property (readonly) __weak ANMovieStore * store;
@property (readonly) NSUInteger storeOffset;
@property (readonly) char * reserved;
@property (readonly) UInt16 lockCount;
@property (readonly) ANQTAtom * atom;

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index;
- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index maxLength:(NSUInteger)maxLength;

@end
