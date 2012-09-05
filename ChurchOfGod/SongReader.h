//
//  SongReader.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 9/4/12.
//
//

#import <Foundation/Foundation.h>

@protocol SongReader <NSObject>

- (NSInteger) getNumOfSong;
- (NSString *) readSontTextFile:(NSString *)songFileName;
- (NSString *) getSongText:(NSInteger) index;
- (NSString *) getSongNameAtIndex:(NSInteger) index;

@end


