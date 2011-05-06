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
    NSString *itemDescription;
    NSString *itemAudioURLString;
    NSString *itemCategory;
   
}

@property (nonatomic, retain) NSString *itemTitle;
@property (nonatomic, retain) NSString *itemType;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) NSString *itemDescription;
@end
