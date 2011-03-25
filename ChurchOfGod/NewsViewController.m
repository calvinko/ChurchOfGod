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

#import "NewsViewController.h"
#import "MediaRecord.h"

#define kCustomRowHeight   48.0
#define kCustomRowCount     7

#pragma mark -

@interface NewsViewController ()

- (void)startIconDownload:(MediaRecord *)mediaRecord forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation NewsViewController

@synthesize entries;
@synthesize imageDownloadsInProgress;
@synthesize newsDetailView;


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
	self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if (didRelease) {
		[self.tableView reloadData];
	}
}

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
	// customize the appearance of table view cells
	//
	static NSString *CellIdentifier = @"NewsTableCell";
    static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";

    
    // add a placeholder cell while waiting on table data
    int nodeCount = [self.entries count];
	
	if (nodeCount == 0 && indexPath.row == 0)
	{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
        if (cell == nil)
		{
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
											reuseIdentifier:PlaceholderCellIdentifier] autorelease];   
            cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news_cell_bg.png"]];
			
        }
		
		cell.detailTextLabel.text = @"Loading…";
		
		return cell;
    }
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									   reuseIdentifier:PlaceholderCellIdentifier] autorelease]; 
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor redColor];
        NSString *backgroundImagePath = [[NSBundle mainBundle] pathForResource:@"news_cell_bg" ofType:@"png"];
        UIImage *backgroundImage = [UIImage imageWithContentsOfFile:backgroundImagePath];
        cell.backgroundView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
    }
	
    // Leave cells empty if there's no data yet
    if (nodeCount > 0)
	{
        // Set up the cell...
        MediaRecord *mediaRecord = [self.entries objectAtIndex:indexPath.row];
        
		cell.textLabel.text = mediaRecord.itemTitle;
        cell.detailTextLabel.text = [mediaRecord itemDateLongStyle];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // Only load cached images; defer new downloads until scrolling ends
        if (!mediaRecord.itemIcon)
        {
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
            {
                [self startIconDownload:mediaRecord forIndexPath:indexPath];
            }
            // if a download is deferred or in progress, return a placeholder image
			if (mediaRecord.imageURLString != nil) {
				cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
			}
        }
        else
        {
			cell.imageView.image = mediaRecord.itemIcon;
        }
		
    }

    return cell;
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
            
            if (!mediaRecord.itemIcon) // avoid the app icon download if the app already has an icon
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
        cell.imageView.image = iconDownloader.mediaRecord.itemIcon;
    }
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Navigation logic
	
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];

	// Do we have any records yet?
	if ([entries count] > 0) {
		
		MediaRecord *entry = [entries objectAtIndex: storyIndex];
        if ([entry isNewsFolder]) {
            NewsViewController *newsController = [[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:[NSBundle mainBundle]];
            newsController.title = entry.itemTitle;
            FeedLoader *newsFeedLoader = [[FeedLoader alloc] init];
            newsFeedLoader.delegate = newsController;
            
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:entry.itemContentURL]];
            newsFeedLoader.listFeedConnection = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:newsFeedLoader] autorelease];
            [self.navigationController pushViewController:newsController animated:YES];
        } else {
            newsDetailView.record = entry;
            newsDetailView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newsDetailView animated:YES];
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


// Implementation of the FromViewDelegate
- (void)reloadView:(NSMutableArray *)records 
{
	self.entries = records;
	[self.tableView reloadData];
}



@end


