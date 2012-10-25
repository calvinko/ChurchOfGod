//
//  iPadSermonIndexController.m
//  ChurchOfGod
//
//  Created by Calvin Ko on 9/10/12.
//
//

#import "iPadSermonIndexController.h"
#import "FirstDetailViewController.h"
#import "iPadMediaViewController.h"

@interface iPadSermonIndexController ()

@end

@implementation iPadSermonIndexController

@synthesize splitViewController, rootViewController, entries, imageDownloadsInProgress;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = [self.entries count];
    if (count == 0)
        return 1;
    else
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

- (void)startIconDownload:(MediaRecord *)mediaRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.mediaRecord = mediaRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
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
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // Display the newly loaded image
        cell.imageView.image = iconDownloader.mediaRecord.itemThumbIcon;
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
	// Do we have any records yet?
	if ([entries count] > 0) {
		
        MediaRecord *entry = [entries objectAtIndex: indexPath.row];
        if ([entry isSermonFolder] || [entry isSermonSeries]) {
            iPadSermonIndexController *sermonIndexController = [[iPadSermonIndexController alloc] init];
            sermonIndexController.rootViewController = self.rootViewController;
            sermonIndexController.splitViewController = self.splitViewController;
            sermonIndexController.title = entry.itemTitle;
            FeedLoader *sermonFeedLoader = [[FeedLoader alloc] init];
            sermonFeedLoader.delegate = sermonIndexController;
            
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:entry.itemContentURL]];
            sermonFeedLoader.listFeedConnection = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:sermonFeedLoader] autorelease];
            [self.navigationController pushViewController:sermonIndexController animated:YES];
        } else {
            UIViewController <SubstitutableDetailViewController> *detailViewController = nil;
            iPadMediaViewController *newDetailViewController = [[iPadMediaViewController alloc] init];
            detailViewController = newDetailViewController;
            
            UIViewController *vc1 = [splitViewController.viewControllers objectAtIndex:0];
            NSArray *viewControllers = [[NSArray alloc] initWithObjects:vc1, detailViewController, nil];
            splitViewController.viewControllers = viewControllers;
            [viewControllers release];
            
            [rootViewController dismissPopOverWindow];
            
            // Configure the new view controller's popover button (after the view has been displayed and its toolbar/navigation bar has been created).
            
            if (self.rootViewController.rootPopoverButtonItem != nil) {
                [detailViewController showRootPopoverButtonItem:self.rootViewController.rootPopoverButtonItem];
            }
        }
	}
}

// Implementation of the FromViewDelegate
- (void)reloadView:(NSMutableArray *)records
{
	self.entries = records;
    [self.tableView reloadData];
}


@end
