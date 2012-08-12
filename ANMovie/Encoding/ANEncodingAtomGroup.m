//
//  ANEncodingAtomGroup.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/12/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANEncodingAtomGroup.h"

@implementation ANEncodingAtomGroup

- (id)initWithType:(UInt32)theType subAtoms:(NSArray *)atoms {
    NSMutableData * data = [NSMutableData data];
    for (ANEncodingAtom * atom in atoms) {
        [data appendData:[atom encode]];
    }
    return (self = [super initWithType:theType body:[data copy]]);
}

@end
