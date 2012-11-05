//
//  ANSampleToChunkEntry.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/11/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANSampleToChunkEntry.h"

@implementation ANSampleToChunkEntry

@synthesize firstChunk;
@synthesize samplesPerChunk;
@synthesize sampleDescriptionID;

- (id)initWithBytes:(const char *)bytes {
    if ((self = [super init])) {
        const UInt32 * numPtr = (const UInt32 *)bytes;
        firstChunk = CFSwapInt32BigToHost(*numPtr);
        samplesPerChunk = CFSwapInt32BigToHost(numPtr[1]);
        sampleDescriptionID = CFSwapInt32BigToHost(numPtr[2]);
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<ANSampleToChunkEntry %u %u %u>", (unsigned int)firstChunk, (unsigned int)samplesPerChunk, (unsigned int)sampleDescriptionID];
}

@end
