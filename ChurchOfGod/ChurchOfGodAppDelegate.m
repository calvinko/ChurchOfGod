//
//  ChurchofGodAppDelegate.m
//  ChurchofGod
//
//  Created by Calvin Ko on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChurchofGodAppDelegate.h"
#import "MediaViewController.h"
#import "SermonsViewController.h"
#import "NewsViewController.h"
#import "ParseOperation.h"
#import "FeedLoader.h"
#import <CFNetwork/CFNetwork.h>

static NSString *const CreativeMediaFeed = @"http://www.sugarcreek.tv/ip_creative_feed.xml";
static NSString *const SermonMediaFeed = @"http://www.bachurch.org/store/sermonlist.xml";
static NSString *const NewsFeed = @"http://www.bachurch.org/category/news/feed/";


@implementation ChurchofGodAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize sermonNavConntroller, newsNavConntroller, mediaNavConntroller, settingNavController;
@synthesize mediaViewController, newsViewController, sermonsViewController, settingViewController;



#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

    // Add the tab bar controller's view to the window and display.
    [self.window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];

	if([self hasNetworkConnection])
	{
		
		mediaFeedLoader = [[FeedLoader alloc] init];
		mediaFeedLoader.delegate = mediaViewController;
		
		NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:CreativeMediaFeed]];
		mediaFeedLoader.listFeedConnection = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:mediaFeedLoader] autorelease];
		
		
		// Test the validity of the connection object. The most likely reason for the connection object
		// to be nil is a malformed URL, which is a programmatic error easily detected during development
		// If the URL is more dynamic, then you should implement a more flexible validation technique, and
		// be able to both recover from errors and communicate problems to the user in an unobtrusive manner.
		//
		NSAssert(mediaFeedLoader.listFeedConnection != nil, @"Failure to create URL connection.");
		
		sermonsFeedLoader = [[FeedLoader alloc] init];
		sermonsFeedLoader.delegate = sermonsViewController;
		
		urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:SermonMediaFeed]];
		sermonsFeedLoader.listFeedConnection = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:sermonsFeedLoader] autorelease];
		
		// Test the validity of the connection object. The most likely reason for the connection object
		// to be nil is a malformed URL, which is a programmatic error easily detected during development
		// If the URL is more dynamic, then you should implement a more flexible validation technique, and
		// be able to both recover from errors and communicate problems to the user in an unobtrusive manner.
		//
		NSAssert(sermonsFeedLoader.listFeedConnection != nil, @"Failure to create URL connection.");
		
		newsFeedLoader = [[FeedLoader alloc] init];
		newsFeedLoader.delegate = newsViewController;
		
		urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:NewsFeed]];
		newsFeedLoader.listFeedConnection = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:newsFeedLoader] autorelease];
		
		// Test the validity of the connection object. The most likely reason for the connection object
		// to be nil is a malformed URL, which is a programmatic error easily detected during development
		// If the URL is more dynamic, then you should implement a more flexible validation technique, and
		// be able to both recover from errors and communicate problems to the user in an unobtrusive manner.
		//
		//NSAssert(sermonsViewController.sermonsListFeedConnection != nil, @"Failure to create URL connection.");
		
		// show in the status bar that network activity is starting
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	} else {
		tabBarController.selectedIndex = 3;
		
	}
	
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

-(Boolean)hasNetworkConnection
{
	Boolean retVal = NO;
	
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [@"www.sugarcreek.net" UTF8String]);
	
	if(reachability!= NULL)
	{
		SCNetworkReachabilityFlags flags;
		if (SCNetworkReachabilityGetFlags(reachability, &flags))
		{
			
			if ((flags & kSCNetworkReachabilityFlagsReachable)) {
				retVal = YES;
			} else {
				retVal = NO;
			}
		}
		
	}
	
	
	
	reachability = nil;
	
	return retVal;
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

