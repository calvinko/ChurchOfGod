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

#import "IconDownloader.h"
#import "MediaRecord.h"

#define kIconHeight 180
#define kIconWidth 360

#define kIconThumbHeight 48
#define kIconThumbWidth 72



@implementation IconDownloader

@synthesize mediaRecord;
@synthesize indexPathInTableView;
@synthesize delegate;
@synthesize activeDownload;
@synthesize imageConnection;

static NSMutableDictionary *imageCache; 

+ (void) initialize {
    
    imageCache = [[NSMutableDictionary alloc] init]; 
}

+ (bool) loadImageFromCache:(NSString *) imageURLString toRecord:(MediaRecord *)rec {
    NSArray *images = [imageCache objectForKey:imageURLString];
    if (images != nil) {
        rec.itemThumbIcon = [images objectAtIndex:0];
        rec.itemIcon = [images objectAtIndex:1];
        return TRUE;
    } else {
        return FALSE;
    }
}

#pragma mark

- (void)dealloc
{
    [mediaRecord release];
    [indexPathInTableView release];
    
    [activeDownload release];
    
    [imageConnection cancel];
    [imageConnection release];
    
    [super dealloc];
}

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    // alloc+init and start an NSURLConnection; release on completion/failure
	if(mediaRecord.imageURLString != nil)
	{
		NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:mediaRecord.imageURLString]] delegate:self];
		self.imageConnection = conn;
		[conn release];
	}
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
    if (image.size.width != kIconWidth && image.size.height != kIconHeight)
	{
        CGSize itemSize = CGSizeMake(kIconWidth, kIconHeight);
		UIGraphicsBeginImageContext(itemSize);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		self.mediaRecord.itemIcon = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    }
    else
    {
        self.mediaRecord.itemIcon = image;
    }
	
	if (image.size.width != kIconThumbWidth && image.size.height != kIconThumbHeight)
	{
        CGSize itemSize = CGSizeMake(kIconThumbWidth, kIconThumbHeight);
		UIGraphicsBeginImageContext(itemSize);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		self.mediaRecord.itemThumbIcon = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    }
    else
    {
        self.mediaRecord.itemThumbIcon = image;
    }
	
    [imageCache setObject:[NSArray arrayWithObjects:self.mediaRecord.itemIcon, self.mediaRecord.itemThumbIcon, nil] forKey:mediaRecord.imageURLString];
    self.activeDownload = nil;
    
    [image release];
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
        
    // call our delegate and tell it that our icon is ready for display
    [delegate appImageDidLoad:self.indexPathInTableView];
}

@end

