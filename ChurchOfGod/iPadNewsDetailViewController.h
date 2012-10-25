//
//  iPadNewsDetailViewController.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 9/12/12.
//
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@class MediaRecord;
@interface iPadNewsDetailViewController : UIViewController <SubstitutableDetailViewController,UIWebViewDelegate>
{
    UIToolbar *toolbar;
    UIWebView  *newsDescription;
	MediaRecord *record;
	UIActivityIndicatorView *activityIndicator;
	NSURLRequest *lastRequest;
	UIBarButtonItem *refreshButton;

}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIWebView  *newsDescription;
@property (nonatomic, retain) MediaRecord *record;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *refreshButton;


-(IBAction) refreshTapped;
@end
