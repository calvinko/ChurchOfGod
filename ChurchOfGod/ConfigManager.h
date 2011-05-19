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
@class MediaRecord;
@class ChurchofGodAppDelegate;
@class DownloadedMediaRecord;
@interface ConfigManager : NSObject {
    
    
}

+ (NSString *) getUsername;
+ (NSString *) getChurchname;
+ (NSString *) getSermonURL;
+ (NSString *) getNewsURL;
+ (NSArray *) getValidUserList;
+ (NSArray *) getSongBookList;

+ (NSInteger) getNumberofSongBook; 
+ (NSString *) getSongBookFilenameAtIndex:(int)index;
+ (NSString *) getSongBookNameAtIndex:(int)index; 
+ (PDBReader *) getReaderAtIndex:(NSUInteger) index;
+ (NSMutableArray *) getDownloadedMediaArray;
+ (NSArray *) getPlaysArray;


+ (void) addSermonToStore:(MediaRecord *)rec withFileName:(NSString *)fname;

+ (void) setDelegate:(ChurchofGodAppDelegate *) del;
+ (void) setDefaultChurchConfig:(ChurchConfig *)config; 
+ (void) setDefaultIndex:(NSUInteger)index;
+ (void) setUser:(NSString *)user;
+ (NSInteger) getDefaultIndex;
+ (NSMutableArray *) loadConfig;
+ (NSString *) getDocumentPath;

+ (DownloadedMediaRecord *) findDownloadedMediaByName:(NSString *) name;

+ (void) loadMediaList;
+ (bool) saveMediaList;

@end
