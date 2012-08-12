//
//  ANMovieAtomGroup.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/10/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANMovieAtom.h"

@interface ANMovieAtomGroup : ANMovieAtom {
    NSArray * subAtoms;
}

@property (readonly) NSArray * subAtoms;

- (NSArray *)subAtomsOfType:(UInt32)type;

@end
