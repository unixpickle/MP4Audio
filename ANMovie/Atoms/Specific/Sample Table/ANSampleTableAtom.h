//
//  ANSampleTableAtom.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/11/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANMovieAtomGroup.h"
#import "ANSampleDescriptionAtom.h"
#import "ANSampleSizeAtom.h"
#import "ANChunkOffset64Atom.h"
#import "ANSampleToChunkAtom.h"

@interface ANSampleTableAtom : ANMovieAtomGroup

- (ANSampleDescriptionAtom *)sampleDescriptionAtom;
- (ANSampleSizeAtom *)sampleSizeAtom;
- (ANChunkOffsetAtom *)chunkOffsetAtom;
- (ANSampleToChunkAtom *)sampleToChunkAtom;
- (id)subAtomOfClass:(Class)c;

@end
