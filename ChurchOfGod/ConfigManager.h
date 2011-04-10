//
//  ConfigManager.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChurchConfig.h" 

@class PDBReader;
@interface ConfigManager : NSObject {
    
    
}

+ (NSString *) getUsername;
+ (NSString *) getChurchname;
+ (NSString *) getSermonURL;
+ (NSString *) getNewsURL;
+ (NSArray *) getValidUserList;
+ (NSArray *) getSongBookList;

+ (NSArray *) getSongBookList; 
+ (NSInteger) getNumberofSongBook; 
+ (NSString *) getSongBookFilenameAtIndex:(int)index;
+ (NSString *) getSongBookNameAtIndex:(int)index; 
+ (NSArray *) getSongBookNameList;
+ (PDBReader *) getReaderAtIndex:(NSUInteger) index;

+ (void) setDefaultChurchConfig:(ChurchConfig *)config; 
+ (void) setDefaultIndex:(NSUInteger)index;
+ (void) setUser:(NSString *)user;
+ (NSInteger) getDefaultIndex;
+ (NSMutableArray *) loadConfig;

@end
