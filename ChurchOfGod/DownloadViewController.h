//
//  DownloadViewController.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@class DownloadedMediaRecord;


@interface DownloadViewController : UITableViewController {
    NSMutableArray *downloadedItemArray;
    DownloadedMediaRecord *currentRecord;
    UITableViewCell *dlCell;
	MPMoviePlayerViewController *theMovieController;
}


@property (nonatomic, retain) NSMutableArray *downloadedItemArray;
@property (nonatomic, retain) DownloadedMediaRecord *currentRecord;
@property (nonatomic, assign) IBOutlet UITableViewCell *dlCell;

-(void) playMovieInRecord: (DownloadedMediaRecord *) record;
@end
