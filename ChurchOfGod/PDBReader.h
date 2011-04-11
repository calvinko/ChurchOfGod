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





@interface PDBReader : NSObject {
    FILE *fp;
    int numRecords;
    int numTextRecords;
    int numBookmarkRecords;
    int totalSize;
    int bmposTable[500];
    int adjustposTable[500];
    NSMutableArray *bookmarkArray;
    NSMutableString *mainText;
}

- (id) init;
- (bool) readFile:(NSString *) fileName ;
- (bool) readPDBHeader;
- (NSInteger) getNumOfBookmark;
- (NSString *) getMainText;
- (NSString *)getBookmarkStringAtIndex:(int) index;
- (int) getBookmarkPositionAtIndex:(int) index ;
- (NSString *)readMainText;
- (NSArray *) readBookmarkRecords;

+ (NSString *)readSongBook:(NSString *) recsourceName;
+ (unsigned char *)readByte;
- (bool) hasOpenedFile;


@end
