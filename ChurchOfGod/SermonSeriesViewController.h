//
//  SermonSeriesViewController.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IconDownloader.h"
#import "FeedLoader.h"


@interface SermonSeriesViewController : UITableViewController <UIScrollViewDelegate,FeedLoaderDelegate> 
{
    NSArray *entries;   // the main data model for our UITableView
    UIImageView *topBanner;
    UIImage *image;
}

@property (nonatomic, retain) NSArray *entries;
@property (nonatomic, retain) IBOutlet UIImageView *topBanner;
@property (nonatomic, retain) UIImage *image;
@end
