//
//  ANChunkOffsetAtom.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/11/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANFullAtom.h"

@interface ANChunkOffsetAtom : ANFullAtom {
    UInt32 numberOfEntries;
    NSArray * offsets;
}

@property (readonly) UInt32 numberOfEntries;
@property (readonly) NSArray * offsets;

- (NSUInteger)sizePerOffset;
- (NSUInteger)storeOffsetForFirstOffsetValue;

@end
