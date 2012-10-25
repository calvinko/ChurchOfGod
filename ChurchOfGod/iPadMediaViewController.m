//
//  iPadMediaViewController.m
//  ChurchOfGod
//
//  Created by Calvin Ko on 9/19/12.
//
//

#import "iPadMediaViewController.h"
#import "MediaRecord.h"
#import "DownloadedMediaRecord.h"
#import "ConfigManager.h"

CGFloat kMovieViewOffsetX = 4.0;
CGFloat kMovieViewOffsetY = 2.0;

@interface iPadMediaViewController ()

@end

@implementation iPadMediaViewController
@synthesize toolbar, record, playAudioButton, playVideoButton, pView, overlayView, downloadAudioButton, donePlayButton;
@synthesize movieBackgroundImageView, backgroundView, moviePlayerController, icon, description, mediaTitle, downloading, cancelButton;

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

#pragma mark -
#pragma mark Managing the popover

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


#pragma mark -
#pragma mark Rotation support


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)removeMovieViewFromViewHierarchy
{
    MPMoviePlayerController *player = [self moviePlayerController];
    
	[player.view removeFromSuperview];
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
    theMovie.scalingMode = MPMovieScalingModeAspectFill;
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
	
	[self presentMoviePlayerViewControllerAnimated:theMovieController];
}

-(void)createAndConfigurePlayerWithURL:(NSURL *)movieURL sourceType:(MPMovieSourceType)sourceType
{
    /* Create a new movie player object. */
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    
    if (player)
    {
        /* Save the movie object. */
        [self setMoviePlayerController:player];
        
        /* Register the current object as an observer for the movie
         notifications. */
        [self installMovieNotificationObservers];
        
        /* Specify the URL that points to the movie file. */
        [player setContentURL:movieURL];
        
        /* If you specify the movie type before playing the movie it can result
         in faster load times. */
        [player setMovieSourceType:sourceType];
        
        /* Apply the user movie preference settings to the movie player object. */
        //[self applyUserSettingsToMoviePlayer];
        
        /* Add a background view as a subview to hide our other view controls
         underneath during movie playback. */
        [self.view addSubview:self.backgroundView];
        
        UIView *iview = [[self view] viewWithTag:1];
        
        CGRect viewInsetRect = CGRectInset ([iview bounds], kMovieViewOffsetX, kMovieViewOffsetY );
        CGRect viewRect = CGRectOffset(viewInsetRect, 0,44);
        /* Inset the movie frame in the parent view frame. */
        [[player view] setFrame:viewRect];
        
        [player view].backgroundColor = [UIColor lightGrayColor];
        
        /* To present a movie in your application, incorporate the view contained
         in a movie player’s view property into your application’s view hierarchy.
         Be sure to size the frame correctly. */
        [self.view addSubview: [player view]];
    }
}


/* Load and play the specified movie url with the given file type. */
-(void)createAndPlayMovieForURL:(NSURL *)movieURL sourceType:(MPMovieSourceType)sourceType
{
    [self createAndConfigurePlayerWithURL:movieURL sourceType:sourceType];
    
    /* Play the movie! */
    [[self moviePlayerController] play];
}

/* Returns a URL to a local movie in the app bundle. */
-(NSURL *)localMovieURL
{
	NSURL *theMovieURL = nil;
	NSBundle *bundle = [NSBundle mainBundle];
	if (bundle)
	{
		//NSString *moviePath = [bundle pathForResource:@"Movie" ofType:@"m4v"];
        NSString *moviePath = [bundle pathForResource:@"canon" ofType:@"mp3"];

		if (moviePath)
		{
			theMovieURL = [NSURL fileURLWithPath:moviePath];
		}
	}
    return theMovieURL;
}

#pragma mark Movie Notification Handlers

- (void)loadStateDidChange:(NSNotification *)notification
{
	MPMoviePlayerController *player = notification.object;
	MPMovieLoadState loadState = player.loadState;
    
	/* The load state is not known at this time. */
	if (loadState & MPMovieLoadStateUnknown)
	{
        //[self.overlayController setLoadStateDisplayString:@"n/a"];
        
        //[overlayController setLoadStateDisplayString:@"unknown"];
	}
	
	/* The buffer has enough data that playback can begin, but it
	 may run out of data before playback finishes. */
	if (loadState & MPMovieLoadStatePlayable)
	{
        //[overlayController setLoadStateDisplayString:@"playable"];
	}
	
	/* Enough data has been buffered for playback to continue uninterrupted. */
	if (loadState & MPMovieLoadStatePlaythroughOK)
	{
        // Add an overlay view on top of the movie view
        //[self addOverlayView];
        
        //[overlayController setLoadStateDisplayString:@"playthrough ok"];
	}
	
	/* The buffering of data has stalled. */
	if (loadState & MPMovieLoadStateStalled)
	{
        //[overlayController setLoadStateDisplayString:@"stalled"];
	}
}

