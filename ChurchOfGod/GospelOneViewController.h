//
//  GospelOneViewController.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GospelOneViewController : UIViewController <UIScrollViewDelegate>{
    UIPageControl *pageControl;
    UIScrollView  *scrollView;
    NSMutableArray *viewControllers;
    NSArray *contentList;
    bool pageControlUsed;
    
}

@property (nonatomic,retain)  IBOutlet UIPageControl *pageControl;
@property (nonatomic,retain)  IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) NSArray *contentList;
-(IBAction) pageChange; 

- (void)loadScrollViewWithPage:(int)page;

@end
