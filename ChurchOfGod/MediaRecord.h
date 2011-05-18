//
//  MediaRecord.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 3/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MTYPE_NEWS      1
#define MTYPE_SERMON    2
#define MTYPE_NEWSFOLDER    3
#define MTYPE_SERMONFOLDER  4

@class AudioDownloader;
@interface MediaRecord : NSObject {
    
    NSString *itemTitle;
    NSString *itemAuthor;
    NSString *itemTag;
    NSString *itemLink;
    UIImage  *itemIcon;
	UIImage  *itemThumbIcon;
    NSString *itemDate;

    NSString *itemDescription;
    NSString *itemThumbURLString;
    NSString *itemVideoURLString;
    NSString *itemAudioURLString;
    NSString *itemContentURL;
    NSString *itemType;
    NSString *itemCategory;
    NSInteger audioFileSize;
    
    NSTimeInterval currentPlaybackTime;
    
    AudioDownloader *loader;
}

@property (nonatomic, retain) NSString *itemTitle;
@property (nonatomic, retain) NSString *itemAuthor;
@property (nonatomic, retain) NSString *itemTag;
@property (nonatomic, retain) NSString *itemLink;
@property (nonatomic, retain) UIImage  *itemIcon;
@property (nonatomic, retain) UIImage  *itemThumbIcon;
@property (nonatomic, retain) NSString *itemDate;
@property (nonatomic, retain) NSString *itemDescription;
@property (nonatomic, retain) NSString *itemContent;
@property (nonatomic, retain) NSString *imageURLString;
@property (nonatomic, retain) NSString *itemVideoURLString;
@property (nonatomic, retain) NSString *itemAudioURLString;
@property (nonatomic, retain) NSString *itemContentURL;
@property (nonatomic, retain) NSString *itemType;
@property (nonatomic, retain) NSString *itemCategory;
@property (nonatomic, retain) AudioDownloader *loader;
@property (nonatomic) NSInteger audioFileSize;
@property (nonatomic) NSTimeInterval currentPlaybackTime;

-(NSString *)itemDateShortStyle;
-(NSString *)itemDateLongStyle;

-(bool) isNews;
-(bool) isNewsFolder;
-(bool) isSermon;
-(bool) isSermonFolder;
-(bool) isSermonSeries; 
-(bool) isFolder;

@end

/*
@interface DownloadedItemRecord : NSObject {
    NSString *itemTitle;
    NSString *itemFilePath;
    UIImage  *itemIcon;
}
@end
 */
