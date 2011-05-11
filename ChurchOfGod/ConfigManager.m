//
//  ConfigManager.m
//  ChurchOfGod
//
//  Created by Calvin Ko on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CFNetwork/CFNetwork.h>
#import "ChurchofGodAppDelegate.h"
#import "ConfigManager.h"
#import "ChurchConfig.h"
#import "ChurchConfigLoader.h"
#import "MediaRecord.h"
#import "DownloadedMediaRecord.h"
#import "DownloadViewController.h"
#import "PDBReader.h"


@implementation ConfigManager

static NSString *kChurchIndex = @"churchindex";
static NSString *kChurchName = @"churchname";
static NSString *kChurchURL = @"churchurl";
static NSString *kUserList = @"userlist";
static NSString *kUserName = @"username";
static NSString *kSermon = @"sermon";
static NSString *kMSermon = @"membersermon";
static NSString *kNews = @"news";
static NSString *kMNews = @"membernews";
//static NSString *kCert = @"cert";
static NSString *kTool = @"tool";
static NSString *kMTool = @"mtool";

static ChurchofGodAppDelegate *delegate;
static NSArray *readerArray;
static NSMutableArray *churchArray;
static NSDictionary *songBookList;
static NSMutableDictionary *readerDict;
static NSArray *booklist;
static NSMutableArray *downloadedMediaArray;


+ (void)initialize 
{
    churchArray = nil;
    songBookList = nil;
    booklist = nil;
    downloadedMediaArray = nil;
    readerDict = [[[NSMutableDictionary alloc] initWithCapacity:5] retain];
    readerArray = [[NSArray arrayWithObjects:
                    [[[PDBReader alloc] init] retain], 
                    [[[PDBReader alloc] init] retain], 
                    [[[PDBReader alloc] init] retain], 
                    [[[PDBReader alloc] init] retain], 
                    [[[PDBReader alloc] init] retain], 
                    [[[PDBReader alloc] init] retain], 
                    [[[PDBReader alloc] init] retain], 
                    [[[PDBReader alloc] init] retain], 
                    [[[PDBReader alloc] init] retain], 
                    [[[PDBReader alloc] init] retain], nil] retain];
    
    NSString *testValue = [[NSUserDefaults standardUserDefaults] stringForKey:kChurchName];
	if (testValue == nil)
	{
		// no default values have been set, create them here based on what's in our Settings bundle info
		//NSString *pathStr = [[NSBundle mainBundle] bundlePath];
		//NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
		//NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
        
		//NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
		//NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
        
		NSString *churchNameDefault = @"Church of God in Oakland";
        NSString *churchURL = @"http://www.bachurch.org";
		NSString *sermonurl = @"http://bachurch.org/iphone/sermonlist.xml";
        NSString *msermonurl = @"http://bachurch.org/iphone/sermonlist.xml";
		NSString *newsurl = @"http://bachurch.org/iphone/news.xml";
        NSString *mnewsurl = @"http://bachurch.org/iphone/news.xml";
        NSString *toolurl = @"http://bachurch.org/iphone/tool.xml";
        //NSArray  *userlist = [NSArray arrayWithObjects:@"oakbs", @"oakadmin", nil]; 
        NSArray *userlist = [[NSArray alloc] init];
		NSString *username = @"guest";
        
        // since no default values have been set (i.e. no preferences file created), create it here		
		NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                     churchNameDefault, kChurchName,
                                     churchURL,         kChurchURL,
                                     sermonurl,         kSermon,
                                     msermonurl,        kMSermon,
                                     newsurl,           kNews,
                                     mnewsurl,          kMNews,
                                     userlist,          kUserList,
                                     username,          kUserName,
                                     toolurl,           kTool,
                                     0,                 kChurchIndex,
                                     nil];
        
		[[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
}

+ (void) setDelegate:(ChurchofGodAppDelegate *) del {
    delegate = del;
    return;
}

+ (void) loadSongBookList {
    NSString *songlistPath = [[NSBundle mainBundle] pathForResource:@"songbooklist" ofType:@"plist"];
    songBookList = [[NSDictionary dictionaryWithContentsOfFile:songlistPath] retain];
}

+ (NSMutableArray*)loadConfig
{
    if (churchArray == nil) {
        NSURL *url = [NSURL URLWithString:(@"http://bachurch.org/iphone/churchdata.xml")];
        ChurchConfigLoader *loader = [[ChurchConfigLoader alloc] init];
        NSXMLParser *parser = [[[NSXMLParser alloc] initWithContentsOfURL:(url)] autorelease];
        [parser setDelegate:(loader)];
        
        if ([parser parse]) {
            
            churchArray = [[NSMutableArray array] retain];
            [churchArray addObjectsFromArray:(loader.records)];   
            
        } else {
            //NSError *e = [parser parserError];
            //[parser release];
            // show error window
        }
        [loader release];
    } 
    return churchArray;
}

+ (NSString*) getUsername {
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUserName];
}

+ (NSString*) getChurchname {
    return [[NSUserDefaults standardUserDefaults] stringForKey:kChurchName];
}

+ (NSString*) getSermonURL {
    
    NSArray *userlist = [[NSUserDefaults standardUserDefaults] arrayForKey:kUserList];
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:kUserName];
    if ([userlist containsObject:username]) {
        return [[NSUserDefaults standardUserDefaults] stringForKey:kMSermon];
    } else {
        return [[NSUserDefaults standardUserDefaults] stringForKey:kSermon];
    }
}

