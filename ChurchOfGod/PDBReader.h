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
#import "SongReader.h"


@interface PDBReader : NSObject <SongReader> {
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
- (NSInteger) getNumOfSong;
- (NSString *) getMainText;
- (NSString *) getSongText:(NSInteger) index; 

- (NSString *) getSongNameAtIndex:(NSInteger) index;
- (int) getBookmarkPositionAtIndex:(int) index ;
- (NSString *)readMainText;
- (NSArray *) readBookmarkRecords;

+ (NSString *)readSongBook:(NSString *) recsourceName;
+ (unsigned char *)readByte;
- (bool) hasOpenedFile;


@end
