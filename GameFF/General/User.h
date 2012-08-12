//
//  User.h
//  PuzzleSomething
//
//  Created by Biton, Adi on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppUser.h"


@interface User : NSObject
@property (nonatomic) int ID;
@property (nonatomic,strong) AppUser *loginUser;


+(id) sharedInstance;
@end
