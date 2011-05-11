//
//  AudioDownloader.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 4/28/11.
//  Copyright 2011 KoSolution. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <MacTypes.h>

@protocol AudioDownloaderDelegate;
@interface AudioDownloader : NSObject {
    FILE *fp;
    NSString *filePath;
    NSString *fileName;
    NSString *audioURL;
    NSMutableData *dataStore;
    NSURLConnection *netConnection;
    id <AudioDownloaderDelegate> delegate;
    UIProgressView *pview;
    NSInteger fileSize;
    int nbytes;
}

@property (nonatomic, retain) NSMutableData *dataStore;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, retain) NSURLConnection *netConnection;
@property (nonatomic, retain) NSString *audioURL;
@property (nonatomic, retain) id <AudioDownloaderDelegate> delegate;
@property (nonatomic, retain) UIProgressView *pview;
@property (nonatomic) NSInteger fileSize;

- (void) startDownload;
@end

@protocol AudioDownloaderDelegate 

- (void)audioFileDidLoad:(NSString *)fileName;

@end