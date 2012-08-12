//
//  ANEncodingFullAtomGroup.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/12/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANEncodingFullAtom.h"

@interface ANEncodingFullAtomGroup : ANEncodingFullAtom

- (id)initWithType:(UInt32)theType version:(UInt8)theVersion flags:(UInt32)theFlags body:(NSData *)theBody subAtoms:(NSArray *)atoms;

@end
