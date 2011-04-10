//
//  SongIndexViewController.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SongTextViewController;
@class PDBReader;
@interface SongIndexViewController : UITableViewController {
    PDBReader *reader;
    SongTextViewController *stViewController;
}

@property (nonatomic, retain) SongTextViewController *stViewController;
@property (nonatomic, retain) PDBReader *reader;

@end
