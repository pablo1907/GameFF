//
//  profileViewController.h
//  PuzzleSomething
//
//  Created by Biton, Adi on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppUser.h"

@interface profileViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UIActionSheetDelegate,AppUserDelegate>

@property (weak, nonatomic) IBOutlet UITableView *profileSettings;

@end
