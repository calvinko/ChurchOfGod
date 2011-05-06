//
//  SermonFolderViewController.m
//  ChurchOfGod
//
//  Created by Calvin Ko on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SermonFolderViewController.h"
#import "SermonSeriesViewController.h"
#import "MediaRecord.h"


#define kCustomRowHeight    48.0
#define kCustomRowCount     6

@interface SermonFolderViewController ()

- (void)startIconDownload:(MediaRecord *)mediaRecord forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation SermonFolderViewController

@synthesize entries;
@synthesize imageDownloadsInProgress;
@synthesize mediaDetailView;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    self.tableView.rowHeight = kCustomRowHeight;


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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (didRelease) {
		[self.tableView reloadData];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

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
	
	if (nodeCount == 0 && indexPath.row == 0)
	{
		
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
        if (cell == nil)
		{
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
										   reuseIdentifier:PlaceholderCellIdentifier] autorelease];   
            cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
		
		cell.detailTextLabel.text = @"Loading…";
		
		return cell;
    }
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									   reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
    // Leave cells empty if there's no data yet
    if (nodeCount > 0)
	{
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
		
    }
    
    return cell;

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
            
            //sViewController.topBanner.image = entry.itemIcon;
            //sViewController.topBanner.hidden = NO;
            sViewController.image = entry.itemIcon;
            
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

// Implementation of the FromViewDelegate
- (void)reloadView:(NSMutableArray *)records 
{
	self.entries = records;
    [self.tableView reloadData];
}



@end
