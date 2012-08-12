//
//  gameCreationViewController.h
//  PuzzleSomething
//
//  Created by Roisman, Pablo on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface gameCreationViewController : UIViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,GameDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *gameImage;
@property (weak, nonatomic) IBOutlet UITextField *answerText;
@property (strong, nonatomic) Game* currentGame;
@end
