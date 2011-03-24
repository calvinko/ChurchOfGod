//
//  ConfigManager.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChurchConfig.h" 


@interface ConfigManager : NSObject {
    
    
}

+ (NSString *) getUsername;
+ (NSString *) getChurchname;
+ (NSString *) getSermonURL;
+ (NSString *) getNewsURL;
+ (NSArray *) getValidUserList;

+ (void) setDefaultChurchConfig:(ChurchConfig *)config; 
+ (void) setDefaultIndex:(NSUInteger)index;
+ (void) setUser:(NSString *)user;
+ (NSInteger) getDefaultIndex;
+ (NSMutableArray *) loadConfig;

@end
