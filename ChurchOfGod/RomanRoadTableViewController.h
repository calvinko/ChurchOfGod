//
//  RomanRoadTableViewController.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "SectionHeaderView.h"

@class QuoteCell;



@interface RomanRoadTableViewController : UITableViewController <SectionHeaderViewDelegate> {
}

@property (nonatomic, retain) NSArray* plays;
@property (nonatomic, assign) IBOutlet QuoteCell *quoteCell;


@end
