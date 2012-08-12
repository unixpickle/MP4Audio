//
//  ANEncodingFullAtom.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/12/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANEncodingAtom.h"

@interface ANEncodingFullAtom : ANEncodingAtom {
    UInt8 version;
    UInt32 flags;
}

- (id)initWithType:(UInt32)theType version:(UInt8)theVersion flags:(UInt32)theFlags body:(NSData *)theBody;

@end
