//
//  MediaRecord.m
//  ChurchOfGod
//
//  Created by Calvin Ko on 3/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MediaRecord.h"

static NSString *kNews = @"News";
static NSString *kNewsFolder = @"News Folder";
static NSString *kSermon = @"Sermon";
static NSString *kSermonFolder = @"Sermon Folder";

@implementation MediaRecord

@synthesize itemIcon, itemDate, itemTag, itemThumbIcon, itemDescription, itemType, itemContent, itemContentURL;
@synthesize itemTitle, imageURLString, itemURLString, itemAudioURLString;
@synthesize itemVideoURLString;

-(id) init {
    self.itemContent = nil;
    self.itemContentURL = nil;
    return self;
}

-(NSString *)itemDateShortStyle
{	
	// Convert string to date object
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
	NSDate *date = [dateFormat dateFromString:self.itemDate];  
	
	// Convert date object to desired output format
	[dateFormat setDateStyle:NSDateFormatterShortStyle];
	NSString *dateStr = [dateFormat stringFromDate:date];  
	[dateFormat release];
	return dateStr;
}

-(NSString *)itemDateLongStyle
{	
	// Convert string to date object
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
	NSDate *date = [dateFormat dateFromString:self.itemDate];  
	
	// Convert date object to desired output format
	[dateFormat setDateStyle:NSDateFormatterLongStyle];
	NSString *dateStr = [dateFormat stringFromDate:date];  
	[dateFormat release];
	return dateStr;
}

-(bool) isNews
{
    return [itemType isEqualToString:kNews];
}

-(bool) isSermon
{
    return [itemType isEqualToString:kSermon];
}

-(bool) isNewsFolder {
    return [itemType isEqualToString:kNewsFolder];
}

-(bool) isSermonFolder {

    return [itemType isEqualToString:kSermonFolder];
}

-(bool) isFolder
{
    return [self isNewsFolder] || [self isSermonFolder];
}


@end
