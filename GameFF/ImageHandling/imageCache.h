//
//  imageCache.h
//  PuzzleSomething
//
//  Created by Biton, Adi on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface imageCache : NSObject
@property (nonatomic, readonly) NSUInteger maxSize;
@property (nonatomic, readonly) NSUInteger totalSize;
@property (nonatomic, strong, readwrite) NSMutableDictionary *imageDictionary;

-(id)initWithMaxSize:(NSUInteger) max;
-(void)insertImage:(UIImage*)image withSize:(NSUInteger)sz forKey:(NSString*)key;
-(UIImage*)imageForKey:(NSString*)key;
@end
