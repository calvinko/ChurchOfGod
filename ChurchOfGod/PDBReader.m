//
//  PDBReader.m
//  ChurchOfGod
//
//  Created by Calvin Ko on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PDBReader.h"


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

typedef struct {
    unsigned char name[16];
    UInt32        position;
} BookmarkRecord;

#define PDBHDRSIZE 78
#define PDBRECSIZE 8

UInt32 getRecordOffset(FILE *fp, int recnum) {
       
    UInt32 offset;
    //UInt32 s1 = sizeof(PDBHeader);
    //UInt32 place = sizeof(PDBHeader)+recnum*sizeof(RecordList);
    UInt32 place = PDBHDRSIZE+recnum*8;
    fseek(fp, place, SEEK_SET);
    fread(&offset, 4, 1, fp);
    offset = ntohl(offset);
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
    FILE *fp = fopen(filename, "rb");
    if (fp) {
        fread(&header, 78, 1, fp);
        numRecords = ntohs(header.recordList.numRecords);
        
        // read header record i.e, record 0
        fread(&offset, 4, 1, fp);
        offset = ntohl(offset);
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
            int j=0;
            while (cont) {
                NSString *thisChar;
                CFStringRef cref = CFStringCreateWithBytes (NULL, buf+j, 2, kCFStringEncodingBig5, true);
                if (cref != NULL) {
                    thisChar = cref;
                    [songText appendString:thisChar];
                    j = j+2;
                } else {
                    unsigned char c = buf[j];
                    unsigned char *b1 = &buf[j];
                    if (isascii(c)) {
                        NSString *ch = [[NSString alloc] initWithBytes:b1 length:1 encoding:NSASCIIStringEncoding];
                        [songText appendString:ch];
                    } else {
                        [songText appendString:@"#"];
                    }
                    /*
                    if (c == '\n') {
                        [songText appendString:@"\n"];
                    } else if (c == ' ') {
                        [songText appendString:@" "];
                    } else {
                        [songText appendString:@"#"];
                    }
                     */
                    j=j+1;
                }
                if (j>nbytes-1) cont=FALSE;
            }
        }
        
        // Read Book Mark Record
        return songText;
    } else {
        return NULL;
    }
};

@implementation SongRecord 
@synthesize title, pos, adjustpos, sizeInBytes;

-(id) initWithName:(NSString *) name 
{
    self.title = name;
    return self;
}
                        
@end

@implementation PDBReader

-(id) init 
{
    fp = NULL;
    bookmarkArray = NULL;     
    mainText = NULL; 
    numRecords = 0;
    numBookmarkRecords =0;
    numTextRecords = 0;
    return self;
}

- (bool) readFile:(NSString *) fileName 
{
    NSArray *fArray = [fileName componentsSeparatedByString:@"."];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[fArray objectAtIndex:0] ofType:[fArray objectAtIndex:1]];
    fp = fopen([filePath cStringUsingEncoding:NSUTF8StringEncoding], "rb");
    if (fp) {
        if ([self readPDBHeader])
            return TRUE;
        else 
            return FALSE;
    } else {
        return FALSE;
    }
}

- (bool) hasOpenedFile {
    if (fp != NULL)
        return TRUE;
    else
        return FALSE;
}

- (bool) readPDBHeader 
{
    PDBHeader       header;
    HeaderRecord    headerRec;
    UInt32          offset;
        
    
    fread(&header, sizeof(header), 1, fp);
    numRecords = ntohs(header.recordList.numRecords);
    
    // read header record i.e, record 0
    fread(&offset, 4, 1, fp);
    offset = ntohs(offset);
    fseek( fp, offset, SEEK_SET );
    fread( &headerRec, sizeof(headerRec), 1, fp );
    numTextRecords = ntohs(headerRec.num_records);
    totalSize = htonl(headerRec.doc_size);
    numBookmarkRecords = numRecords - numTextRecords - 1;
    textOffset = getRecordOffset(fp, 1);
    return TRUE;
}

NSString *convertText(unsigned char *buf, int length) 
{
    int j=0;
    NSMutableString *mText = [[NSMutableString alloc] init] ;
    while (j < length-1) {
        unsigned char c = buf[j];
        if (isascii(c)) {
            NSString *ch = [[NSString alloc] initWithBytes:&c length:1 encoding:NSASCIIStringEncoding];
            [mText appendString:ch];
            j++;
        } else {
            NSString *thisChar;
            CFStringRef cref = CFStringCreateWithBytes (NULL, buf+j, 2, kCFStringEncodingBig5, true);
            if (cref != NULL) {
                thisChar = (NSString *) cref;
                [mText appendString:thisChar];
                j = j+2;
            } else {
                NSInteger i = (NSInteger) buf[j];
                [mText appendString:[NSString stringWithFormat:@"%x",i]];
                j++;
            }

        }
    }
    return mText;

}

