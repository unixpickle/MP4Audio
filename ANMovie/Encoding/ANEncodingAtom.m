//
//  ANEncodingAtom.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/12/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANEncodingAtom.h"

@implementation ANEncodingAtom

- (id)initWithType:(UInt32)theType body:(NSData *)theBody {
    if ((self = [super init])) {
        type = theType;
        body = theBody;
    }
    return self;
}

- (NSData *)encode {
    NSMutableData * encoded = [[NSMutableData alloc] init];

    UInt32 sizeFlip = CFSwapInt32HostToBig((UInt32)[body length] + 8);
    UInt32 typeFlip = CFSwapInt32HostToBig(type);
    [encoded appendBytes:&sizeFlip length:4];
    [encoded appendBytes:&typeFlip length:4];
    [encoded appendData:body];
    
    return [encoded copy];
}

@end
