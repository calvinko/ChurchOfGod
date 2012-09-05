//
//  SongRecord.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 9/4/12.
//
//

#import <Foundation/Foundation.h>



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

