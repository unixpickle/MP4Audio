//
//  ANEncodingFullAtomGroup.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/12/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANEncodingFullAtomGroup.h"

@implementation ANEncodingFullAtomGroup

- (id)initWithType:(UInt32)theType version:(UInt8)theVersion flags:(UInt32)theFlags body:(NSData *)theBody subAtoms:(NSArray *)atoms {
    NSMutableData * data = [NSMutableData data];
    for (ANEncodingAtom * atom in atoms) {
        [data appendData:[atom encode]];
    }
    return (self = [super initWithType:theType version:theVersion flags:theFlags body:[data copy]]);
}

@end
