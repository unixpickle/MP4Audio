//
//  main.m
//  MP4Audio
//
//  Created by Alex Nichol on 8/10/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudio.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ANMovie.h"
#import "ANMP4ASampleDescription.h"

#import "ANMetadata.h"

AudioFileID openMP4AudioFile(NSString * path, ANMP4ASampleDescription * sampleDescription);
void outputAudioDataForTrack(ANMovie * movie, NSString * path);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString * path = nil;
        if (argc != 2) {
            fprintf(stderr, "Usage: <input>\n");
            return 0;
        }
        path = [NSString stringWithUTF8String:argv[1]];
        
        ANMovie * movie = [[ANMovie alloc] initWithFile:path];
        
        NSLog(@"outputting audio to file 'test.m4a'");
        outputAudioDataForTrack(movie, @"test.m4a");
        
        [movie close];
        
        ANMetadata * metadata = [[ANMetadata alloc] init];
        metadata.title = @"Partayyy part 2";
        metadata.album = @"Greatest Hits";
        metadata.year = @"2012";
        metadata.artist = @"Alex Nichol (feat. Bill Gates)";
        metadata.trackNumber = [[ANMetadataTrack alloc] initWithTrackNumber:5 tracks:12];
        // metadata.albumCover = [[ANMetadataImage alloc] initWithImageData:jpegCover type:ANMetadataImageTypeJPG];
        movie = [[ANMovie alloc] initWithFile:@"test.m4a"];
        [movie setMovieMetadata:metadata];
        [movie close];
    }
    return 0;
}

void outputAudioDataForTrack(ANMovie * movie, NSString * path) {
    [movie exportAACToFile:path];
}
