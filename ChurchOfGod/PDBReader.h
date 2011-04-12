//
//  PDBReader.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <MacTypes.h>



@interface SongRecord : NSObject {
    NSString    *title;
    NSInteger   pos;
    NSInteger   adjustPos;
    NSUInteger  sizeInBytes;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic) NSInteger pos;
@property (nonatomic) NSInteger adjustpos;
@property (nonatomic) NSUInteger sizeInBytes;

@end


@interface PDBReader : NSObject {
    FILE *fp;
    int textOffset;
    int numRecords;
    int numTextRecords;
    int numBookmarkRecords;
    int totalSize;
    //int bmposTable[300];
    //int adjustposTable[300];
    NSMutableArray *bookmarkArray;
    NSMutableString *mainText;
}

- (id) init;
- (bool) readFile:(NSString *) fileName ;
- (bool) readPDBHeader;
- (NSInteger) getNumOfBookmark;
- (NSString *) getMainText;
- (NSString *) getSongText:(NSInteger) index; 
- (NSString *)getBookmarkStringAtIndex:(int) index;
- (int) getBookmarkPositionAtIndex:(int) index ;
- (NSString *)readMainText;
- (NSArray *) readBookmarkRecords;

+ (NSString *)readSongBook:(NSString *) recsourceName;
+ (unsigned char *)readByte;
- (bool) hasOpenedFile;


@end
