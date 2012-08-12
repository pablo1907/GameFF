//
//  GameListViewController.h
//  PuzzleSomething
//
//  Created by Biton, Adi on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gameListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *gameListTableView;

@end
