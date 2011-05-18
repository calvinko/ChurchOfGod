//
//  DownloadedMediaRecord.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DownloadedMediaRecord : NSObject {
    NSString *itemTitle;    
    NSString *itemType;
    NSString *fileName;
    NSString *itemDate;
    NSString *itemAuthor;
    NSString *itemAudioURLString;
    NSString *itemCategory;
    NSTimeInterval currentPlaybackTime;
    NSInteger duration;
   
}

@property (nonatomic, retain) NSString *itemTitle;
@property (nonatomic, retain) NSString *itemType;
@property (nonatomic, retain) NSString *itemDate;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) NSString *itemAuthor;
@property (nonatomic) NSTimeInterval currentPlaybackTime;
@property (nonatomic) NSInteger duration;

-(NSArray *) convertToPropertyList;
-(id) initWithArray:(NSArray *) array;
@end
