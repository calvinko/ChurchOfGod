//
//  PDBReader.m
//  ChurchOfGod
//
//  Created by Calvin Ko on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PDBReader.h"


UInt32 getRecordOffset(FILE *fp, int recnum) {
    UInt32 offset;
    UInt32 place = sizeof(PDBHeader)+recnum*sizeof(RecordList);
    fseek(fp, place, SEEK_SET);
    fread(&offset, 4, 1, fp);
    offset = ntohs(offset);
    return offset;
}

NSString *readPDBFile(const char *filename) 
{
    PDBHeader       header;
    HeaderRecord    headerRec;
    int numRecords;
    int numTextRecords;
    int numBookmarkRecords;
    UInt32 offset;
    unsigned char buf[4096];
    int totalSize, recSize;
    NSMutableData *songData = [[NSMutableData alloc] init];
    FILE *fp = fopen(filename, "rb");
    if (fp) {
        fread(&header, sizeof(header), 1, fp);
        numRecords = ntohs(header.recordList.numRecords);
        
        // read header record i.e, record 0
        fread(&offset, 4, 1, fp);
        offset = ntohs(offset);
        fseek( fp, offset, SEEK_SET );
        fread( &headerRec, sizeof(headerRec), 1, fp );
        numTextRecords = ntohs(headerRec.num_records);
        totalSize = headerRec.doc_size;
        numBookmarkRecords = numRecords - numTextRecords - 1;
        
        int i;
        // Read Text Record
        NSMutableString *songText = [[NSMutableString alloc] init];
        for (i=1;i<=numTextRecords;i++) {
            offset = getRecordOffset(fp, i);
            // compute record Size
            if (i < numRecords-1) { 
                recSize = getRecordOffset(fp, i+1) - offset;
            } else 
                recSize = totalSize - offset;
            fseek(fp, offset, SEEK_SET);
            int nbytes = fread(buf, 1, recSize, fp);
            bool cont = TRUE;
           
            while (cont) {
                NSString *thisChar;
                CFStringRef cref = CFStringCreateWithBytes (NULL, buf+i, 2, kCFStringEncodingBig5, true);
                if (cref != NULL) {
                    thisChar = cref;
                    [songText appendString:thisChar];
                    i = i+2;
                } else {
                    [songText appendString:@"#"];
                    i=i+1;
                }
                if (i>nbytes-1) cont=FALSE;
            }
        }
        
        // Read Book Mark Record
        return songText;
    } else {
        return NULL;
    }
};


@implementation PDBReader

+ (NSString *)readSongBook:(NSString *) resourceName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:resourceName ofType:@"pdb"];
    return readPDBFile([filePath cStringUsingEncoding:NSUTF8StringEncoding]);
   
};

+ (unsigned char *)readByte
{
    unsigned char *buf = malloc(10000);
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"song2" ofType:@"txt"];
    FILE *fp = fopen([filePath cStringUsingEncoding:NSUTF8StringEncoding], "rb");
    int b = fread(buf, 1, 9000, fp);
    return b>0 ? buf : NULL;
}

@end
