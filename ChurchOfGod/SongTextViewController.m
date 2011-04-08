//
//  SongTextViewController.m
//  ChurchOfGod
//
//  Created by Calvin Ko on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SongTextViewController.h"
#include "PDBReader.h"

@implementation SongTextViewController

@synthesize songText, nameLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //NSRange range;
    //range.location = 3000;
    //range.length = 2;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"song2" ofType:@"txt"];
    
    //NSString *fileContents = [NSString stringWithContentsOfFile:filePath usedEncoding:&enstr error:&nerror];
    
    /*
    NSMutableString *sText = [[NSMutableString alloc] init];
    NSString *thisChar;
    unsigned char *buf = [PDBReader readByte];
    int i=0;
    bool cont = TRUE;
    char strbuf[128];
    while (cont) {
        CFStringRef cref = CFStringCreateWithBytes (NULL, buf+i, 2, kCFStringEncodingBig5, true);
        if (cref != NULL) {
            //CFStringGetCString(cref, strbuf, 100, kCFStringEncodingUTF8);
            //strbuf[2] = '\x0';
            //thisChar = [NSString stringWithCString:strbuf encoding:NSUTF8StringEncoding];
            thisChar = cref;
            [sText appendString:thisChar];
            i = i+2;
        } else {
            [sText appendString:@"#"];
            i=i+1;
        }
        if (i>200) cont=FALSE;
    }
    */
    
    NSString *sText = [PDBReader readSongBook:@"Family1"];
    self.songText.text = sText;
    
    //[self.songText scrollRangeToVisible:range];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
