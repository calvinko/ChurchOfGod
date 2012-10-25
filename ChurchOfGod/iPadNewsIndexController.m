//
//  iPadNewsIndexController.m
//  ChurchOfGod
//
//  Created by Calvin Ko on 9/10/12.
//
//

#import "iPadNewsIndexController.h"
#import "iPadNewsDetailViewController.h"
#import "MediaRecord.h"

@interface iPadNewsIndexController ()

- (void)startIconDownload:(MediaRecord *)mediaRecord forIndexPath:(NSIndexPath *)indexPath;

@end

@implementation iPadNewsIndexController
@synthesize splitViewController, rootViewController, aView;


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
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsTableCell";
    static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
    
    // add a placeholder cell while waiting on table data
    int nodeCount = [self.entries count];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									   reuseIdentifier:PlaceholderCellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //NSString *backgroundImagePath = [[NSBundle mainBundle] pathForResource:@"news_cell_bg" ofType:@"png"];
        //UIImage *backgroundImage = [UIImage imageWithContentsOfFile:backgroundImagePath];
        //cell.backgroundView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
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
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // Display the newly loaded image
        cell.imageView.image = iconDownloader.mediaRecord.itemIcon;
    }
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
    if ([self.entries count] > 0) {
        MediaRecord *entry = [self.entries objectAtIndex: storyIndex];

        if ([entry isNewsFolder]) {
            
            iPadNewsIndexController *newsController = [[iPadNewsIndexController alloc] init];
            newsController.rootViewController = self.rootViewController;
            newsController.splitViewController = self.splitViewController;

            newsController.title = entry.itemTitle;
            FeedLoader *newsFeedLoader = [[FeedLoader alloc] init];
            newsFeedLoader.delegate = newsController;
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:entry.itemContentURL]];
            newsFeedLoader.listFeedConnection = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:newsFeedLoader] autorelease];
            [self.navigationController pushViewController:newsController animated:YES];
            
        } else {

            iPadNewsDetailViewController *iPadNewsDetailController = [[iPadNewsDetailViewController alloc] init];
            iPadNewsDetailController.record = entry;
            UIViewController <SubstitutableDetailViewController> *detailViewController = iPadNewsDetailController;
            
            UIViewController *vc1 = [splitViewController.viewControllers objectAtIndex:0];
            NSArray *viewControllers = [[NSArray alloc] initWithObjects:vc1, detailViewController, nil];
            splitViewController.viewControllers = viewControllers;
            [viewControllers release];
            
            // Dismiss the popover if it's present.
            [rootViewController dismissPopOverWindow];
            
            // Configure the new view controller's popover button (after the view has been displayed and its toolbar/navigation bar has been created).
            
            if (self.rootViewController.rootPopoverButtonItem != nil) {
                [detailViewController showRootPopoverButtonItem:self.rootViewController.rootPopoverButtonItem];
            }
            
            [detailViewController release];
        }
    }
}

- (void)reloadView:(NSMutableArray *)records
{
	self.entries = records;
	[self.tableView reloadData];
}


@end
