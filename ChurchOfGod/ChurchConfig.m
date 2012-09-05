//
//  ChurchConfig.m
//  ChurchOfGod
//
//  Created by Calvin Ko on 3/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChurchConfig.h"


@implementation ChurchConfig

@synthesize name;
@synthesize news, mnews;
@synthesize tools, mtools;
@synthesize sermon, msermon;
@synthesize userArray;
@synthesize website, cert, supportUserAccount;


- (id)init {
    self.name = nil;
    self.userArray = [NSMutableArray array];
    self.supportUserAccount = FALSE;
    return self;
}

- (void)dealloc
{
    [super dealloc];
}


@end