- (NSArray *) readBookmarkRecords

{
    int i;
    if (bookmarkArray != NULL) return bookmarkArray;
    bookmarkArray = [[NSMutableArray alloc] init ];
    SongRecord *lastRecord = NULL;
    SongRecord *thisRecord = NULL;
    for (i=1;i<=numBookmarkRecords;i++)
    {
        UInt32 offset;
        BookmarkRecord brec;
        thisRecord = [[SongRecord alloc] init];
        
        offset = getRecordOffset(fp, i+numTextRecords);
        fseek(fp, offset, SEEK_SET);
        int nbytes = fread(&brec, 1, sizeof(BookmarkRecord), fp);
        if (nbytes != sizeof(BookmarkRecord)) return NULL;
        
        thisRecord.pos = ntohl(brec.position);
        thisRecord.title = convertText(brec.name, 16);
        if (lastRecord != NULL) {
            lastRecord.sizeInBytes = thisRecord.pos - lastRecord.pos;
        }
        [bookmarkArray addObject:thisRecord];
        lastRecord = thisRecord;
    }
    thisRecord.sizeInBytes = totalSize - thisRecord.pos;
    return bookmarkArray;
} 

- (NSString *)getBookmarkStringAtIndex:(int) index {
    if (bookmarkArray == NULL) 
        [self readBookmarkRecords];
    if (bookmarkArray != NULL) {
        SongRecord *s = [bookmarkArray objectAtIndex:index];
        return s.title;
    } else 
        return nil;
}
  

- (int) getBookmarkPositionAtIndex:(int) index {
    if (bookmarkArray == NULL) 
        [self readBookmarkRecords];
    if (bookmarkArray != NULL) {
        SongRecord *s = [bookmarkArray objectAtIndex:index];
        return s.pos;
    } else 
        return 0;
}
      

- (NSInteger) getNumOfBookmark
{
    return numBookmarkRecords;
}

- (NSString *) getMainText 
{
    if (mainText == NULL) {
        [self readMainText];
    }
    return mainText;
}

- (NSString *) getSongText:(NSInteger) index 
{
    unsigned char buf[2048];
    SongRecord *rec = [bookmarkArray objectAtIndex:index];
    fseek(fp, textOffset + rec.pos, SEEK_SET);
    int nbytes = fread(buf, 1, rec.sizeInBytes , fp);
    if (nbytes != rec.sizeInBytes) {
        return @"Error";
    } else {
        NSString *str = convertText(buf, nbytes);
        return str;
    }
}

- (NSString *)readMainText
{
    int i, bookmarkIndex=0;
    int byteCount = 0;
    int charCount = 0;
    UInt32 offset;
    int recSize;
    unsigned char buf[4096];
    mainText = [[NSMutableString alloc] init];
    if (bookmarkArray == NULL) [self readBookmarkRecords];
    
    // Read Text Record
    for (i=1;i<=numTextRecords;i++) {
        bool cont = TRUE;
        int j=0;
        offset = getRecordOffset(fp, i);
        // compute record Size
        if (i < numRecords-1) { 
            recSize = getRecordOffset(fp, i+1) - offset;
        } else 
            recSize = totalSize - offset;
        
        fseek(fp, offset, SEEK_SET);
        int nbytes = fread(buf, 1, recSize, fp);
       
        while (cont) {
            unsigned char c = buf[j];
            if (isascii(c)) {
                unsigned char *b1 = &buf[j];
                NSString *ch = [[NSString alloc] initWithBytes:b1 length:1 encoding:NSASCIIStringEncoding];
                [mainText appendString:ch];
                j=j+1;
                byteCount++;
                charCount++;
            } else {
                NSString *thisChar;
                CFStringRef cref = CFStringCreateWithBytes (NULL, buf+j, 2, kCFStringEncodingBig5, true);
                if (cref == NULL) {
                    cref = CFStringCreateWithBytes (NULL, buf+j, 2, kCFStringEncodingBig5_HKSCS_1999, true);
                } 
                if (cref != NULL) {
                    thisChar = (NSString *) cref;
                    [mainText appendString:thisChar];
                    j = j+2;
                    byteCount = byteCount+2;
                    charCount = charCount+1;
                } else {
                    [mainText appendString:@"#"];
                    j=j+1;
                    byteCount++;
                    charCount++;
                }
            }
        if (j>nbytes-1) cont=FALSE;
        }
    }
    return mainText;

}

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
