//
//  SongTextViewController.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SongTextViewController : UIViewController {
@private
    
    UITextView *songText;
    UILabel *nameLabel;
}


@property (nonatomic, retain) IBOutlet UITextView *songText;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;

@end
