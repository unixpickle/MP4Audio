//
//  ANEncodingAtom.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/12/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANEncodingAtom : NSObject {
    UInt32 type;
    NSData * body;
}

- (id)initWithType:(UInt32)theType body:(NSData *)theBody;
- (NSData *)encode;

@end
