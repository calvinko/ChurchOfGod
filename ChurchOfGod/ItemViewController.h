//
//  ItemViewController.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 3/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  MediaRecord;


@interface ItemViewController : UITableViewController {
    UIImageView *topBanner;
    MediaRecord *record;
}

@property (nonatomic, retain) IBOutlet UIImageView *topBanner;
@property (nonatomic, retain) MediaRecord *record; 
@end
