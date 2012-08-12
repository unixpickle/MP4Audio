//
//  ANSampleDescriptionAtom.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/11/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANFullAtom.h"
#import "ANSampleDescription.h"

@interface ANSampleDescriptionAtom : ANFullAtom {
    UInt32 numberOfEntries;
    NSArray * sampleDescriptions;
}

@property (readonly) UInt32 numberOfEntries;
@property (readonly) NSArray * sampleDescriptions;

@end
