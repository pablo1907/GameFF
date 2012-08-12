//
//  imageCache.m
//  PuzzleSomething
//
//  Created by Biton, Adi on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "imageCache.h"
#import "imageCacheObject.h"

@implementation imageCache
@synthesize maxSize, totalSize, imageDictionary;

-(id)initWithMaxSize:(NSUInteger) max {
    if (self = [super init]) {
        totalSize = 0;
        maxSize = max;
        imageDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;    
}

-(void)insertImage:(UIImage*)image withSize:(NSUInteger)sz forKey:(NSString*)key {
    imageCacheObject *object = [[imageCacheObject alloc] initWithSize:sz Image:image];
    while (totalSize + sz > maxSize) {
        NSDate *oldestTime;
        NSString *oldestKey;
        for (NSString *key in [imageDictionary allKeys]) {
            imageCacheObject *obj = [imageDictionary objectForKey:key];
            if (oldestTime == nil || [obj.timeStamp compare:oldestTime] == NSOrderedAscending) {
                oldestTime = obj.timeStamp;
                oldestKey = key;
            }
        }
        if (oldestKey == nil) 
            break; // shoudn't happen
        imageCacheObject *obj = [imageDictionary objectForKey:oldestKey];
        totalSize -= obj.size;
        [imageDictionary removeObjectForKey:oldestKey];
    }
    [imageDictionary setObject:object forKey:key];    
}
-(UIImage*)imageForKey:(NSString*)key {
    imageCacheObject *object = [imageDictionary objectForKey:key];
    if (object == nil)
        return nil;
    [object resetTimeStamp];
    return object.image;    
}

@end
