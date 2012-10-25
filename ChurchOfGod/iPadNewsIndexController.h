//
//  iPadNewsIndexController.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 9/10/12.
//
//

#import <UIKit/UIKit.h>
#import "IconDownloader.h"
#import "FeedLoader.h"
#import "RootViewController.h"


@interface iPadNewsIndexController : UITableViewController <IconDownloaderDelegate, FeedLoaderDelegate> {
    
}

@property (nonatomic, assign) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, assign) IBOutlet RootViewController *rootViewController;
@property (nonatomic, assign) IBOutlet UIActivityIndicatorView *aView;

@property (nonatomic, retain) NSArray *entries;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

@end
