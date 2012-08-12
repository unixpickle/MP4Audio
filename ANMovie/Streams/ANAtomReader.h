//
//  ANAtomReader.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/10/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANMovieAtomGroup.h"
#import "ANTrackHeader.h"
#import "ANDataHandlerReference.h"
#import "ANSampleTableAtom.h"
#import "ANSampleDescriptionAtom.h"
#import "ANSampleSizeAtom.h"
#import "ANChunkOffsetAtom.h"
#import "ANChunkOffset64Atom.h"
#import "ANSampleToChunkAtom.h"
#import "ANTrackAtom.h"

@interface ANAtomReader : NSObject

+ (Class)atomClassForAtomID:(UInt32)atomID;
+ (ANMovieAtom *)readAtomFromStore:(ANMovieStore *)store index:(NSInteger)index;
+ (ANMovieAtom *)readAtomFromStore:(ANMovieStore *)store index:(NSInteger)index maxLength:(NSInteger)max;

@end
