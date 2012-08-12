//
//  loginViewController.h
//  PuzzleSomething
//
//  Created by Biton, Adi on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

- (IBAction)loginPushed:(id)sender;
- (IBAction)registerPushed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)test:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end
