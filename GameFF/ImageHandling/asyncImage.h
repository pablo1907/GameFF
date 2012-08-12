//
//  asyncImageView.h
//  PuzzleSomething
//
//  Created by Biton, Adi on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface asyncImage : NSObject
{
    UIImageView *_imageView;
}

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) NSString *urlString; //key for image cache dictionary

- (id)initWithImageView:(UIImageView *)image;
-(void)loadImageFromURL:(NSURL *)url;

+(void)purgeCache;
@end
