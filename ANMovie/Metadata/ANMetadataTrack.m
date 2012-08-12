//
//  ANMetadataTrack.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/12/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANMetadataTrack.h"

@implementation ANMetadataTrack

@synthesize trackNumber;
@synthesize trackCount;

- (id)initWithTrackNumber:(NSInteger)track tracks:(NSInteger)total {
    if ((self = [super init])) {
        trackNumber = track;
        trackCount = total;
    }
    return self;
}

- (NSData *)encodeTrackInfo {
    // 0000 (B track number) (B track count) 0000
    UInt16 trackNumberBig = CFSwapInt16HostToBig(trackNumber);
    UInt16 trackCountBig = CFSwapInt16HostToBig(trackCount);
    UInt16 zero = 0;
    NSMutableData * data = [[NSMutableData alloc] init];
    
    [data appendBytes:&zero length:2];
    [data appendBytes:&trackNumberBig length:2];
    [data appendBytes:&trackCountBig length:2];
    [data appendBytes:&zero length:2];
    
    return [data copy];
}

@end
