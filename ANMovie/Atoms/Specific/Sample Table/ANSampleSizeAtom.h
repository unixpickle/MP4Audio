//
//  ANSampleSizeAtom.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/11/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANFullAtom.h"

@interface ANSampleSizeAtom : ANFullAtom {
    UInt32 sampleSize;
    UInt32 numberOfEntries;
    NSArray * sizes;
}

@property (readonly) UInt32 sampleSize;
@property (readonly) UInt32 numberOfEntries;
@property (readonly) NSArray * sizes;

- (NSUInteger)sizeOfSampleAtIndex:(NSUInteger)sampleIndex;
- (NSUInteger)sizeOfSamplesInRange:(NSRange)range;

@end
