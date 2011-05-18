/* 
 ChurchOfGod
 //
 //  Created by Calvin Ko on 5/3/11.
 //  Copyright 2011 KoSolution.net All rights reserved.
 */

#import "MediaDetailViewController.h"
#import "MediaRecord.h"
#import "ConfigManager.h"
#import "AudioDownloader.h"
#import "DownloadViewController.h"
#import "DownloadedMediaRecord.h"

@implementation MediaDetailViewController

@synthesize mediaTitle, icon, description, playVideoButton, playAudioButton, downloadAudioButton, cancelButton, pView;
@synthesize downloading, record;

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	mediaTitle.text = self.record.itemTitle;
	
	description.text = self.record.itemDescription;
	
	if(self.record.itemAudioURLString == nil)
	{
		playAudioButton.hidden = YES;
        downloadAudioButton.hidden = YES;
	} else {
		playAudioButton.hidden = NO;
        downloadAudioButton.hidden = NO;
        if ([ConfigManager findDownloadedMediaByName:[self.record.itemAudioURLString lastPathComponent]] != nil) {
            UIView *v1 = [self.view viewWithTag:11];
            v1.hidden = NO;
        }
	}
	
	if (self.record.itemVideoURLString == nil) {
		playVideoButton.hidden = YES;
	} else {
		playVideoButton.hidden = NO;
	}
	
	
	if (self.record.itemIcon != nil) {
		icon.image = self.record.itemIcon;
		icon.hidden = NO;
	} else {
		icon.hidden = YES;
	}
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction) playVideoTapped
{
	NSString * storyLink = self.record.itemVideoURLString;
	
	// clean up the link - get rid of spaces, returns, and tabs...
	storyLink = [storyLink stringByReplacingOccurrencesOfString:@" " withString:@""];
	storyLink = [storyLink stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	storyLink = [storyLink stringByReplacingOccurrencesOfString:@"	" withString:@""];

	NSLog(@"link: %@", storyLink);
	[self playMovieAtURL:[NSURL URLWithString:storyLink]];
}


-(IBAction) playAudioTapped
{
	NSString * storyLink = self.record.itemAudioURLString;
	
	// clean up the link - get rid of spaces, returns, and tabs...
	storyLink = [storyLink stringByReplacingOccurrencesOfString:@" " withString:@""];
	storyLink = [storyLink stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	storyLink = [storyLink stringByReplacingOccurrencesOfString:@"	" withString:@""];
	
	NSLog(@"audioLink: %@", storyLink);
    
    DownloadedMediaRecord *rec = [ConfigManager findDownloadedMediaByName:[self.record.itemAudioURLString lastPathComponent]];
    if (rec != nil) {
        [self playMovieInRecord:rec];
    } else {
        [self playMovieAtURL:[NSURL URLWithString:storyLink]];
    }
}

-(IBAction) downloadAudioTapped
{
    if ([ConfigManager findDownloadedMediaByName:[self.record.itemAudioURLString lastPathComponent]] == nil) {
        NSString * storyLink = self.record.itemAudioURLString;
        NSLog(@"audioLink: %@", storyLink);
        AudioDownloader *loader = [[[AudioDownloader alloc] init] autorelease];
        self.record.loader = loader;
        loader.audioURL = self.record.itemAudioURLString;
        loader.fileName = [loader.audioURL lastPathComponent];
        loader.filePath = [[ConfigManager getDocumentPath] stringByAppendingPathComponent:loader.fileName ];
        loader.delegate = self;
        loader.fileSize = self.record.audioFileSize;
        loader.pview = self.pView;
        [loader startDownload];
        
        self.pView.hidden = NO;
        UIView *v1 = [self.view viewWithTag:9];
        v1.hidden = NO;
        self.cancelButton.hidden = NO;
        [self.navigationController setNavigationBarHidden:YES animated:YES];  
    }
    //DownloadViewController *dview = [[DownloadViewController alloc] init]; 
    //dview.downloadedItemArray = [ConfigManager getDownloadedMediaArray];
    //[dview.downloadedItemArray addObject:self.record];
    //[self.navigationController pushViewController:dview animated:YES];
    //[dview release];
}

-(IBAction) cancelTapped
{
    [self.record.loader stopDownload];
    self.record.loader = nil;
    sleep(1);
    [self.navigationController setNavigationBarHidden:NO animated:YES]; 
    self.pView.hidden = YES;
    UIView *v1 = [self.view viewWithTag:9];
    v1.hidden = YES;
    self.cancelButton.hidden = YES;
}

-(void) playMovieInRecord: (DownloadedMediaRecord *) drec  {
	
	NSURL *theURL;
    NSString *path = [[ConfigManager getDocumentPath] stringByAppendingPathComponent:drec.fileName ];
    theURL = [[[NSURL alloc] initFileURLWithPath:path] autorelease];
    theMovieController = [[MPMoviePlayerViewController alloc] initWithContentURL: theURL];
	MPMoviePlayerController* theMovie = [theMovieController moviePlayer];
    
	
	NSError *setCategoryErr = nil;
	NSError *activationErr  = nil;
	[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryErr];
	[[AVAudioSession sharedInstance] setActive: YES error: &activationErr];
    [[NSNotificationCenter defaultCenter]
	 addObserver: self
	 selector: @selector(myMovieFinishedCallback:)
	 name: MPMoviePlayerPlaybackDidFinishNotification
	 object: theMovie];
	[theMovie prepareToPlay];
    [[theMovieController moviePlayer] play];
	theMovie.initialPlaybackTime = drec.currentPlaybackTime;
	[self.navigationController presentMoviePlayerViewControllerAnimated:theMovieController];
}



-(void) playMovieAtURL: (NSURL*) theURL {
	
	
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
    theMovie.initialPlaybackTime = record.currentPlaybackTime;
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
    self.record.currentPlaybackTime = tval;
    DownloadedMediaRecord *rec = [ConfigManager findDownloadedMediaByName:[self.record.itemAudioURLString lastPathComponent]];
    if (rec != nil) {
        rec.currentPlaybackTime = tval;
    }
    // Release the movie instance created in playMovieAtURL:
    [theMovieController release];
	
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark audioDownloader delegate

- (void)audioFileDidLoad:(NSString *)fileName
{
    self.pView.hidden = NO;
    UIView *v1 = [self.view viewWithTag:9];
    v1.hidden = YES;
    v1 = [self.view viewWithTag:11];
    v1.hidden = NO;
    self.cancelButton.hidden = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES]; 
    [ConfigManager  addSermonToStore:self.record withFileName:self.record.loader.fileName];
    [ConfigManager  saveMediaList];
    record.loader = nil;
    return;
}

@end