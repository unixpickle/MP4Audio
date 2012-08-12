//
//  ANMetadataImage.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/12/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANMetadataImage.h"

@implementation ANMetadataImage

@synthesize imageData;
@synthesize type;

- (id)initWithImageData:(NSData *)data type:(UInt32)theType {
    if ((self = [super init])) {
        imageData = data;
        type = theType;
    }
    return self;
}

@end