+ (NSString*) getNewsURL 
{
    
    NSArray *userlist = [[NSUserDefaults standardUserDefaults] arrayForKey:kUserList];
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:kUserName];
    if ([userlist containsObject:username]) {
        return [[NSUserDefaults standardUserDefaults] stringForKey:kMNews];
    } else {
        return [[NSUserDefaults standardUserDefaults] stringForKey:kNews];
    }

}

+ (NSArray *) getSongBookList {
    if (songBookList == nil) [self loadSongBookList];
    //return [[NSUserDefaults standardUserDefaults] arrayForKey:kSongBookList];
    return [songBookList objectForKey:@"songbooks"];
}

+  (NSInteger) getNumberofSongBook {
    if (songBookList == nil) [self loadSongBookList];
    NSArray *a = [songBookList objectForKey:@"songbooks"];
    return [a count];
}

+ (NSString *) getSongBookFilenameAtIndex:(int)index {
    if (songBookList == nil) [self loadSongBookList];
    NSArray *bookArray = [songBookList objectForKey:@"songbooks"];
    return [[bookArray objectAtIndex:index] objectAtIndex:1];
}

+ (NSString *) getSongBookNameAtIndex:(int)index {
    if (songBookList == nil) [self loadSongBookList];
    NSArray *bookArray = [songBookList objectForKey:@"songbooks"];
    return [[bookArray objectAtIndex:index] objectAtIndex:0];
}

+ (NSArray*) getValidUserList
{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:kUserList];
}

+ (NSInteger) getDefaultIndex 
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kChurchIndex];
            
}
+ (void) setDefaultIndex:(NSUInteger)index
{
 
    [[NSUserDefaults standardUserDefaults]  setInteger:index forKey:kChurchIndex];
    [ConfigManager setDefaultChurchConfig:[churchArray objectAtIndex:index]];
}

+ (void) setDefaultChurchConfig:(ChurchConfig *)config 
{
    [[NSUserDefaults standardUserDefaults] setValue:config.name     forKey:kChurchName];
    [[NSUserDefaults standardUserDefaults] setValue:config.website  forKey:kChurchURL];
    [[NSUserDefaults standardUserDefaults] setValue:config.sermon   forKey:kSermon];
    [[NSUserDefaults standardUserDefaults] setValue:config.msermon  forKey:kMSermon];
    [[NSUserDefaults standardUserDefaults] setValue:config.news     forKey:kNews];
    [[NSUserDefaults standardUserDefaults] setValue:config.mnews    forKey:kMNews];
    [[NSUserDefaults standardUserDefaults] setValue:config.tools    forKey:kTool];
    [[NSUserDefaults standardUserDefaults] setValue:config.mtools   forKey:kMTool];
    [[NSUserDefaults standardUserDefaults] setValue:config.userArray forKey:kUserList];
}

