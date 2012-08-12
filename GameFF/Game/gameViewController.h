//
//  gameViewController.h
//  PuzzleSomething
//
//  Created by Biton, Adi on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gameViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>
@property (nonatomic) int gameID;
@property (weak, nonatomic) IBOutlet UITextField *answerTextField;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;

- (IBAction)guessButtonTouchUpInside:(id)sender;
@end
