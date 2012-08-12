//
//  ANMP4ASampleDescription.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/11/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANMP4ASampleDescription.h"

@implementation ANMP4ASampleDescription

@synthesize version;
@synthesize revisionLevel;
@synthesize vendor;
@synthesize numberOfChannels;
@synthesize sampleSize;
@synthesize compressionID;
@synthesize packetSize;
@synthesize sampleRate;

+ (UInt32)specificDataFormat {
    return 'mp4a';
}

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index maxLength:(NSUInteger)maxLength {
    if ((self = [super initWithStore:theStore atIndex:index maxLength:maxLength])) {
        if ([descriptionBody length] < 20) return nil;
        const char * bytes = [descriptionBody bytes];
        const UInt16 * littlePtr = (const UInt16 *)bytes;
        version = CFSwapInt16BigToHost(*littlePtr);
        revisionLevel = CFSwapInt16BigToHost(littlePtr[1]);
        vendor = CFSwapInt32BigToHost(((const UInt32 *)bytes)[1]);
        numberOfChannels = CFSwapInt16BigToHost(littlePtr[4]);
        sampleSize = CFSwapInt16BigToHost(littlePtr[5]);
        compressionID = CFSwapInt16BigToHost(littlePtr[6]);
        packetSize = CFSwapInt16BigToHost(littlePtr[7]);
        memcpy(&sampleRate, &bytes[16], 4);
        sampleRate.whole = CFSwapInt16BigToHost(sampleRate.whole);
        sampleRate.fractional = CFSwapInt16BigToHost(sampleRate.fractional);
    }
    return self;
}

- (double)sampleRateDouble {
    return (double)sampleRate.whole + ((double)sampleRate.fractional / (double)65536);
}

@end