/* Called when the movie playback state has changed. */
- (void) moviePlayBackStateDidChange:(NSNotification*)notification
{
	MPMoviePlayerController *player = notification.object;
    
	/* Playback is currently stopped. */
	if (player.playbackState == MPMoviePlaybackStateStopped)
	{
        //[overlayController setPlaybackStateDisplayString:@"stopped"];
	}
	/*  Playback is currently under way. */
	else if (player.playbackState == MPMoviePlaybackStatePlaying)
	{
        //[overlayController setPlaybackStateDisplayString:@"playing"];
	}
	/* Playback is currently paused. */
	else if (player.playbackState == MPMoviePlaybackStatePaused)
	{
        //[overlayController setPlaybackStateDisplayString:@"paused"];
	}
	/* Playback is temporarily interrupted, perhaps because the buffer
	 ran out of content. */
	else if (player.playbackState == MPMoviePlaybackStateInterrupted)
	{
        //[overlayController setPlaybackStateDisplayString:@"interrupted"];
	}
}

/*  Notification called when the movie finished playing. */
- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    NSNumber *reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
	switch ([reason integerValue])
	{
            /* The end of the movie was reached. */
		case MPMovieFinishReasonPlaybackEnded:
            /*
             Add your code here to handle MPMovieFinishReasonPlaybackEnded.
             */
            self.donePlayButton.enabled = FALSE;
			break;
            
            /* An error was encountered during playback. */
		case MPMovieFinishReasonPlaybackError:
            NSLog(@"An error was encountered during playback");
            [self performSelectorOnMainThread:@selector(displayError:) withObject:[[notification userInfo] objectForKey:@"error"]
                                waitUntilDone:NO];
            [self removeMovieViewFromViewHierarchy];
            
            [self.backgroundView removeFromSuperview];
            self.donePlayButton.enabled = FALSE;
			break;
            
            /* The user stopped playback. */
		case MPMovieFinishReasonUserExited:
            [self removeMovieViewFromViewHierarchy];
            self.donePlayButton.enabled = FALSE;
            break;
            
		default:
			break;
	}
}

/* Notifies observers of a change in the prepared-to-play state of an object
 conforming to the MPMediaPlayback protocol. */
- (void) mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
	// Add an overlay view on top of the movie view
    //[self addOverlayView];
    self.donePlayButton.enabled = TRUE;
}



#pragma mark Install Movie Notifications

/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{
    MPMoviePlayerController *player = [self moviePlayerController];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:player];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:player];
}

#pragma mark Remove Movie Notification Handlers

/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationHandlers
{
    MPMoviePlayerController *player = [self moviePlayerController];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:player];
}

/* Delete the movie player object, and remove the movie notification observers. */
-(void)deletePlayerAndNotificationObservers
{
    [self removeMovieNotificationHandlers];
    [self setMoviePlayerController:nil];
}

#pragma mark -



/* Add an overlay view on top of the movie. This view will display movie
 play states and includes a 'Close Movie' button. */
-(void)addOverlayView
{
    MPMoviePlayerController *player = [self moviePlayerController];
    
    if (!([self.overlayView isDescendantOfView:self.view])
        && ([player.view isDescendantOfView:self.view]))
    {
        CGRect frame = CGRectFromString(@"{{400,60},{40,40}}") ;
        self.overlayView.frame = frame;
        // add an overlay view to the window view hierarchy
        [self.view addSubview:self.overlayView];
    }
}

/* Remove overlay view from the view hierarchy. */
-(void)removeOverlayView
{
	[self.overlayView removeFromSuperview];
}

-(void)resizeOverlayWindow
{
	CGRect frame = self.overlayView.frame;
	frame.origin.x = round((self.view.frame.size.width - frame.size.width) / 2.0);
	frame.origin.y = round((self.view.frame.size.height - frame.size.height) / 2.0);
	self.overlayView.frame = frame;
}

-(IBAction) playAudioTapped
{
    [self createAndPlayMovieForURL:[self localMovieURL] sourceType:MPMovieSourceTypeFile];
}

-(IBAction) playVideoTapped
{
    [self createAndPlayMovieForURL:[self localMovieURL] sourceType:MPMovieSourceTypeFile];
}

-(IBAction)closeButtonPress:(id)sender
{
	[[self moviePlayerController] stop];
    
	[self removeMovieViewFromViewHierarchy];
    
	[self removeOverlayView];
	//[self.backgroundView removeFromSuperview];
    
    [self deletePlayerAndNotificationObservers];
}

@end
