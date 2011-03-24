//
//  ChurchConfigLoader.h
//  ChurchOfGod
//
//  Created by Calvin Ko on 3/14/11.
//  Copyright 2011 Kos Solution, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChurchConfig.h"



@interface ChurchConfigLoader : NSOperation <NSXMLParserDelegate> {
    
    NSMutableString *workingPropertyString;
    NSMutableArray *records;
    ChurchConfig    *workingEntry;
	
}

@property (nonatomic, retain) NSMutableString *workingPropertyString;
@property (nonatomic, retain) NSMutableArray *records;
@property (nonatomic, retain) ChurchConfig *workingEntry;

+ (ChurchConfig *)getConfigAtIndex:(NSUInteger)index;

@end
