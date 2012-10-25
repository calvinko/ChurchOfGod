//
//  iPadMediaViewController.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 9/19/12.
//
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AudioDownloader.h"
#import "DownloadedMediaRecord.h"
#import "MediaRecord.h"
#import "RootViewController.h"

@interface iPadMediaViewController : UIViewController <SubstitutableDetailViewController> {
    
    UIToolbar *toolbar;
    UILabel *mediaTitle;
	UIImageView *icon;
	UITextView  *description;
	UIButton *playVideoButton;
	UIButton *playAudioButton;
    UIButton *downloadAudioButton;
    UIButton *cancelButton;
	MPMoviePlayerViewController *theMovieController;
	MediaRecord *record;
    UIProgressView *pView;
    bool downloading;
    
@private
    MPMoviePlayerController *moviePlayerController;
        
    //	IBOutlet MyImageView *imageView;
	IBOutlet UIImageView *movieBackgroundImageView;
	IBOutlet UIView *backgroundView;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIView *overlayView;
@property (nonatomic, retain) IBOutlet UILabel *mediaTitle;
@property (nonatomic, retain) IBOutlet UIImageView *icon;
@property (nonatomic, retain) IBOutlet UITextView  *description;
@property (nonatomic, retain) IBOutlet UIButton  *playVideoButton;
@property (nonatomic, retain) IBOutlet UIButton  *playAudioButton;
@property (nonatomic, retain) IBOutlet UIButton  *downloadAudioButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem  *donePlayButton;
@property (nonatomic, retain) IBOutlet UIButton  *cancelButton;
@property (nonatomic, retain) IBOutlet UIProgressView *pView;

@property (nonatomic, retain) MediaRecord *record;
@property (nonatomic) bool downloading;


@property (nonatomic, retain) IBOutlet UIImageView *movieBackgroundImageView;
@property (nonatomic, retain) IBOutlet UIView *backgroundView;
@property (retain) MPMoviePlayerController *moviePlayerController;


- (void)viewWillEnterForeground;
- (void)playMovieFile:(NSURL *)movieFileURL;
- (void)playMovieStream:(NSURL *)movieFileURL;

-(IBAction)closeButtonPress:(id)sender;
-(IBAction) playVideoTapped;
-(IBAction) playAudioTapped;
-(IBAction) downloadAudioTapped;
-(IBAction) cancelTapped;

- (void)playMovieAtURL:(NSURL *)theURL;
- (void)playMovieInRecord: (DownloadedMediaRecord *) drec;


@end