+ (void) setUser:(NSString*)username
{
    [[NSUserDefaults standardUserDefaults] setValue:username forKey:kUserName];
}

+ (PDBReader *) getReaderAtIndex:(NSUInteger) index 
{
    NSString *bookName = [ConfigManager getSongBookNameAtIndex:index];
    PDBReader *r = [readerDict objectForKey:bookName];
    if (r == nil) {
        r = [[PDBReader alloc] init];
        [r readFile:[ConfigManager getSongBookFilenameAtIndex:index]];
        [readerDict setObject:r forKey:bookName];
    }
    return r;
}

+ (NSMutableArray *) getDownloadedMediaArray 
{
    if (downloadedMediaArray == nil) {
        [ConfigManager loadMediaList];
    }
    return downloadedMediaArray;
}

+ (NSString *) getDocumentPath 
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}


+ (DownloadedMediaRecord *) findDownloadedMediaByName:(NSString *) name {
    if (downloadedMediaArray == nil) {
        [ConfigManager loadMediaList];
    }
    for (DownloadedMediaRecord *rec in downloadedMediaArray){
        if ([rec.fileName isEqualToString:name]) {
            return rec;
        }
    }
    return nil;
}

+(NSArray *) convertRecordArray:(NSArray *) array 
{
    NSMutableArray *parray = [[[NSMutableArray alloc] initWithCapacity:[array count]] autorelease];
    for (DownloadedMediaRecord *rec in array) {
        [parray addObject:[rec convertToPropertyList]];
    }
    return parray;
}

+ (void) loadMediaList {
    
    NSString *pathStr = [self getDocumentPath];
    NSString *filePath = [pathStr stringByAppendingPathComponent:@"mediaList.plist"];
    NSArray *tarray = [NSArray arrayWithContentsOfFile:filePath];
    if (tarray== nil) {
        downloadedMediaArray = [[[NSMutableArray alloc] init] retain];
    } else {
        if (downloadedMediaArray != nil) {
            [downloadedMediaArray release];
        }
        downloadedMediaArray = [[NSMutableArray alloc] init];
        for (NSArray *arec in tarray) {
            [downloadedMediaArray addObject:[[DownloadedMediaRecord alloc] initWithArray:arec]];
        }
    }
}


+ (bool) saveMediaList {
    
    NSString *pathStr = [self getDocumentPath];
    NSString *filePath = [pathStr stringByAppendingPathComponent:@"mediaList.plist"];
    NSArray *a = [ConfigManager convertRecordArray:downloadedMediaArray];
    bool result = [a writeToFile:filePath atomically:YES];    
    return result;
}

+ (void) addSermonToStore:(MediaRecord *)rec withFileName:(NSString *)fname {
    if (downloadedMediaArray == nil) {
        [ConfigManager loadMediaList];
    }
    DownloadedMediaRecord *drec = [[DownloadedMediaRecord alloc] init];
    drec.fileName = fname;
    drec.itemTitle = rec.itemTitle;
    drec.itemType = rec.itemType;
    drec.itemDescription = rec.itemDescription;
    [downloadedMediaArray addObject:drec];
    [delegate.downloadViewController.tableView reloadData];
}

/*
+ (void) saveLibrary {
    NSDictionary *libraryDict;
    NSString *pathStr = [[NSBundle mainBundle] bundlePath];
    NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Library.bundle"];
    NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"local.plist"];
    [libraryDict writeToFile:finalPath atomically:YES];
}
*/

@end

