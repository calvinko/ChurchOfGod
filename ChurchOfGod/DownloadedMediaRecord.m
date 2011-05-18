//
//  DownloadedMediaRecord.m
//  ChurchOfGod
//
//  Created by Calvin Ko on 5/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadedMediaRecord.h"


@implementation DownloadedMediaRecord
@synthesize itemTitle, itemType, itemDate, fileName, itemAuthor;
@synthesize currentPlaybackTime, duration;

-(id) init
{
    [super init];
    self.currentPlaybackTime = -1;
    self.itemType = @"mp3";
    return self;
}

-(NSArray *) convertToPropertyList {
    NSNumber *n = [NSNumber numberWithDouble:currentPlaybackTime];
    NSNumber *d = [NSNumber numberWithInteger:duration];
    return [NSArray arrayWithObjects:itemTitle, itemType, itemAuthor, itemDate, fileName, d, n, nil];
}

-(id) initWithArray:(NSArray *) array {
    self.itemTitle = [array objectAtIndex:0];
    self.itemType = [array objectAtIndex:1];
    self.itemAuthor = [array objectAtIndex:2];
    self.itemDate = [array objectAtIndex:3];
    self.fileName = [array objectAtIndex:4];
    NSNumber *d = [array objectAtIndex:5];
    self.duration = [d integerValue];
    NSNumber *n = [array objectAtIndex:6];
    self.currentPlaybackTime = [n doubleValue];
    return self;
}
@end
