//
//  AudioDownloader.m
//  ChurchOfGod
//
//  Created by Calvin Ko on 4/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AudioDownloader.h"
#import "MediaRecord.h"
#import "ConfigManager.h"


@implementation AudioDownloader

@synthesize netConnection, filePath, fileName, fileSize, audioURL;
@synthesize delegate, pview;

- (id) init {
    [super init];
    nbytes = 0;
    return self;
}

- (id) initWithMedia:(MediaRecord *)record 
{
    self.filePath = [[ConfigManager getDocumentPath] stringByAppendingPathComponent:@"music.mp3"];
    audioURL = record.itemAudioURLString;
    return self;
}

- (void) startDownload

{
    fp = fopen([filePath cStringUsingEncoding:NSUTF8StringEncoding], "wb");
    if (fp != NULL) {
        // alloc+init and start an NSURLConnection; release on completion/failure
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:audioURL]] delegate:self];
        self.netConnection = conn;
        [conn release];
    }
}

- (void) stopDownload
{
    [self.netConnection cancel];
    self.netConnection = nil;
    return;
}

#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if ([data length] > 0) {
        fwrite([data bytes], 1, [data length], fp);
        nbytes = nbytes + [data length];
        pview.progress = (float) nbytes / fileSize;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Release the connection now that it's finished
    self.netConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    fclose(fp);
    self.netConnection = nil;
    [delegate audioFileDidLoad:filePath];
}

@end
