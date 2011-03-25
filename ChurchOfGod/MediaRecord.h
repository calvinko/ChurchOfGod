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

@interface MediaRecord : NSObject {
    
    NSString *itemTitle;
    NSString *itemTag;
    NSString *itemURLString;
    UIImage  *itemIcon;
	UIImage  *itemThumbIcon;
    NSString *itemDate;

    NSString *itemDescription;
    NSString *itemThumbURLString;
    NSString *itemVideoURLString;
    NSString *itemAudioURLString;
    NSString *itemContentURL;
    NSString *itemType;
}

@property (nonatomic, retain) NSString *itemTitle;
@property (nonatomic, retain) NSString *itemTag;
@property (nonatomic, retain) NSString *itemURLString;
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

-(NSString *)itemDateShortStyle;
-(NSString *)itemDateLongStyle;

-(bool) isNews;
-(bool) isNewsFolder;
-(bool) isSermon;
-(bool) isSermonFolder;
-(bool) isFolder;

@end
