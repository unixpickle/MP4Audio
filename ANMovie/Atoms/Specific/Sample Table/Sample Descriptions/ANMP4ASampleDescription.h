//
//  ANMP4ASampleDescription.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/11/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANSampleDescription.h"

typedef struct {
    UInt16 whole;
    UInt16 fractional;
} ANAudioFixedPoint;

@interface ANMP4ASampleDescription : ANSampleDescription {
    UInt16 version;
    UInt16 revisionLevel;
    UInt32 vendor;
    UInt16 numberOfChannels;
    UInt16 sampleSize;
    UInt16 compressionID;
    UInt16 packetSize;
    ANAudioFixedPoint sampleRate;
}

@property (readonly) UInt16 version;
@property (readonly) UInt16 revisionLevel;
@property (readonly) UInt32 vendor;
@property (readonly) UInt16 numberOfChannels;
@property (readonly) UInt16 sampleSize;
@property (readonly) UInt16 compressionID;
@property (readonly) UInt16 packetSize;
@property (readonly) ANAudioFixedPoint sampleRate;

- (double)sampleRateDouble;

@end
