//
//  IDXReader.m
//  ChurchOfGod
//
//  Created by Calvin Ko on 9/4/12.
//
//

#import "SongRecord.h"
#import "IDXReader.h"
#import "PDBReader.h"

@implementation IDXReader 



static NSString *convertText(unsigned char *buf, int length)
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
            if (cref == NULL) {
                cref = CFStringCreateWithBytes (NULL, buf+j, 2, kCFStringEncodingBig5_HKSCS_1999, true);
            }
            if (cref == NULL) {
                cref = CFStringCreateWithBytes (NULL, buf+j, 2, kCFStringEncodingBig5_E, true);
            }
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

- (id) init
{
        
    songIndexArray = [[NSMutableArray alloc] init];
    return self;
}


- (void) readINXFile:(NSString *)inxFileName {
    
    char snum[128], ssize[128], sname[256];
    int index, size;
    int num = 0;
    NSArray *fArray = [inxFileName componentsSeparatedByString:@"."];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[fArray objectAtIndex:0] ofType:[fArray objectAtIndex:1]];
    FILE *fp = fopen([filePath cStringUsingEncoding:NSUTF8StringEncoding], "rb");
    if (fp != NULL) {
        while (fgets(snum, 128, fp) != NULL) {
            SongRecord *rec = [[SongRecord alloc] init];
            index = atoi(snum);
            fgets(ssize, 128, fp);
            size = atoi(ssize);
            fgets(sname, 256, fp);
            rec.title = convertText((unsigned char *) sname, strlen(sname));
            rec.pos = index;
            rec.sizeInBytes = size;
            [songIndexArray  addObject:rec];
            num++;
        }
        numOfSong = num;
    }
    return;
}

    
- (NSInteger) getNumOfSong {
    return numOfSong;
}

- (void) openSongTextFile:(NSString *) songFileName {
    NSArray *fArray = [songFileName componentsSeparatedByString:@"."];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[fArray objectAtIndex:0] ofType:[fArray objectAtIndex:1]];
    songfp = fopen([filePath cStringUsingEncoding:NSUTF8StringEncoding], "rb");
    return;

}

- (NSString *) readSongTextFile:(NSString *)songFileName
{
    NSArray *fArray = [songFileName componentsSeparatedByString:@"."];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[fArray objectAtIndex:0] ofType:[fArray objectAtIndex:1]];
    FILE *fp = fopen([filePath cStringUsingEncoding:NSUTF8StringEncoding], "rb");
    return NULL;
}

- (NSString *) getSongNameAtIndex:(NSInteger) index
{
    SongRecord *srec = [songIndexArray objectAtIndex:index];
    return srec.title;
}

- (NSString *) getSongText:(NSInteger) index

{
    unsigned char buf[512];
    SongRecord *rec = [songIndexArray objectAtIndex:index];
    fseek(songfp, rec.pos, SEEK_SET);
    int nbytes = fread(buf, 1, rec.sizeInBytes , songfp);
    if (nbytes != rec.sizeInBytes) {
        return @"Error";
    } else {
        NSString *str = convertText(buf, nbytes);
        return str;
    }
}

@end
