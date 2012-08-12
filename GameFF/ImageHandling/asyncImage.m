//
//  asyncImageView.m
//  PuzzleSomething
//
//  Created by Biton, Adi on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "asyncImage.h"
#import "imageCache.h"

static imageCache *_imageCache = nil;

@implementation asyncImage
@synthesize connection = _connection, data = _data, urlString = _urlString;

- (id)initWithImageView:(UIImageView *)imageView
{
    self = [super init];
    if (self) {
        _imageView = imageView; 
    }
    return self;
}

-(void)loadImageFromURL:(NSURL *)url
{
    //
    // Cancel any current connection.
    //
    [[self connection] cancel];
    _connection = nil;
    _data = nil;
    
    //
    // Lazily create image cache.
    //
    if (_imageCache == nil)
        _imageCache = [[imageCache alloc] initWithMaxSize:2*1024*1024];  // 2 MB Image cache
    
    //
    // Remove any subviews.
    //
   // if ([[self subviews] count] > 0) {
   //     [[[self subviews] objectAtIndex:0] removeFromSuperview];
  //  }
    //
    // Lookup image in cache.
    // If found, delete any subviews and add image as subview.
    //
    [self setUrlString:[[url absoluteString] copy]];
    UIImage *cachedImage = [_imageCache imageForKey:[self urlString]];
    if (cachedImage != nil) {
        //UIImageView *imageView = [[UIImageView alloc] initWithImage:cachedImage];
        //imageView.contentMode = UIViewContentModeScaleAspectFit;
        //imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //[self addSubview:imageView];
        //imageView.frame = self.bounds;
        //[imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
        //[self setNeedsLayout];
        return;
    }
    
    //
    // If image not found in cache, we'll add a spinning activity indicator as
    // a subview and initial an URL connection to fetch the image.
    //
#define SPINNY_TAG 5555 

    NSURLRequest *request = [NSURLRequest requestWithURL:url 
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                         timeoutInterval:60.0];
    [self setConnection:[[NSURLConnection alloc] initWithRequest:request delegate:self]];   
}

- (void)connection:(NSURLConnection *)connection 
    didReceiveData:(NSData *)incrementalData {
    if ([self data]==nil) {
        _data = [[NSMutableData alloc] initWithCapacity:2048];
    }
    
    [[self data] appendData:incrementalData ];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
    _connection = nil;
    
   // UIView *spinny = [self viewWithTag:SPINNY_TAG];
   // [spinny removeFromSuperview];
    
  //  if ([[self subviews] count] > 0) {
  //      [[[self subviews] objectAtIndex:0] removeFromSuperview];
 //   }
    
    UIImage *image = [UIImage imageWithData:[self data]];
    
    [_imageCache insertImage:image withSize:[[self data] length] forKey:[self urlString]];
    _imageView.image = image;
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    //imageView.contentMode = UIViewContentModeScaleAspectFit;
    //imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //[self addSubview:imageView];
    //imageView.frame = self.bounds;
   // [_imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
    [_imageView setNeedsDisplay];
    //[self setNeedsLayout];
    _data = nil;
}
+(void)purgeCache
{
    _imageCache = nil;
}

@end
