/* 
 Communique - The open church communications iPhone app.
 
 Copyright (C) 2010  Sugar Creek Baptist Church <info at sugarcreek.net> - 
 Rick Russell <rrussell at sugarcreek.net>
 
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License along
 with this program; if not, write to the Free Software Foundation, Inc.,
 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 
 */

#import "SermonsViewController.h"
#import "SermonSeriesViewController.h"
#import "SermonFolderViewController.h"
#import "MediaRecord.h"
#import "ConfigManager.h"

#define kCustomRowHeight    48.0
#define kCustomRowCount     6

#pragma mark -

@interface SermonsViewController ()

- (void)startIconDownload:(MediaRecord *)mediaRecord forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation SermonsViewController

@synthesize entries, allEntries;
@synthesize imageDownloadsInProgress;
@synthesize mediaDetailView;
@synthesize selector;
@synthesize headerCell;
@synthesize refleshItem;


#pragma mark 

-(id)init
{
	self = [super init];
	didRelease = NO;
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    self.tableView.rowHeight = kCustomRowHeight;
}

- (void)viewDidUnload
{
	//self.entries = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if (didRelease) {
		[self.tableView reloadData];
	}
}

/*
-(void)viewDidAppear:(BOOL)animated
{
	if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
        [UIView beginAnimations:@"View Flip" context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.tabBarController.view.transform = CGAffineTransformIdentity;
        self.tabBarController.view.transform =
		CGAffineTransformMakeRotation(M_PI * (90) / 180.0);
        self.view.bounds = CGRectMake(0.0f, 0.0f, 320.0f, 480.0f);
        [UIView commitAnimations];
    }
}
*/

- (void)dealloc
{
    [entries release];
	[imageDownloadsInProgress release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    didRelease = YES;
    // terminate all pending download connections
    //NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    //[allDownloads performSelector:@selector(cancelDownload)];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table view creation (UITableViewDataSource)

// customize the number of rows in the table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int count = [entries count];
	
	// ff there's no data yet, return enough rows to fill the screen
    if (count == 0)
	{
        return kCustomRowCount;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"MediaTableCell";
    static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
    
    // add a placeholder cell while waiting on table data
    int nodeCount = [self.entries count];
	
	if (nodeCount <= 0 )
	{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
        if (cell == nil)
		{
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
										   reuseIdentifier:PlaceholderCellIdentifier] autorelease];   
            cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.imageView.image = nil;
		cell.detailTextLabel.text = @"";
        if (indexPath.row == 0) {
		     cell.detailTextLabel.text = @"Loading…";
		}
		return cell;
    } else {
        // Leave cells empty if there's no data yet
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:CellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = @"Empty";
        }

        // Set up the cell...
        MediaRecord *mediaRecord = [self.entries objectAtIndex:indexPath.row];
        
		cell.textLabel.text = mediaRecord.itemTitle;
        [cell.textLabel setFont:[UIFont systemFontOfSize:18]];
        cell.detailTextLabel.text = [mediaRecord itemDateLongStyle];
		
        // Only load cached images; defer new downloads until scrolling ends
        if (!mediaRecord.itemIcon)
        {
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
            {
                [self startIconDownload:mediaRecord forIndexPath:indexPath];
            }
            // if a download is deferred or in progress, return a placeholder image
            cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];                
        }
        else
        {
			cell.imageView.image = mediaRecord.itemThumbIcon;
        }
		return cell;
    }
    
}


#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(MediaRecord *)mediaRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil) 
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.mediaRecord = mediaRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];   
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([self.entries count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            MediaRecord *mediaRecord = [self.entries objectAtIndex:indexPath.row];
            
            if (!mediaRecord.itemThumbIcon) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:mediaRecord forIndexPath:indexPath];
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // Display the newly loaded image
        cell.imageView.image = iconDownloader.mediaRecord.itemThumbIcon;
    }
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Navigation logic
	
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];

	// Do we have any records yet?
	if ([entries count] > 0) {
		
        MediaRecord *entry = [entries objectAtIndex: storyIndex];
        if ([entry isSermonFolder]) {
            SermonFolderViewController *sermonController = [[SermonFolderViewController alloc] init];
                                                     
            sermonController.title = entry.itemTitle;
            FeedLoader *sermonFeedLoader = [[FeedLoader alloc] init];
            sermonFeedLoader.delegate = sermonController;
            
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:entry.itemContentURL]];
            sermonFeedLoader.listFeedConnection = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:sermonFeedLoader] autorelease];
            [self.navigationController pushViewController:sermonController animated:YES];
        } else if ([entry isSermonSeries]){
            SermonSeriesViewController *sViewController = [[SermonSeriesViewController alloc] initWithNibName:@"SermonSeriesViewController" bundle:nil];
            sViewController.title = entry.itemTitle;
            FeedLoader *sermonFeedLoader = [[FeedLoader alloc] init];
            sermonFeedLoader.delegate = sViewController;
            
            sViewController.image = entry.itemIcon;
            sViewController.itemIcon = entry.itemIcon;
            sViewController.itemThumbIcon = entry.itemThumbIcon;
            
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:entry.itemContentURL]];
            sermonFeedLoader.listFeedConnection = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:sermonFeedLoader] autorelease];
            
            [self.navigationController pushViewController:sViewController animated:YES];
            [sViewController release];

        } else {
            mediaDetailView = [[MediaDetailViewController alloc] initWithNibName:@"MediaDetail" bundle:[NSBundle mainBundle]];
            mediaDetailView.record = entry;
            [self.navigationController pushViewController:mediaDetailView animated:YES];
        }
	}
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

NSArray *getFilterRecord(NSArray *inArray, NSString *cat) {
    NSMutableArray *a = [[[NSMutableArray alloc] init ] autorelease];
    NSEnumerator *enumerator = [inArray objectEnumerator];
    MediaRecord *r;
    
    while ((r = [enumerator nextObject])) {
        // match string
        NSRange range = [r.itemCategory rangeOfString:cat]; 
        if (range.length != 0) {
            [a addObject:r];
        }
    };
    return a;
}

// Implementation of the FromViewDelegate
- (void)reloadView:(NSMutableArray *)records 
{
	self.allEntries = records;
    switch (self.selector.selectedSegmentIndex) {
        case 0: 
            self.entries = getFilterRecord(self.allEntries, @"Recent");
            break;
        case 1:
            self.entries = getFilterRecord(self.allEntries, @"Featured");
            break;
        case 2:
            self.entries = self.allEntries;
            break;
        default: 
            self.entries = self.allEntries;
            break;
    };
	[self.tableView reloadData];
}

-(IBAction) segmentControlTapped:(id)sender
{
   	switch (self.selector.selectedSegmentIndex) {
        case 0: 
            self.entries = getFilterRecord(self.allEntries, @"Recent");
            break;
        case 1:
            self.entries = getFilterRecord(self.allEntries, @"Featured");;
            break;
        case 2:
            self.entries = self.allEntries;
            break;
        default: 
            self.entries = self.allEntries;
            break;
    };
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
	[self.tableView reloadData];

}


@end
