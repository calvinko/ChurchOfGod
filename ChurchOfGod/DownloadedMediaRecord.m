//
//  DownloadedMediaRecord.m
//  ChurchOfGod
//
//  Created by Calvin Ko on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadedMediaRecord.h"


@implementation DownloadedMediaRecord
@synthesize itemTitle, itemType, fileName, itemDescription;
@synthesize currentPlaybackTime;

-(id) init
{
    [super init];
    self.currentPlaybackTime = -1;
    self.itemType = @"mp3";
    return self;
}

-(NSArray *) convertToPropertyList {
    NSNumber *n = [NSNumber numberWithDouble:currentPlaybackTime];
    return [NSArray arrayWithObjects:itemTitle, itemType, fileName, itemDescription, n, nil];
}

-(id) initWithArray:(NSArray *) array {
    self.itemTitle = [array objectAtIndex:0];
    self.itemType = [array objectAtIndex:1];
    self.fileName = [array objectAtIndex:2];
    self.itemDescription = [array objectAtIndex:3];
    NSNumber *n = [array objectAtIndex:4];
    self.currentPlaybackTime = [n doubleValue];
    return self;
}
@end
