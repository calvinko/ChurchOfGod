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

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AudioDownloader.h"

@class MediaRecord;
@class DownloadedMediaRecord;

@interface MediaDetailViewController : UIViewController <AudioDownloaderDelegate> {
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
}

@property (nonatomic, retain) IBOutlet UILabel *mediaTitle;
@property (nonatomic, retain) IBOutlet UIImageView *icon;
@property (nonatomic, retain) IBOutlet UITextView  *description;
@property (nonatomic, retain) IBOutlet UIButton  *playVideoButton;
@property (nonatomic, retain) IBOutlet UIButton  *playAudioButton;
@property (nonatomic, retain) IBOutlet UIButton  *downloadAudioButton;
@property (nonatomic, retain) IBOutlet UIButton  *cancelButton;
@property (nonatomic, retain) IBOutlet UIProgressView *pView;

@property (nonatomic, retain) MediaRecord *record;
@property (nonatomic) bool downloading;



-(IBAction) playVideoTapped;
-(IBAction) playAudioTapped;
-(IBAction) downloadAudioTapped;
-(IBAction) cancelTapped;

- (void)playMovieAtURL:(NSURL *)theURL;
- (void)playMovieInRecord: (DownloadedMediaRecord *) drec;

@end
