//
//  User.m
//  PuzzleSomething
//
//  Created by Biton, Adi on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize ID = _ID;
@synthesize loginUser = _loginUser;

+(id) sharedInstance 
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;}

-(id) init{
    self = [super init];
    return self;
}
-(void)setID:(int)ID
{
    _ID = ID;
    NSError *error;
    [self setLoginUser:[AppUser getAppUserByID:[self ID] Error:&error]];
}
@end
