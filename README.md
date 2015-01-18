Disclaimer
==========

I have not worked on this project in a long time, and I never tested it on a wide variety of audio files. If you are having problems using it, I would highly recommend looking for a different library.

With that said, if you find a bug and figure out how to fix it, I will be willing to accept a pull request.

MP4Audio
========

This nifty Objective-C library makes it *super easy* to extract the AAC audio track from an MP4 file and export it as an M4A file. In addition, MP4Audio provides a ridiculously simple interface for setting the metadata of an M4A file (i.e. artist, album, etc.). There's never been a simpler way to do these tasks from Objective-C!

Usage
=====

Convert a video file to audio:

    ANMovie * movie = [[ANMovie alloc] initWithFile:@"test.mp4"];
    [movie exportAACToFile:@"test.m4a"];
    [movie close];

Set the metadata for an audio file:

    NSData * jpegCover = ...;
    ANMetadata * metadata = [[ANMetadata alloc] init];
    metadata.title = @"Developers (feat. Steve Balmer)";
    metadata.album = @"Greatest Hits";
    metadata.year = @"2012";
    metadata.artist = @"Alex Nichol (feat. Steve Balmer)";
    metadata.trackNumber = [[ANMetadataTrack alloc] initWithTrackNumber:5 tracks:12];
    metadata.albumCover = [[ANMetadataImage alloc] initWithImageData:jpegCover type:ANMetadataImageTypeJPG];
    movie = [[ANMovie alloc] initWithFile:@"test.m4a"];
    [movie setMovieMetadata:metadata];
    [movie close];
