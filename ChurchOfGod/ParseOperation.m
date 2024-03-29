/* 
 Communique - The open church communications iPhone app.
 
 Copyright (C) 2010  Sugar Creek Baptist Church <info at sugarcreek.net> - 
 Rick Russell <rrussell at sugarcreek.net>
 
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License along
 with this program; if not, write to the Free Software Foundation, Inc.,
 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 
 */

#import "ParseOperation.h"
#import "MediaRecord.h"
#import "ChurchOfGodAppDelegate.h"

// string contants found in the RSS feed
static NSString *kLink      = @"link";
static NSString *kAudioLink = @"audioLink";
static NSString *kAudioSize = @"audioFileSize";
static NSString *kAuthor    = @"itunes:author";
static NSString *kVideoLink = @"videoLink";
static NSString *kType      = @"type";
static NSString *kCategory  = @"category";
static NSString *kTitle     = @"title";
static NSString *kImageStr  = @"thumbnail";
static NSString *kDate      = @"pubDate";
static NSString *kDescription = @"description";
static NSString *kItem      = @"item";
static NSString *kContent     = @"content:encoded";
static NSString *kContentURL  = @"contenturl";


@interface ParseOperation ()
@property (nonatomic, assign) id <ParseOperationDelegate> delegate;
@property (nonatomic, retain) NSData *dataToParse;
@property (nonatomic, retain) NSMutableArray *workingArray;
@property (nonatomic, retain) MediaRecord *workingEntry;
@property (nonatomic, retain) NSMutableString *workingPropertyString;
@property (nonatomic, retain) NSArray *elementsToParse;
@property (nonatomic, assign) BOOL storingCharacterData;
@end

@implementation ParseOperation

@synthesize delegate, dataToParse, workingArray, workingEntry, workingPropertyString, elementsToParse, storingCharacterData;

- (id)initWithData:(NSData *)data delegate:(id <ParseOperationDelegate>)theDelegate
{
    self = [super init];
    if (self != nil)
    {
        self.dataToParse = data;
        self.delegate = theDelegate;
        self.elementsToParse = [NSArray arrayWithObjects:kContent, kContentURL, kLink, kType, kTitle, kImageStr, kDate, kDescription, kAudioLink, kCategory, kAudioSize, kAuthor, nil];
    }
    return self;
}

// -------------------------------------------------------------------------------
//	dealloc:
// -------------------------------------------------------------------------------
- (void)dealloc
{
    [dataToParse release];
    [workingEntry release];
    [workingPropertyString release];
    [workingArray release];
	[elementsToParse release];
    
    [super dealloc];
}

// -------------------------------------------------------------------------------
//	main:
//  Given data to parse, use NSXMLParser and process all the feed.
// -------------------------------------------------------------------------------
- (void)main
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	self.workingArray = [NSMutableArray array];
    self.workingPropertyString = [NSMutableString string];
    
    // It's also possible to have NSXMLParser download the data, by passing it a URL, but this is not
	// desirable because it gives less control over the network, particularly in responding to
	// connection errors.
    //
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataToParse];
	[parser setDelegate:self];
    [parser parse];
	
	if (![self isCancelled])
    {
        // notify our AppDelegate that the parsing is complete
        [self.delegate didFinishParsing:self.workingArray];
    }
    
    self.workingArray = nil;
    self.workingPropertyString = nil;
    self.dataToParse = nil;
    
    [parser release];

	[pool release];
}


#pragma mark -
#pragma mark RSS processing

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
                                        namespaceURI:(NSString *)namespaceURI
                                       qualifiedName:(NSString *)qName
                                          attributes:(NSDictionary *)attributeDict
{
    // entry: { id (link), im:name (app name), im:image (variable height) }
    //
    if ([elementName isEqualToString:kItem])
	{
        self.workingEntry = [[[MediaRecord alloc] init] autorelease];
    }
    storingCharacterData = [elementsToParse containsObject:elementName];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
                                      namespaceURI:(NSString *)namespaceURI
                                     qualifiedName:(NSString *)qName
{
    if (self.workingEntry)
	{
        if ([elementName isEqualToString:kItem])
        {
            [self.workingArray addObject:self.workingEntry];  
            self.workingEntry = nil;
        } else {

            if (storingCharacterData)
            {
                NSString *trimmedString = [workingPropertyString stringByTrimmingCharactersInSet:
                                           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [workingPropertyString setString:@""];  // clear the string for next time
                if ([elementName isEqualToString:kLink])
                {
                    self.workingEntry.itemLink = trimmedString;
                }
                else if ([elementName isEqualToString:kType])
                {        
                    self.workingEntry.itemType = trimmedString ;
                }
                else if ([elementName isEqualToString:kTitle])
                {        
                    self.workingEntry.itemTitle = trimmedString;
                }
                else if ([elementName isEqualToString:kAuthor])
                {        
                    self.workingEntry.itemAuthor = trimmedString;
                }
                else if ([elementName isEqualToString:kCategory]) {
                    self.workingEntry.itemCategory = trimmedString;
                }
                else if ([elementName isEqualToString:kImageStr])
                {
                    self.workingEntry.imageURLString = trimmedString;
                }
                else if ([elementName isEqualToString:kDate])
                {
                    self.workingEntry.itemDate = trimmedString;
                }
                else if ([elementName isEqualToString:kDescription])
                {
                    self.workingEntry.itemDescription = trimmedString;
                }
                else if ([elementName isEqualToString:kAudioLink])
                {
                    self.workingEntry.itemAudioURLString = trimmedString;
                }
                else if ([elementName isEqualToString:kAudioSize])
                {
                    self.workingEntry.audioFileSize = [trimmedString integerValue];
                }
                else if ([elementName isEqualToString:kVideoLink])
                {
                    self.workingEntry.itemVideoURLString = trimmedString;
                }
                else if ([elementName isEqualToString:kContent])
                {
                    self.workingEntry.itemContent = trimmedString;
                }
                else if ([elementName isEqualToString:kContentURL])
                {
                    self.workingEntry.itemContentURL = trimmedString;
                }
                
            }
        }
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (storingCharacterData && self.workingEntry)
    {
        [workingPropertyString appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [delegate parseErrorOccurred:parseError];
}

@end
