//
//  imageCacheObject.m
//  PuzzleSomething
//
//  Created by Biton, Adi on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "imageCacheObject.h"

@implementation imageCacheObject
@synthesize size, timeStamp, image;

-(id)initWithSize:(NSUInteger)sz Image:(UIImage*)anImage {
    if (self = [super init]) {
        size = sz;
        timeStamp = [NSDate date];
        image = anImage;
    }
    return self;
    
}

-(void)resetTimeStamp {
    timeStamp = [NSDate date];
}
@end
