//
//  ANMovieStoreFile.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/10/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANMovieStore.h"

@interface ANMovieStoreFile : ANMovieStore {
    NSFileHandle * fileHandle;
    NSUInteger length;
}

- (id)initWithPath:(NSString *)path;

@end
