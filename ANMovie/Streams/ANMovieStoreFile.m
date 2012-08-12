//
//  ANMovieStoreFile.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/10/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "ANMovieStoreFile.h"

@implementation ANMovieStoreFile

- (id)initWithPath:(NSString *)path {
    if ((self = [super init])) {
        fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:path];
        if (!fileHandle) return nil;
        
        // calculate length
        [fileHandle seekToEndOfFile];
        length = [fileHandle offsetInFile];
        [fileHandle seekToFileOffset:0];
    }
    return self;
}

- (NSUInteger)length {
    return length;
}

- (NSData *)dataAtOffset:(NSUInteger)offset withLength:(NSUInteger)theLength {
    if (theLength == 0) return [NSData data];
    [fileHandle seekToFileOffset:offset];
    return [fileHandle readDataOfLength:theLength];
}

- (void)resizeStore:(NSUInteger)newSize {
    [fileHandle truncateFileAtOffset:newSize];
}

- (void)setData:(NSData *)data atOffset:(NSUInteger)offset {
    [fileHandle seekToFileOffset:offset];
    [fileHandle writeData:data];
}

- (void)closeStore {
    [fileHandle closeFile];
    fileHandle = nil;
}

- (void)dealloc {
    if (fileHandle) [fileHandle closeFile];
}

@end
