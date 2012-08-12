//
//  ANTrackHeader.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/10/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANFullAtom.h"

@interface ANTrackHeader : ANFullAtom {
    UInt32 creationTime;
    UInt32 modificationTime;
    UInt32 trackID;
    UInt32 reserved1;
    UInt32 duration;
    UInt64 reserved2;
    UInt16 layer;
    UInt16 alternateGroup;
    UInt16 volume;
    UInt16 reserved3;
    char matrixStructure[36];
    UInt32 trackWidth;
    UInt32 trackHeight;
}

@property (readonly) UInt32 creationTime;
@property (readonly) UInt32 modificationTime;
@property (readonly) UInt32 trackID;
@property (readonly) UInt32 reserved1;
@property (readonly) UInt32 duration;
@property (readonly) UInt64 reserved2;
@property (readonly) UInt16 layer;
@property (readonly) UInt16 alternateGroup;
@property (readonly) UInt16 volume;
@property (readonly) UInt16 reserved3;
@property (readonly) const char * matrixStructure;
@property (readonly) UInt32 trackWidth;
@property (readonly) UInt32 trackHeight;

@end
