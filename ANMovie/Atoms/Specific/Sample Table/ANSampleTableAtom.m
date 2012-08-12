//
//  ANSampleTableAtom.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/11/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANSampleTableAtom.h"

@implementation ANSampleTableAtom

+ (UInt32)specificType {
    return 'stbl';
}

- (ANSampleDescriptionAtom *)sampleDescriptionAtom {
    return [self subAtomOfClass:[ANSampleDescriptionAtom class]];
}

- (ANSampleSizeAtom *)sampleSizeAtom {
    return [self subAtomOfClass:[ANSampleSizeAtom class]];
}

- (ANChunkOffsetAtom *)chunkOffsetAtom {
    // co64 overcomes stco
    id obj = [self subAtomOfClass:[ANChunkOffset64Atom class]];
    if (obj) return obj;
    return [self subAtomOfClass:[ANChunkOffsetAtom class]];
}

- (ANSampleToChunkAtom *)sampleToChunkAtom {
    return [self subAtomOfClass:[ANSampleToChunkAtom class]];
}

- (id)subAtomOfClass:(Class)c {
    for (ANMovieAtom * atom in subAtoms) {
        if ([atom isKindOfClass:c]) {
            return atom;
        }
    }
    return NO;
}

@end
