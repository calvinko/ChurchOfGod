//
//  ChurchConfigLoader.m
//  ChurchOfGod
//
//  Created by Calvin Ko on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CFNetwork/CFNetwork.h>
#import "ChurchConfigLoader.h"

@implementation ChurchConfigLoader

@synthesize records, workingEntry, workingPropertyString;

// string contants found in the RSS feed
static NSString *tagWebsite = @"website";
//static NSString *tagCert     = @"cert";
static NSString *tagChurch = @"church";
static NSString *tagName = @"name";
static NSString *tagNew = @"news";
static NSString *tagMSermon = @"msermon";
static NSString *tagMNew = @"mnews";
static NSString *tagTool = @"tool";
static NSString *tagMTool = @"mtool";
static NSString *tagSermon = @"sermon";
static NSString *tagUser = @"user";
static NSMutableString *parseErrorDescription;

static NSMutableArray *churchArray = nil;

+ (void)initialize {
    
    parseErrorDescription = [NSMutableString string];

}

- (id)init
{
	[super init];
	self.records = [NSMutableArray array];
    self.workingPropertyString = [NSMutableString string];
	return self;
}	

+ (ChurchConfig *)getConfigAtIndex:(NSUInteger)index
{
    ChurchConfig *c = (ChurchConfig *) [churchArray objectAtIndex:index];
    return c;
}

+ (NSString*) getError {
    return parseErrorDescription;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
                namespaceURI:(NSString *)namespaceURI
                qualifiedName:(NSString *)qName
                attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:tagChurch])
	{
        self.workingEntry = [[[ChurchConfig alloc] init] autorelease];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if (self.workingEntry)
	{
        if ([elementName isEqualToString:tagChurch]) {
            [self.records addObject:self.workingEntry];  
            self.workingEntry = nil;
        } else {
            if (self.workingEntry != nil)
            {
                NSString *trimmedString = [workingPropertyString stringByTrimmingCharactersInSet:
                                           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                // clear the string for next tag
                [workingPropertyString setString:@""];
                if ([elementName isEqualToString:tagWebsite])
                {
                    self.workingEntry.website = trimmedString;
                }
                else if ([elementName isEqualToString:tagName])
                {        
                    self.workingEntry.name = trimmedString;
                }
                else if ([elementName isEqualToString:tagSermon]) 
                {
                    self.workingEntry.sermon = trimmedString;
                }  
                else if ([elementName isEqualToString:tagMSermon]) 
                {
                    self.workingEntry.msermon = trimmedString;
                } 
                else if ([elementName isEqualToString:tagNew]) 
                {
                    self.workingEntry.news = trimmedString;
                } 
                else if ([elementName isEqualToString:tagMNew]) 
                {
                    self.workingEntry.mnews = trimmedString;
                } 
                else if ([elementName isEqualToString:tagTool]) 
                {
                    self.workingEntry.tools = trimmedString;
                } 
                else if ([elementName isEqualToString:tagUser]) 
                {
                    [self.workingEntry.userArray addObject:trimmedString];
                }  
            }
        }
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.workingEntry)
    {
        [workingPropertyString appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validError 
{
//    NSString *x = @"Error";
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
  //  NSString *y = @"Error";
}

- (void)handleError:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Load Church Config"
														message:errorMessage
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void)dealloc
{
    [super dealloc];
    [workingPropertyString release];
    [records release];
    
}


@end
