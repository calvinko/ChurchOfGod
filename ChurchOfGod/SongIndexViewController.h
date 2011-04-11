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
    NSMutableArray *songTextViewControllerArray;
    NSMutableDictionary *cmap;
    PDBReader *reader;
    NSUInteger songBookID;

}
@property (nonatomic, retain) NSMutableArray *songTextViewControllerArray;
@property (nonatomic, retain) NSMutableDictionary *cmap;
@property (nonatomic, retain) PDBReader *reader;
@property (nonatomic) NSUInteger songBookID;


@end
