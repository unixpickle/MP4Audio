//
//  ANMetadataTrack.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/12/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANMetadataTrack : NSObject {
    NSInteger trackNumber;
    NSInteger trackCount;
}

@property (readonly) NSInteger trackNumber;
@property (readonly) NSInteger trackCount;

- (id)initWithTrackNumber:(NSInteger)track tracks:(NSInteger)total;

- (NSData *)encodeTrackInfo;

@end
