//
//  SongViewController.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SongIndexViewController;
@class PDBReader;
@interface SongViewController : UITableViewController {
    SongIndexViewController *iViewController;
}

@property (nonatomic, retain) SongIndexViewController *iViewController;

@end
