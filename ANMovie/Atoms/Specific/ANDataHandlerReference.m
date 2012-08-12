//
//  ANDataHandlerReference.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/10/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANDataHandlerReference.h"

@interface ANDataHandlerReference (Private)

- (BOOL)readFields;

@end

@implementation ANDataHandlerReference

@synthesize componentType;
@synthesize componentSubtype;
@synthesize componentManufacturer;
@synthesize componentFlags;
@synthesize componentFlagsMask;
@synthesize componentName;

+ (UInt32)specificType {
    return 'hdlr';
}

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index {
    if ((self = [super initWithStore:theStore atIndex:index])) {
        if (![self readFields]) return nil;
    }
    return self;
}

- (id)initWithStore:(ANMovieStore *)theStore atIndex:(NSUInteger)index maxLength:(NSUInteger)maxLength {
    if ((self = [super initWithStore:theStore atIndex:index maxLength:maxLength])) {
        if (![self readFields]) return nil;
    }
    return self;
}

- (BOOL)readFields {
    if ([self contentLength] < 24) return NO;
    NSData * contentData = [store dataAtOffset:[self contentOffset]
                                    withLength:[self contentLength]];
    const char * bytes = [contentData bytes];
    componentType = CFSwapInt32BigToHost(((const UInt32 *)bytes)[1]);
    componentSubtype = CFSwapInt32BigToHost(((const UInt32 *)bytes)[2]);
    componentManufacturer = CFSwapInt32BigToHost(((const UInt32 *)bytes)[3]);
    componentFlags = CFSwapInt32BigToHost(((const UInt32 *)bytes)[4]);
    componentFlagsMask = CFSwapInt32BigToHost(((const UInt32 *)bytes)[5]);
    componentName = [[NSString alloc] initWithBytes:&bytes[24]
                                             length:([self contentLength] - 24)
                                           encoding:NSUTF8StringEncoding];
    return YES;
}

- (NSString *)subtypeString {
    char buff[5];
    UInt32 bigSub = CFSwapInt32HostToBig(componentSubtype);
    buff[4] = 0;
    memcpy(buff, &bigSub, 4);
    return [NSString stringWithUTF8String:buff];
}

@end
