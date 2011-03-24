//
//  ChurchConfig.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 3/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ChurchConfig : NSObject {
    NSString *name;
    NSString *website;
    NSString *sermon, *msermon;
    NSString *news, *mnews;
    NSString *tools, *mtools;
    NSMutableArray *userArray;
    NSString *cert;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *website;
@property (nonatomic, retain) NSString *sermon;
@property (nonatomic, retain) NSString *msermon;
@property (nonatomic, retain) NSString *news;
@property (nonatomic, retain) NSString *mnews;
@property (nonatomic, retain) NSString *tools;
@property (nonatomic, retain) NSString *mtools;
@property (nonatomic, retain) NSMutableArray  *userArray;
@property (nonatomic, retain) NSString *cert;


@end
