//
//  SongIndexViewController.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongReader.h"

@class SongTextViewController;

@interface SongIndexViewController : UITableViewController {
    id <SongReader> reader;
    NSUInteger songBookID;

}

@property (nonatomic, retain) id <SongReader> reader;
@property (nonatomic) NSUInteger songBookID;


@end
