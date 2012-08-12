//
//  friendListViewController.h
//  PuzzleSomething
//
//  Created by Biton, Adi on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserRelationship.h"
#import "Game.h"

@interface friendListViewController : UIViewController<UserRelationshipDelegate, UITableViewDelegate,UITableViewDataSource>
{
    dispatch_queue_t imageQueue;
}
@property (weak, nonatomic) IBOutlet UITableView *friendList;
@property (strong,nonatomic) Game* createdGame;
@end
