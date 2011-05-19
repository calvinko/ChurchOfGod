//
//  GospelOneViewController.m
//  ChurchOfGod
//
//  Created by Calvin Ko on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GospelOneViewController.h"
#import "MyViewController.h"

int kNumberOfPages = 5;
static NSString *NameKey = @"nameKey";
static NSString *ImageKey = @"imageKey";



@implementation GospelOneViewController
@synthesize pageControl, scrollView, viewControllers, contentList;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"WordlessBook" ofType:@"plist"];
    self.contentList = [NSArray arrayWithContentsOfFile:path];
    
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    [controllers release];
    
    // a page is the width of the scroll view
     scrollView.pagingEnabled = YES;
     scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
     scrollView.showsHorizontalScrollIndicator = NO;
     scrollView.showsVerticalScrollIndicator = NO;
     scrollView.scrollsToTop = NO;
     scrollView.delegate = self;
     
     pageControl.numberOfPages = kNumberOfPages;
     pageControl.currentPage = 0;
     
     // pages are created on demand
     // load the visible page
     // load the page on either side to avoid flashes when the user starts scrolling
     //
     [self loadScrollViewWithPage:0];
     [self loadScrollViewWithPage:1]; 

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction) pageChange {
    int i;
    i = 0;
}

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= kNumberOfPages)
        return;
    
    // replace the placeholder if necessary
    MyViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[MyViewController alloc] initWithPageNumber:page];
        [viewControllers replaceObjectAtIndex:page withObject:controller];
        [controller release];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
        
        NSDictionary *numberItem = [self.contentList objectAtIndex:page];
        controller.numberImage.image = [UIImage imageNamed:[numberItem valueForKey:ImageKey]];
        controller.numberTitle.text = [numberItem valueForKey:NameKey];
    }
}


#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.

    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}



@end
