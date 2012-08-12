//
//  ANMovie.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/10/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ANMovieStoreFile.h"
#import "ANAtomReader.h"

#import "ANMP4ASampleDescription.h"
#import "ANMetadata.h"

@interface ANMovie : NSObject {
    ANMovieStore * store;
    NSArray * atoms;
    
    ANMovieAtomGroup * movieAtom;
    NSArray * tracks;
}

@property (readonly) NSArray * atoms;
@property (readonly) NSArray * tracks;

- (id)initWithFile:(NSString *)file;
- (void)close;

- (ANMP4ASampleDescription *)aacSampleDescription;
- (BOOL)bufferAACAudioData:(void (^)(NSData * data, NSInteger packetIndex, NSInteger totalPackets))callback;
- (BOOL)exportAACToFile:(NSString *)m4aFile;

- (void)appendData:(NSData *)data toAtom:(ANMovieAtom *)atom;
- (void)deleteDataInRange:(NSRange)range fromAtom:(ANMovieAtom *)atom;

- (void)setMovieMetadata:(ANMetadata *)metadata;

@end
