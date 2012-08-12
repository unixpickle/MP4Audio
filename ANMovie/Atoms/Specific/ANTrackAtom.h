//
//  ANTrackAtom.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/12/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANMovieAtomGroup.h"
#import "ANDataHandlerReference.h"
#import "ANTrackHeader.h"
#import "ANSampleTableAtom.h"

@interface ANTrackAtom : ANMovieAtomGroup

- (ANDataHandlerReference *)dataHandlerReferenceAtom;
- (ANTrackHeader *)trackHeaderAtom;
- (ANSampleTableAtom *)sampleTable;

@end
