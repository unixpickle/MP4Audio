//
//  ANAtomReader.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/10/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANAtomReader.h"

@implementation ANAtomReader

+ (Class)atomClassForAtomID:(UInt32)atomID {
    NSArray * customAtoms = @[[ANTrackHeader class], [ANDataHandlerReference class],
        [ANSampleTableAtom class], [ANSampleDescriptionAtom class],
        [ANChunkOffsetAtom class], [ANChunkOffset64Atom class],
        [ANSampleToChunkAtom class], [ANSampleSizeAtom class], [ANTrackAtom class]];
    
    // todo: get rid of udta and meta
    UInt32 groupTypes[] = {'moov', 'trak', 'minf', 'mdia', 'stbl'};
    int groupTypesCount = 5;
    
    // check our special sub-classes
    for (Class atomClass in customAtoms) {
        if ([atomClass specificType] == atomID) {
            return atomClass;
        }
    }
    
    // try a group atom
    for (int i = 0; i < groupTypesCount; i++) {
        if (groupTypes[i] == atomID) return [ANMovieAtomGroup class];
    }
    
    // default generic atom
    return [ANMovieAtom class];
}

+ (ANMovieAtom *)readAtomFromStore:(ANMovieStore *)store index:(NSInteger)index {
    if (index + 8 >= [store length]) return nil;
    NSData * typeData = [store dataAtOffset:(index + 4) withLength:4];
    if ([typeData length] != 4) return nil;
    
    UInt32 atomID = CFSwapInt32BigToHost(*((const UInt32 *)[typeData bytes]));
    Class c = [self atomClassForAtomID:atomID];
    return [[c alloc] initWithStore:store atIndex:index];
}

+ (ANMovieAtom *)readAtomFromStore:(ANMovieStore *)store index:(NSInteger)index maxLength:(NSInteger)max {
    if (index + 8 >= [store length] || max < 8) return nil;
    NSData * typeData = [store dataAtOffset:(index + 4) withLength:4];
    if ([typeData length] != 4) return nil;
    
    UInt32 atomID = CFSwapInt32BigToHost(*((const UInt32 *)[typeData bytes]));
    Class c = [self atomClassForAtomID:atomID];
    return [[c alloc] initWithStore:store atIndex:index maxLength:max];
}

@end
