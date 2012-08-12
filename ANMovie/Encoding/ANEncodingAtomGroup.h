//
//  ANEncodingAtomGroup.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/12/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANEncodingAtom.h"

@interface ANEncodingAtomGroup : ANEncodingAtom

- (id)initWithType:(UInt32)type subAtoms:(NSArray *)atoms;

@end
