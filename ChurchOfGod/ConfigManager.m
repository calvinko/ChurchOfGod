//
//  ConfigManager.m
//  ChurchOfGod
//
//  Created by Calvin Ko on 3/16/11.
//  Copyright 2011 KoSolution.NET All rights reserved.
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
#import "IDXReader.h"
#import "Play.h"
#import "Quotation.h"


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
static bool kChurchSupportUserAccount = FALSE;


static NSString *kTool = @"tool";
static NSString *kMTool = @"mtool";

//static NSString *kCert = @"cert";

static ChurchofGodAppDelegate *delegate;
static NSMutableArray *churchArray;
static NSDictionary *songBookList;
static NSMutableDictionary *readerDict;
static NSArray *booklist;
static NSMutableArray *downloadedMediaArray;
static NSMutableArray *playsArray;
static bool churchUserHasChanged;

// We use the NSUserDefault database to store all the default

+ (void)initialize 
{
    churchUserHasChanged = false;
    churchArray = nil;
    songBookList = nil;
    booklist = nil;
    downloadedMediaArray = nil;
    playsArray = nil;
    readerDict = [[[NSMutableDictionary alloc] initWithCapacity:15] retain];
        
    NSString *testValue = [[NSUserDefaults standardUserDefaults] stringForKey:kChurchName];
	if (testValue == nil)
	{
		NSString *churchNameDefault = @"Church of God in Oakland";
        NSString *churchURL = @"http://www.bachurch.org";
		NSString *sermonurl = @"http://bachurch.org/iphone/psermonlist.xml";
        NSString *msermonurl = @"http://bachurch.org/iphone/sermonlist.xml";
		NSString *newsurl = @"http://bachurch.org/iphone/pnews.xml";
        NSString *mnewsurl = @"http://bachurch.org/iphone/news.xml";
        NSString *toolurl = @"http://bachurch.org/iphone/tool.xml";
        NSArray *userlist = [[NSArray alloc] init];
		NSString *username = @"guest";
        
        // since no default values have been set (i.e. no preferences file created), create it here		
		NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                     churchNameDefault, kChurchName,
                                     churchURL,         kChurchURL,
                                     FALSE,             kChurchSupportUserAccount,
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

+ (DownloadViewController *) getDownloadController {
    return delegate.downloadViewController;
}

+ (void) loadSongBookList {
    NSString *songlistPath = [[NSBundle mainBundle] pathForResource:@"songbooklist" ofType:@"plist"];
    songBookList = [[NSDictionary dictionaryWithContentsOfFile:songlistPath] retain];
}

+ (NSMutableArray*)getChurchArray
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

+ (void) releaseChurchArray
{
    [churchArray release];
    churchArray = nil;
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
    return [songBookList objectForKey:@"songbooks"];
}

+  (NSInteger) getNumberofSongBook {
    if (songBookList == nil) [self loadSongBookList];
    NSArray *a = [songBookList objectForKey:@"songbooks"];
    return [a count];
}

+ (NSString *) getSongBookTypeAtIndex:(int)index {
    if (songBookList == nil) [self loadSongBookList];
    NSArray *bookArray = [songBookList objectForKey:@"songbooks"];
    return [[bookArray objectAtIndex:index] objectAtIndex:0];
}

+ (NSString *) getSongBookNameAtIndex:(int)index {
    if (songBookList == nil) [self loadSongBookList];
    NSArray *bookArray = [songBookList objectForKey:@"songbooks"];
    return [[bookArray objectAtIndex:index] objectAtIndex:1];
}

+ (NSString *) getSongBookFilenameAtIndex:(int)index {
    if (songBookList == nil) [self loadSongBookList];
    NSArray *bookArray = [songBookList objectForKey:@"songbooks"];
    return [[bookArray objectAtIndex:index] objectAtIndex:2];
}

+ (NSString *) getSongBookIndexFilenameAtIndex:(NSUInteger) index
{
    if (songBookList == nil) [self loadSongBookList];
    NSArray *bookArray = [songBookList objectForKey:@"songbooks"];
    return [[bookArray objectAtIndex:index] objectAtIndex:3];
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
    NSString *uname = [[[NSString alloc] initWithString:[username lowercaseString]] autorelease];
    [[NSUserDefaults standardUserDefaults] setValue:uname forKey:kUserName];
    churchUserHasChanged = TRUE;
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (bool) getUserChangeStatus {
    return churchUserHasChanged;
}

+ (id <SongReader>) getReaderAtIndex:(NSUInteger) index
{
    NSString *type = [ConfigManager getSongBookTypeAtIndex:index];
    if ([type isEqualToString:@"pdb"]) {
        NSString *bookName = [ConfigManager getSongBookNameAtIndex:index];
        PDBReader *r = [readerDict objectForKey:bookName];
        if (r == nil) {
            r = [[PDBReader alloc] init];
            [r readFile:[ConfigManager getSongBookFilenameAtIndex:index]];
            [readerDict setObject:r forKey:bookName];
        }
        return r;
    } else {
        NSString *bookName = [ConfigManager getSongBookNameAtIndex:index];
        IDXReader *r = [readerDict objectForKey:bookName];
        if (r == nil) {
            r = [[IDXReader alloc] init];
            [r readINXFile:[ConfigManager getSongBookIndexFilenameAtIndex:index]];
            [r openSongTextFile:[ConfigManager getSongBookFilenameAtIndex:index]];
        }
        return r;
    }
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
    
    if (downloadedMediaArray != nil) {
        NSString *pathStr = [ConfigManager getDocumentPath];
        NSString *filePath = [pathStr stringByAppendingPathComponent:@"mediaList.plist"];
        NSArray *a = [ConfigManager convertRecordArray:downloadedMediaArray];
        bool result = [a writeToFile:filePath atomically:YES];    
        return result;
    } else {
        return TRUE;
    }
}

+ (NSInteger) getDurationOfFile:(NSString *) filePath {
    
    NSURL *afUrl = [NSURL fileURLWithPath:filePath];
    AudioFileID fileID;
    OSStatus result = AudioFileOpenURL((CFURLRef)afUrl, kAudioFileReadPermission, 0, &fileID);
    UInt32 bitRate = 0;
    UInt32 thePropSize = sizeof(UInt32);
    UInt64 byteCount = 0;
    
    result = AudioFileGetProperty(fileID, kAudioFilePropertyBitRate, &thePropSize, &bitRate);
    thePropSize = sizeof(UInt64);
    result = AudioFileGetProperty(fileID, kAudioFilePropertyAudioDataByteCount, &thePropSize, &byteCount);
    
    AudioFileClose(fileID);
    return (byteCount * 8) / bitRate;
}


+ (void) addSermonToStore:(MediaRecord *)rec withFileName:(NSString *)fname {
    if (downloadedMediaArray == nil) {
        [ConfigManager loadMediaList];
    }
    DownloadedMediaRecord *drec = [[DownloadedMediaRecord alloc] init];
    drec.fileName = fname;
    drec.itemTitle = rec.itemTitle;
    drec.itemAuthor = rec.itemAuthor;
    drec.itemDate = rec.itemDate;
    drec.itemType = rec.itemType;
    drec.duration = [ConfigManager getDurationOfFile:[[ConfigManager getDocumentPath] stringByAppendingPathComponent:fname]];
    [downloadedMediaArray addObject:drec];
    [delegate.downloadViewController.tableView reloadData];
}


+ (void) setUpPlaysArray {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"RomanRoadText" withExtension:@"plist"];
    NSArray *playDictionariesArray = [[NSArray alloc ] initWithContentsOfURL:url];
    playsArray = [[NSMutableArray alloc] initWithCapacity:[playDictionariesArray count]];
    
    
    for (NSDictionary *playDictionary in playDictionariesArray) {
        
        Play *play = [[Play alloc] init];
        play.name = [playDictionary objectForKey:@"playName"];
        
        NSArray *quotationDictionaries = [playDictionary objectForKey:@"quotations"];
        NSMutableArray *quotations = [NSMutableArray arrayWithCapacity:[quotationDictionaries count]];
        
        for (NSDictionary *quotationDictionary in quotationDictionaries) {
            
            Quotation *quotation = [[Quotation alloc] init];
            [quotation setValuesForKeysWithDictionary:quotationDictionary];
            
            [quotations addObject:quotation];
            [quotation release];
        }
        play.quotations = quotations;
        
        [playsArray addObject:play];
        [play release];
    }
    [playDictionariesArray release];
}

+ (NSArray *) getPlaysArray {
    if (playsArray == nil) {
        [ConfigManager setUpPlaysArray];
    }
    return playsArray;
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

