//
//  DownloadViewController.m
//  ChurchOfGod
//
//  Created by Calvin Ko on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadViewController.h"
#import "ConfigManager.h"
#import "AudioDownloader.h"
#import "MediaRecord.h"
#import "DownloadedMediaRecord.h"

@implementation DownloadViewController
@synthesize downloadedItemArray, currentRecord, dlCell;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.downloadedItemArray = [ConfigManager getDownloadedMediaArray];
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
    return [self.downloadedItemArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DLCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        //[[NSBundle mainBundle] loadNibNamed:@"DownloadCell" owner:self options:nil];
        //cell = dlCell;
        //self.dlCell = nil;
        
    }
    
    /*MediaRecord *rec = [downloadedItemArray objectAtIndex:indexPath.row];
    UILabel *label;
    label = (UILabel *)[cell viewWithTag:1];
    label.text = rec.itemTitle;
    
    UILabel *label1;
    label1 = (UILabel *)[cell viewWithTag:2];
    label1.text = @"24.5M";
    
    rec.loader.pview = (UIProgressView *)[cell viewWithTag:3];
     */
    
    DownloadedMediaRecord *rec = [self.downloadedItemArray objectAtIndex:indexPath.row];
    cell.textLabel.text = rec.itemTitle;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DownloadedMediaRecord *rec = [downloadedItemArray objectAtIndex:indexPath.row];
    self.currentRecord = rec;
    [self playMovieInRecord:rec];
    
}

-(void) playMovieInRecord: (DownloadedMediaRecord *) record  {
	
	NSURL *theURL;
    NSString *path = [[ConfigManager getDocumentPath] stringByAppendingPathComponent:record.fileName ];
    theURL = [[[NSURL alloc] initFileURLWithPath:path] autorelease];
    theMovieController = [[MPMoviePlayerViewController alloc] initWithContentURL: theURL];
	MPMoviePlayerController* theMovie = [theMovieController moviePlayer];
    
	
	NSError *setCategoryErr = nil;
	NSError *activationErr  = nil;
	[[AVAudioSession sharedInstance]
	 setCategory: AVAudioSessionCategoryPlayback
	 error: &setCategoryErr];
	[[AVAudioSession sharedInstance]
	 setActive: YES
	 error: &activationErr];
    //theMovie.scalingMode = MPMovieScalingModeAspectFill;
    // theMovie.movieControlMode = MPMovieControlModeHidden;
	
    // Register for the playback finished notification
    [[NSNotificationCenter defaultCenter]
	 addObserver: self
	 selector: @selector(myMovieFinishedCallback:)
	 name: MPMoviePlayerPlaybackDidFinishNotification
	 object: theMovie];
	[theMovie prepareToPlay];
    // Movie playback is asynchronous, so this method returns immediately.
    //theMovie.initialPlaybackTime = record.currentPlaybackTime;
    [[theMovieController moviePlayer] play];
	
	[self.navigationController presentMoviePlayerViewControllerAnimated:theMovieController];
}

// When the movie is done, release the controller.
-(void) myMovieFinishedCallback: (NSNotification*) aNotification
{
    MPMoviePlayerController* theMovie = [aNotification object];
	
    [[NSNotificationCenter defaultCenter]
	 removeObserver: self
	 name: MPMoviePlayerPlaybackDidFinishNotification
	 object: theMovie];
	
    NSTimeInterval tval = theMovie.currentPlaybackTime;
    //self.currentRecord.currentPlaybackTime = tval;
    // Release the movie instance created in playMovieAtURL:
    [theMovieController release];
	
}



@end
