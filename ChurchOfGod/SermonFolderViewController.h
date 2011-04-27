//
//  SermonFolderViewController.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <MediaPlayer/MediaPlayer.h>
#import "IconDownloader.h"
#import "FeedLoader.h"
#import "MediaDetailViewController.h"
#import "ConnectViewController.h"


@interface SermonFolderViewController : UITableViewController <UIScrollViewDelegate, IconDownloaderDelegate, FeedLoaderDelegate>
{
	NSArray *entries;    // the filtered data model for our UITableView
    NSMutableDictionary *imageDownloadsInProgress;  // the set of IconDownloader objects for each app
	MediaDetailViewController *mediaDetailView;
    Boolean didRelease;
}

@property (nonatomic, retain) NSArray *entries;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, retain) IBOutlet MediaDetailViewController *mediaDetailView;

- (void)appImageDidLoad:(NSIndexPath *)indexPath;


@end