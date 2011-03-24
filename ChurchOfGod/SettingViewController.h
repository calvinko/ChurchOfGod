//
//  SettingViewController.h
//  ChurchofGod
//
//  Created by Calvin Ko on 3/9/11.
//  Copyright 2011 KoSolution Inc., All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChurchDetailController.h"

@interface SettingViewController : UITableViewController <UITextFieldDelegate> {
    
	ChurchDetailController *churchDetailController;
}

@end
