//
//  gameViewController.m
//  PuzzleSomething
//
//  Created by Biton, Adi on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//Game Status:
//0. play
//1. guess right - wait for load


#import "gameViewController.h"
#import "Game.h"

#define SUCCESS_TRY @"You are correct!"
#define FAIL_TRY    @"Almost..."
#define BACK_TO_GAME_LIST @"Back to game list"
#define CONTINUE @"Continue"

@interface gameViewController ()
{
    Game *currentGame;
    UITapGestureRecognizer *tapGestrure;
    NSString *guess;
}
@end

@implementation gameViewController

@synthesize gameID = _gameID;
@synthesize answerTextField = _answerTextField;
@synthesize pictureView = _pictureView;

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
    
    //UIImageView enabled 
    [[self pictureView] setUserInteractionEnabled:YES];
    //Listen to the keyboard notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    tapGestrure = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapAnywhere:)];
    
    guess = [[NSString alloc]init ];
    NSError *error;
	currentGame = [Game getGameByID:[self gameID] Error:&error];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[currentGame _gameImage]];
    [_pictureView setImage:[UIImage imageWithData:imageData]];
    self.answerTextField.delegate = self;
}

- (void)viewDidUnload
{
    [self setPictureView:nil];
    [self setAnswerTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Notification observers
- (void)keyboardWillShow:(NSNotification *)notification
{
    [self.pictureView addGestureRecognizer:tapGestrure];
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    [self.pictureView removeGestureRecognizer:tapGestrure];
}

- (void)didTapAnywhere:(UITapGestureRecognizer *)recognizer
{
    [[self answerTextField]resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.answerTextField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    guess = textField.text;
}

#pragma mark - Guess button
- (IBAction)guessButtonTouchUpInside:(id)sender {
    UIAlertView *alert;

    if (guess != nil && [guess length] > 0 && [[guess lowercaseString] isEqualToString:[[currentGame _gameAnswer]lowercaseString]]  ) {
        
        //Give user points
        NSError *error;
        [[currentGame _gameSecondPlayer] set_appUserPoints:[[currentGame _gameSecondPlayer] _appUserPoints] + 100]; 
        [AppUser updateAppUserByItemID:[currentGame _gameSecondPlayer] Error:&error ];

        //Show him success alert
        alert = [[UIAlertView alloc]initWithTitle:SUCCESS_TRY message:@"+100 points" delegate:self cancelButtonTitle:BACK_TO_GAME_LIST otherButtonTitles:CONTINUE, nil];
        [alert show];
    }
    else {
        alert = [[UIAlertView alloc]initWithTitle:FAIL_TRY message:@"You are wrong )-:" delegate:self cancelButtonTitle:@"Try again" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView title] isEqualToString:SUCCESS_TRY]) {
        //Update game:
        //1. Change player order
        AppUser *tempUser = [currentGame _gameFirstPlayer];
        [currentGame set_gameFirstPlayer:[currentGame _gameSecondPlayer]];
        [currentGame set_gameSecondPlayer:tempUser];
        [currentGame set_gameStreak:[currentGame _gameStreak] + 1 ];
        
        NSError *error;
        [Game updateGameByItemID:currentGame Error:&error];
        
        //Navigate player according to his choise
        //0 - button
    //    if(buttonIndex == 0)
            
     //   else if(buttonIndex == 1)
        //2. Move to play again
        [self performSegueWithIdentifier:@"continueGame" sender:self];
    
    }
    
}
@end
