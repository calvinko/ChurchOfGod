//
//  ChurchofGodAppDelegate.h
//  ChurchofGod
//
//  Created by Calvin Ko on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaRecord.h"
#import "ParseOperation.h"
#import "FeedLoader.h"
#import "RotatingTabBarController.h"

@class MediaViewController;
@class SermonsViewController;
@class NewsViewController;
@class SettingViewController;
@class RotatingTabBarController;
@class SongViewController;
@class ToolTableViewController;
@class DownloadViewController;

@interface ChurchofGodAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate> {
    
	
    UIWindow *window;
    RotatingTabBarController *tabBarController;
    UISplitViewController   *splitViewController;
        
    
	UINavigationController *sermonNavConntroller;	
	UINavigationController *newsNavConntroller;
	UINavigationController *mediaNavConntroller;
	UINavigationController *settingNavController;
    UINavigationController *songNavController;
	
    MediaViewController     *mediaViewController;
	SermonsViewController   *sermonsViewController;
	NewsViewController		*newsViewController;
	SettingViewController	*settingViewController;
    SongViewController      *songViewController;
    DownloadViewController *downloadViewController;
	
	FeedLoader *mediaFeedLoader;
	FeedLoader *newsFeedLoader;
	FeedLoader *sermonsFeedLoader;
}


@property (nonatomic, retain) IBOutlet UIWindow *window;


@property (nonatomic, retain) IBOutlet RotatingTabBarController *tabBarController;

@property (nonatomic, retain) IBOutlet UITabBarController *ipadTabBarController;
@property (nonatomic, retain) IBOutlet UINavigationController *sermonNavConntroller;
@property (nonatomic, retain) IBOutlet UINavigationController *newsNavConntroller;
@property (nonatomic, retain) IBOutlet UINavigationController *mediaNavConntroller;
@property (nonatomic, retain) IBOutlet UINavigationController *settingNavController;
@property (nonatomic, retain) IBOutlet UINavigationController *songNavController;
@property (nonatomic, retain) IBOutlet UINavigationController *downloadNavController;

@property (nonatomic, retain) IBOutlet UISplitViewController   *splitViewController;

@property (nonatomic, retain) IBOutlet MediaViewController *mediaViewController;
@property (nonatomic, retain) IBOutlet SermonsViewController *sermonsViewController;
@property (nonatomic, retain) IBOutlet NewsViewController *newsViewController;
@property (nonatomic, retain) IBOutlet SettingViewController *settingViewController;
@property (nonatomic, retain) IBOutlet SongViewController *songViewController;
@property (nonatomic, retain) IBOutlet DownloadViewController *downloadViewController;

-(Boolean)hasNetworkConnection;

-(IBAction) refreshSermonTapped:(id)sender;
-(IBAction) downloadTapped:(id)sender;

@end
