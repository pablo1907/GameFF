//
//  registerViewController.h
//  PuzzleSomething
//
//  Created by Biton, Adi on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
FOUNDATION_EXPORT NSInteger const kErrorUserExists;

#import <UIKit/UIKit.h>
#import "AppUser.h"

@interface registrationViewController : UIViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *repeatPassword;
@property (weak, nonatomic) IBOutlet UITextField *email;

- (IBAction)okPressed:(id)sender;

@end
