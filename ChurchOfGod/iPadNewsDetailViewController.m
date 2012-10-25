//
//  iPadNewsDetailViewController.m
//  ChurchOfGod
//
//  Created by Calvin Ko on 9/12/12.
//
//

#import "iPadNewsDetailViewController.h"
#import "MediaRecord.h"

@interface iPadNewsDetailViewController ()

@end

@implementation iPadNewsDetailViewController
@synthesize newsDescription, record, activityIndicator, refreshButton, toolbar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	refreshButton.enabled = YES;
	
	NSString * storyLink = self.record.itemLink;
	
	// clean up the link - get rid of spaces, returns, and tabs...
	storyLink = [storyLink stringByReplacingOccurrencesOfString:@" " withString:@""];
	storyLink = [storyLink stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	storyLink = [storyLink stringByReplacingOccurrencesOfString:@"	" withString:@""];
	//newsDescription.scalesPageToFit = YES;
	NSLog(@"news: %@", storyLink);
	// open in Safari
	//[self playMovieAtURL:[NSURL URLWithString:storyLink]];
	//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:storyLink]];
    if (self.record.itemContent != nil) {
        [newsDescription loadHTMLString:self.record.itemContent baseURL:[NSURL URLWithString:storyLink]];
	} else {
        [newsDescription loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.record.itemContentURL]]];
    }
}


- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Add the popover button to the toolbar.
    NSMutableArray *itemsArray = [toolbar.items mutableCopy];
    [itemsArray insertObject:barButtonItem atIndex:0];
    [toolbar setItems:itemsArray animated:NO];
    [itemsArray release];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Remove the popover button from the toolbar.
    NSMutableArray *itemsArray = [toolbar.items mutableCopy];
    [itemsArray removeObject:barButtonItem];
    [toolbar setItems:itemsArray animated:NO];
    [itemsArray release];
}

-(IBAction)refreshTapped {
	[newsDescription reload];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[activityIndicator stopAnimating];
	lastRequest = nil;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
	/*
	 If the user clicks a link to a page other then the first news page, scale to fit.
	 If it is of type UIWebViewNavigationTypeOther and it is a new request don't scale to fit.
     */
	if(navigationType == UIWebViewNavigationTypeLinkClicked)
	{
		webView.scalesPageToFit = YES;
		refreshButton.enabled = YES;
		lastRequest = request;
		
	}
	
	if(navigationType == UIWebViewNavigationTypeOther && lastRequest == nil)
	{
		webView.scalesPageToFit = NO;
		refreshButton.enabled = NO;
	}
	
	return YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
