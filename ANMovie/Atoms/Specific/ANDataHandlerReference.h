//
//  ANDataHandlerReference.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/10/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANFullAtom.h"

@interface ANDataHandlerReference : ANFullAtom {
    UInt32 componentType;
    UInt32 componentSubtype;
    UInt32 componentManufacturer;
    UInt32 componentFlags;
    UInt32 componentFlagsMask;
    NSString * componentName;
}

@property (readonly) UInt32 componentType;
@property (readonly) UInt32 componentSubtype;
@property (readonly) UInt32 componentManufacturer;
@property (readonly) UInt32 componentFlags;
@property (readonly) UInt32 componentFlagsMask;
@property (readonly) NSString * componentName;

- (NSString *)subtypeString;

@end
