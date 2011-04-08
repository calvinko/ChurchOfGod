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


typedef struct {
    UInt32  nextRecordListID;
    UInt16  numRecords;
} RecordList;

typedef struct {
    unsigned char   head[72];
    RecordList      recordList;
} PDBHeader;

typedef struct {
    UInt16  version;                /* 1 = plain text, 2 = compressed */
    UInt16  reserved1;
    UInt32  doc_size;               /* in bytes, when uncompressed */
    UInt16  num_records;            /* number of text record */
    UInt16  rec_size;               /* usually RECORD_SIZE_MAX */
    UInt32  vposition;  
} HeaderRecord;

#define PDBHDRSIZE 78
#define PDBRECSIZE 8


@interface PDBReader : NSObject {
    FILE *fp;
    int numRecords;
    int numTextRecords;
    int numBookmarkRecords;
    int totalSize, recSize;
    
}

- initWithFile:(NSString *) fileName;
+ (NSString *)readSongBook:(NSString *) recsourceName;
+ (unsigned char *)readByte;


@end
