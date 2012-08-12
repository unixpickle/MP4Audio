//
//  ANMovieAtomGroup.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/10/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANMovieAtomGroup.h"
#import "ANAtomReader.h"

@interface ANMovieAtomGroup (Private)

- (BOOL)readSubAtoms;

@end

@implementation ANMovieAtomGroup

@synthesize subAtoms;

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index {
    if ((self = [super initWithStore:theStore atIndex:index])) {
        if (![self readSubAtoms]) return nil;
    }
    return self;
}

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index maxLength:(NSUInteger)maxLength {
    if ((self = [super initWithStore:theStore atIndex:index maxLength:maxLength])) {
        if (![self readSubAtoms]) return nil;
    }
    return self;
}

- (BOOL)readSubAtoms {
    NSMutableArray * mSubAtoms = [[NSMutableArray alloc] init];
    NSInteger offset = [self contentOffset];
    NSInteger maxOffset = [self contentLength] + offset;
    while (offset < maxOffset) {
        ANMovieAtom * atom = [ANAtomReader readAtomFromStore:store index:offset maxLength:(maxOffset - offset)];
        if (!atom) return NO;
        atom.parentAtom = self;
        [mSubAtoms addObject:atom];
        offset = [atom contentOffset] + [atom contentLength];
    }
    
    subAtoms = [[NSArray alloc] initWithArray:mSubAtoms];
    return YES;
}

- (NSArray *)subAtomsOfType:(UInt32)type {
    NSMutableArray * mAtoms = [[NSMutableArray alloc] init];
    for (ANMovieAtom * atom in subAtoms) {
        if ([atom typeField] == type) [mAtoms addObject:atom];
    }
    return [NSArray arrayWithArray:mAtoms];
}

@end
