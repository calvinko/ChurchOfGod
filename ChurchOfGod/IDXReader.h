//
//  IDXReader.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 9/4/12.
//
//

#import <Foundation/Foundation.h>
#import "SongReader.h"

@interface IDXReader : NSObject <SongReader> {

    NSMutableArray *songIndexArray;
    int numOfSong;
    char * sbuf;
    FILE *songfp;
}


- (void) readINXFile:(NSString *)inxFileName;
- (id) initWithFiles:(NSString *)txtFile :(NSString *)indexFile;

- (void) openSongTextFile:(NSString *) songFileName;
- (NSString *) readSongTextFile:(NSString *)songFileName;
- (NSString *) getSongText:(NSInteger) index;

- (NSInteger) getNumOfSong;
- (NSString *) getSongNameAtIndex:(NSInteger) index;


@end


