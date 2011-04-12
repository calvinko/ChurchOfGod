//
//  SongTextViewController.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDBReader;
@interface SongTextViewController : UIViewController {

    
    UITextView *songText;
    NSString *text;
    PDBReader  *reader;
    NSRange    range;
}


@property (nonatomic, retain) IBOutlet UITextView *songText;
@property (nonatomic, retain) PDBReader *reader;
@property (nonatomic, assign) NSRange range;
@property (nonatomic, retain) NSString *text;

@end
