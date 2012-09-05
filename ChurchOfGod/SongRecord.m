//
//  SongRecord.m
//  ChurchOfGod
//
//  Created by Calvin Ko on 9/4/12.
//
//

#import "SongRecord.h"

@implementation SongRecord


@synthesize title, pos, adjustpos, sizeInBytes;

-(id) initWithName:(NSString *) name
{
    self.title = name;
    return self;
}

@end
