//
//  ACLParser.h
//  Applicasa
//
//  Created by Benny Davidovich on 1/22/12.
//  Copyright (c) 2012 Applicasa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACLParser : NSObject{
    
}

+(NSDate *)parseDateValue:(NSString *)value;
+(BOOL)parseBoolFromString:(NSString *)str;
@end
