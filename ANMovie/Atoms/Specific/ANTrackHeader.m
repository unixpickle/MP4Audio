//
//  ANTrackHeader.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/10/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANTrackHeader.h"

@interface ANTrackHeader (Private)

- (BOOL)readFields;

@end

@implementation ANTrackHeader

@synthesize creationTime;
@synthesize modificationTime;
@synthesize trackID;
@synthesize reserved1;
@synthesize duration;
@synthesize reserved2;
@synthesize layer;
@synthesize alternateGroup;
@synthesize volume;
@synthesize reserved3;
@synthesize trackWidth;
@synthesize trackHeight;

- (const char * )matrixStructure {
    return matrixStructure;
}

+ (UInt32)specificType {
    return 'tkhd';
}

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index maxLength:(NSUInteger)maxLength {
    if ((self = [super initWithStore:theStore atIndex:index maxLength:maxLength])) {
        if (![self readFields]) return nil;
    }
    return self;
}

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index {
    if ((self = [super initWithStore:theStore atIndex:index])) {
        if (![self readFields]) return nil;
    }
    return self;
}

- (BOOL)readFields {
    if ([self contentLength] < 84) return NO;
    NSData * headerData = [store dataAtOffset:[self contentOffset]
                                   withLength:[self contentLength]];
    const char * bytes = (const char *)[headerData bytes];
    const UInt32 * intBuffer = (const UInt32 *)bytes;
    creationTime = CFSwapInt32HostToBig(intBuffer[1]);
    modificationTime = CFSwapInt32HostToBig(intBuffer[2]);
    trackID = CFSwapInt32HostToBig(intBuffer[3]);
    reserved1 = CFSwapInt32HostToBig(intBuffer[4]);
    duration = CFSwapInt32HostToBig(intBuffer[5]);
    reserved2 = CFSwapInt64HostToBig(((const UInt64 *)bytes)[3]);
    layer = CFSwapInt32BigToHost(((const UInt16 *)bytes)[16]);
    alternateGroup = CFSwapInt32BigToHost(((const UInt16 *)bytes)[17]);
    volume = CFSwapInt32BigToHost(((const UInt16 *)bytes)[18]);
    reserved3 = CFSwapInt32BigToHost(((const UInt16 *)bytes)[19]);
    memcpy(matrixStructure, &bytes[40], 36);
    trackWidth = CFSwapInt32HostToBig(intBuffer[19]);
    trackHeight = CFSwapInt32HostToBig(intBuffer[20]);
    return YES;
}

@end
