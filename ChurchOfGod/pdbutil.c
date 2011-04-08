//
//  pdbutil.c
//  ChurchOfGod
//
//  Created by Calvin Ko on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "pdbutil.h"

static int cRecords=0;

UInt32 getOffset(FILE *fp, int recnum) {
    UInt32 offset;
    fseek(fp, PDBHDRSIZE+(recnum*PDBRECSIZE), SEEK_SET);
    fread(&offset, 4, 1, fp);
    return offset;
}

int readPDBFile(const char *filename) 
{
    PDBHeader       header;
    HeaderRecord    headerRec;
    int numRecords;
    int numTextRecords;
    int numBookmarkRecords;
    UInt32 offset;
    FILE *fp = fopen(filename, "rb");
    if (fp) {
        fread(&header, sizeof(header), 1, fp);
        numRecords = ntohs(header.recordList.numRecords);
        
        // read header record i.e, record 0
        fread(&offset, 4, 1, fp);
        offset = ntohs(offset);
        fseek( fp, offset, SEEK_SET );
        fread( &headerRec, sizeof(headerRec), 1, fp );
        numTextRecords = headerRec.num_records;
        numBookmarkRecords = numRecords - numTextRecords - 1;

        return 1;
    } else {
        return 0;
    }
};

// max size 4096
void readPDBTextRecord(FILE *fp, unsigned char *buf, int rnum, int size) {
    
    
    
}


void readPDBBookmarkRecord(FILE *fp, int rnum, int size) {
    
    
    
}

