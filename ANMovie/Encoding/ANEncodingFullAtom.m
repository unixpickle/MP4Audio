//
//  ANEncodingFullAtom.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/12/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANEncodingFullAtom.h"

@implementation ANEncodingFullAtom

- (id)initWithType:(UInt32)theType version:(UInt8)theVersion flags:(UInt32)theFlags body:(NSData *)theBody {
    if ((self = [super initWithType:theType body:theBody])) {
        version = theVersion;
        flags = theFlags;
    }
    return self;
}

- (NSData *)encode {
    NSMutableData * encoded = [[NSMutableData alloc] init];
    
    UInt32 sizeFlip = CFSwapInt32HostToBig((UInt32)[body length] + 12);
    UInt32 typeFlip = CFSwapInt32HostToBig(type);
    UInt32 flagsVersion = CFSwapInt32HostToBig(version) || (version << 24);
    [encoded appendBytes:&sizeFlip length:4];
    [encoded appendBytes:&typeFlip length:4];
    [encoded appendBytes:&flagsVersion length:4];
    [encoded appendData:body];
    
    return [encoded copy];
}

@end
