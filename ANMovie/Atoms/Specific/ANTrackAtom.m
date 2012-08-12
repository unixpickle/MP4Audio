//
//  ANTrackAtom.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/12/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANTrackAtom.h"

@implementation ANTrackAtom

+ (UInt32)specificType {
    return 'trak';
}

- (ANDataHandlerReference *)dataHandlerReferenceAtom {
    ANMovieAtomGroup * mdia = [[self subAtomsOfType:'mdia'] lastObject];
    return [[mdia subAtomsOfType:'hdlr'] lastObject];
}

- (ANTrackHeader *)trackHeaderAtom {
    return [[self subAtomsOfType:'tkhd'] lastObject];
}

- (ANSampleTableAtom *)sampleTable {
    ANMovieAtomGroup * mdia = [[self subAtomsOfType:'mdia'] lastObject];
    ANMovieAtomGroup * minf = [[mdia subAtomsOfType:'minf'] lastObject];
    return [[minf subAtomsOfType:'stbl'] lastObject];
}

@end
