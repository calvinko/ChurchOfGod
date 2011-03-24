//
//  ConfigManager.m
//  ChurchOfGod
//
//  Created by Calvin Ko on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CFNetwork/CFNetwork.h>
#import "ConfigManager.h"
#import "ChurchConfig.h"
#import "ChurchConfigLoader.h"


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

static NSMutableArray *churchArray;


+ (void)initialize 
{
    churchArray = nil;
    
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

+ (NSMutableArray*)loadConfig
{
    if (churchArray == nil) {
        NSURL *url = [NSURL URLWithString:(@"http://bachurch.org/iphone/churchdata.xml")];
        ChurchConfigLoader *loader = [[ChurchConfigLoader alloc] init];
        NSXMLParser *parser = [[[NSXMLParser alloc] initWithContentsOfURL:(url)] autorelease];
        [parser setDelegate:(loader)];
        
        if ([parser parse]) {
            
            churchArray = [NSMutableArray array];
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
@end
