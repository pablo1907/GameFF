//
//  openingViewController.h
//  PuzzleSomething
//
//  Created by Biton, Adi on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface openingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)onRegisterClick:(id)sender;
- (IBAction)onLoginClick:(id)sender;

@end
