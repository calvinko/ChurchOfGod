//
//  DownloadViewController.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DownloadViewController : UITableViewController {
    NSMutableArray *downloadedItemArray;
    UITableViewCell *dlCell;
}

@property (nonatomic, retain) NSMutableArray *downloadedItemArray;
@property (nonatomic, assign) IBOutlet UITableViewCell *dlCell;

@end
