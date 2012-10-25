//
//  iPadSermonIndexController.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 9/10/12.
//
//

#import <UIKit/UIKit.h>
#import "IconDownloader.h"
#import "FeedLoader.h"

@class RootViewController;

@interface iPadSermonIndexController : UITableViewController <UIScrollViewDelegate, IconDownloaderDelegate, FeedLoaderDelegate>
{
   	//MediaDetailViewController *mediaDetailView;
    Boolean didRelease;
}

@property (nonatomic, retain) NSArray *entries;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, assign) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, assign) IBOutlet RootViewController *rootViewController;

//@property (nonatomic, retain) IBOutlet MediaDetailViewController *mediaDetailView;

- (void)appImageDidLoad:(NSIndexPath *)indexPath;


@end
