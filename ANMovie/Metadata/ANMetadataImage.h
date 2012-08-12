//
//  ANMetadataImage.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/12/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ANMetadataImageTypeJPG = 13,
    ANMetadataImageTypePNG = 14,
    ANMetadataImageTypeBMP = 27
} ANMetadataImageType;

@interface ANMetadataImage : NSObject {
    NSData * imageData;
    UInt32 type;
}

@property (readonly) NSData * imageData;
@property (readonly) UInt32 type;

- (id)initWithImageData:(NSData *)data type:(UInt32)theType;

@end
