//
//  ANFullAtom.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/11/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANMovieAtom.h"

@interface ANFullAtom : ANMovieAtom {
    UInt8 version;
    UInt32 flags;
}

@property (readonly) UInt8 version;
@property (readonly) UInt32 flags;

@end
