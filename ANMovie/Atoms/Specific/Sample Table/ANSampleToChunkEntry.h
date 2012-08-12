//
//  ANSampleToChunkEntry.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/11/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANSampleToChunkEntry : NSObject {
    UInt32 firstChunk;
    UInt32 samplesPerChunk;
    UInt32 sampleDescriptionID;
}

@property (readonly) UInt32 firstChunk;
@property (readonly) UInt32 samplesPerChunk;
@property (readonly) UInt32 sampleDescriptionID;

- (id)initWithBytes:(const char *)bytes;

@end
