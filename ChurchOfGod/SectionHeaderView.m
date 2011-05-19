//
//  SectionHeaderView.m
//  ChurchOfGod
//
//  Created by Calvin Ko on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "SectionHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SectionHeaderView


@synthesize titleLabel, disclosureButton, delegate, section;


+ (Class)layerClass {
    
    return [CAGradientLayer class];
}


-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber delegate:(id <SectionHeaderViewDelegate>)aDelegate {
    
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        
        // Set up the tap gesture recognizer.
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
        [self addGestureRecognizer:tapGesture];
        [tapGesture release];
        
        delegate = aDelegate;        
        self.userInteractionEnabled = YES;
        
        
        // Create and configure the title label.
        section = sectionNumber;
        CGRect titleLabelFrame = self.bounds;
        titleLabelFrame.origin.x += 35.0;
        titleLabelFrame.size.width -= 35.0;
        CGRectInset(titleLabelFrame, 0.0, 5.0);
        titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        titleLabel.text = title;
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];
        
        
        // Create and configure the disclosure button.
        disclosureButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        disclosureButton.frame = CGRectMake(0.0, 5.0, 35.0, 35.0);
        [disclosureButton setImage:[UIImage imageNamed:@"carat.png"] forState:UIControlStateNormal];
        [disclosureButton setImage:[UIImage imageNamed:@"carat-open.png"] forState:UIControlStateSelected];
        [disclosureButton addTarget:self action:@selector(toggleOpen:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:disclosureButton];
        
        // Set the colors for the gradient layer.
        static NSMutableArray *colors = nil;
        if (colors == nil) {
            colors = [[NSMutableArray alloc] initWithCapacity:3];
            UIColor *color = nil;
            color = [UIColor colorWithRed:0.90 green:0.70 blue:0.30 alpha:1.0];
            [colors addObject:(id)[color CGColor]];
            color = [UIColor colorWithRed:0.51 green:0.41 blue:0.15 alpha:1.0];
            [colors addObject:(id)[color CGColor]];
            color = [UIColor colorWithRed:0.41 green:0.31 blue:0.10 alpha:1.0];
            [colors addObject:(id)[color CGColor]];
        }
        [(CAGradientLayer *)self.layer setColors:colors];
        [(CAGradientLayer *)self.layer setLocations:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.65], [NSNumber numberWithFloat:1.0], nil]];
        
    }
    
    return self;
}


-(IBAction)toggleOpen:(id)sender {
    
    [self toggleOpenWithUserAction:YES];
}


-(void)toggleOpenWithUserAction:(BOOL)userAction {
    
    // Toggle the disclosure button state.
    disclosureButton.selected = !disclosureButton.selected;
    
    // If this was a user action, send the delegate the appropriate message.
    if (userAction) {
        if (disclosureButton.selected) {
            if ([delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [delegate sectionHeaderView:self sectionOpened:section];
            }
        }
        else {
            if ([delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                [delegate sectionHeaderView:self sectionClosed:section];
            }
        }
    }
}


- (void)dealloc {
    
    [titleLabel release];
    [disclosureButton release];
    [super dealloc];
}


@end
