//
//  gameCreationViewController.m
//  PuzzleSomething
//
//  Created by Roisman, Pablo on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "gameCreationViewController.h"
#define TAKE_PHOTO_BUTTON_INDEX                 0
#define CHOOSE_PHOTO_BUTTON_INDEX               1

@interface gameCreationViewController ()

@end

@implementation gameCreationViewController
@synthesize gameImage = _gameImage;
@synthesize answerText = _answerText;
@synthesize currentGame = _currentGame;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.answerText setDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidUnload
{
    [self setGameImage:nil];
    [self setAnswerText:nil];
    [self setGameImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    return;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)imageTapped:(id)sender
{
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"Take Photo", @"Choose Photo", nil];
    [popupQuery showFromRect:self.view.bounds inView:self.view animated:YES];
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet  // before animation and showing view
{
    if ([self isCameraAvailable])
        return;
    // If no camera available, disable the "Take Photo" button
    for (UIView* actionSheetButton in [actionSheet subviews])
    {
        if ([actionSheetButton respondsToSelector:@selector(title)])
        {
            NSString* title = [actionSheetButton performSelector:@selector(title)];
            if ([title isEqualToString:@"Take Photo"] && [self.view respondsToSelector:@selector(setEnabled:)])
            {
                [actionSheetButton performSelector:@selector(setEnabled:) withObject:false];
                break;
            }
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case TAKE_PHOTO_BUTTON_INDEX:
            [self startCameraControllerFromViewController:self usingDelegate:self];
            break;
        case CHOOSE_PHOTO_BUTTON_INDEX:
            [self startMediaBrowserFromViewController:self usingDelegate:self];
            break;
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{    
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:YES];
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
       // CGSize constraintSize = CGSizeMake(70.0f, 70.0f);
        self.gameImage.image = image;
        [self.currentGame uploadImage:image andUpdateURL:(_GameImage) CreateThumbnail:NO withDelegate:self sizeFactor:1];
    }
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
	if ((![self isCameraAvailable]) || (delegate == nil) || (controller == nil))
	{
		return NO;
	}
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeCamera];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;    
    cameraUI.delegate = delegate;
    [controller presentModalViewController: cameraUI animated: YES];
    
    return YES;
}

- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
	mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; 	
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = NO;
    mediaUI.delegate = delegate;
    [controller presentModalViewController: mediaUI animated: YES];
    
    return YES;
}

- (BOOL)isCameraAvailable
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
#pragma mark - Notification Handlers

- (void)keyboardWillShow:(NSNotification *)notification
{
    // I'll try to make my text field 20 pixels above the top of the keyboard
    // To do this first we need to find out where the keyboard will be.
    
    NSValue *keyboardEndFrameValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardEndFrame = [keyboardEndFrameValue CGRectValue];
    
    // When we move the textField up, we want to match the animation duration and curve that
    // the keyboard displays. So we get those values out now
    
    NSNumber *animationDurationNumber = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = [animationDurationNumber doubleValue];
    
    NSNumber *animationCurveNumber = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = [animationCurveNumber intValue];
    
    // UIView's block-based animation methods anticipate not a UIVieAnimationCurve but a UIViewAnimationOptions.
    // We shift it according to the docs to get this curve.
    
    UIViewAnimationOptions animationOptions = animationCurve << 16;
    
    
    // Now we set up our animation block.
    [UIView animateWithDuration:animationDuration 
                          delay:0.0 
                        options:animationOptions 
                     animations:^{
                         // Now we just animate the text field up an amount according to the keyboard's height,
                         // as we mentioned above.
                         CGRect textFieldFrame = self.answerText.frame;
                         textFieldFrame.origin.y = keyboardEndFrame.origin.y - textFieldFrame.size.height-80; //I don't think the keyboard takes into account the status bar
                         self.answerText.frame = textFieldFrame;
                     } 
                     completion:^(BOOL finished) {}];
    
}


- (void)keyboardWillHide:(NSNotification *)notification
{
    NSNumber *animationDurationNumber = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = [animationDurationNumber doubleValue];
    
    NSNumber *animationCurveNumber = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = [animationCurveNumber intValue];
    UIViewAnimationOptions animationOptions = animationCurve << 16;
    
    [UIView animateWithDuration:animationDuration 
                          delay:0.0 
                        options:animationOptions 
                     animations:^{
                         self.answerText.frame = CGRectMake(self.answerText.frame.origin.x, self.answerText.frame.origin.y+150, self.answerText.frame.size.width, self.answerText.frame.size.height); //just some hard coded value
                     } 
                     completion:^(BOOL finished) {}];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.answerText resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.currentGame._gameAnswer = textField.text;
}

- (IBAction)saveGame:(id)sender {
    self.currentGame._gameStreak ++;
    [Game addGame:self.currentGame withDelegate:self];
    
}


-(void)addGameDidFinished:(int)responseType ResponseMessage:(NSString *)responseMessage withObject:(Game *)object{
    [self performSegueWithIdentifier:@"BackToGameList" sender:self];
}
@end
