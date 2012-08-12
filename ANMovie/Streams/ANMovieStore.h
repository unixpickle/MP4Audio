//
//  ANMovieStore.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/10/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kANMovieStoreBufferSize 512

/**
 * An abstract class which represents a movie file's data.
 * Typically, this data would be stored on disk or in memory.
 */
@interface ANMovieStore : NSObject

- (NSUInteger)length;
- (NSData *)dataAtOffset:(NSUInteger)offset withLength:(NSUInteger)length;

- (void)resizeStore:(NSUInteger)newSize;
- (void)setData:(NSData *)data atOffset:(NSUInteger)offset;
- (void)moveDataInRange:(NSRange)range toOffset:(NSUInteger)offset;

- (void)closeStore;

@end
