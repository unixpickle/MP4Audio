//
//  ANMetadata.h
//  MP4Audio
//
//  Created by Alex Nichol on 8/12/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANEncodingFullAtomGroup.h"
#import "ANEncodingAtomGroup.h"
#import "ANMetadataImage.h"
#import "ANMetadataTrack.h"

#define kANMetadataQuicktimeKeyAlbum @"com.apple.quicktime.album"
#define kANMetadataQuicktimeKeyArtist @"com.apple.quicktime.artist"
#define kANMetadataQuicktimeKeyArtwork @"com.apple.quicktime.artwork"
#define kANMetadataQuicktimeKeyTitle @"com.apple.quicktime.title"
#define kANMetadataQuicktimeKeyGenre @"com.apple.quicktime.genre"
#define kANMetadataQuicktimeKeyYear @"com.apple.quicktime.year"

@interface ANMetadata : NSObject {    
    NSString * artist;
    NSString * album;
    NSString * title;
    NSString * genre;
    NSString * year;
    ANMetadataImage * albumCover;
    ANMetadataTrack * trackNumber;
}

@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * album;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) ANMetadataImage * albumCover;
@property (nonatomic, retain) ANMetadataTrack * trackNumber;

- (NSData *)encodeMetadata;
- (ANEncodingAtom *)metadataAtom;

@end
