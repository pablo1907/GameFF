//
//  registerViewController.m
//  PuzzleSomething
//
//  Created by Biton, Adi on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


NSInteger const kErrorUserExists = 5;

#import "registrationViewController.h"
#import "AppUser.h"
#import "User.h"
#import <Applicasa/Applicasa.h>


@interface registrationViewController ()
{
    int newUserID;
    UITapGestureRecognizer *tapGestrure;

}

@end

@implementation registrationViewController
@synthesize email = _email;
@synthesize userName = _userName;
@synthesize password = _password;
@synthesize repeatPassword = _repeatPassword;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Listen to the keyboard notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    tapGestrure = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapAnywhere:)];
    
    //Generate new user (by log out from current user)
    
    NSError *error;    
    newUserID = [AppUser logOutCurrentAppUser:&error];

}

- (void)viewDidUnload
{
    [self setUserName:nil];
    [self setPassword:nil];
    [self setRepeatPassword:nil];
    [self setEmail:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)okPressed:(id)sender 
{
    if ([self checkFieldsCorrectness])
    {
        AppUser *appUser = [[AppUser alloc] init ];
        //Check if current user is registered - in case he is, we need to logoff and register a new user
        newUserID = [Applicasa getUserID];
        [appUser set_appUserID:newUserID];

        //Current user is registered
        if ([appUser _appUserIsRegistered]) {
            NSError *error;
            [AppUser logOutCurrentAppUser:&error];
            [appUser set_appUserName:[[self userName]text] ];
            [appUser set_appUserPassword:[[self password]text]];
            [appUser set_appUserEmail:[[self email]text] ];
            [appUser set_appUserPushPerDay:5];
            [appUser set_appUserRegisterDate:[NSDate date]];
            [appUser set_appUserLastLogin:[NSDate date]];
            
            [AppUser registerAppUserByItem:appUser Error:&error];
         
            //Set user avatar default image
            UIImage *image = [UIImage imageNamed:@"man.png"];
            [appUser uploadImage:image andUpdateURL:(_AppUserImage) CreateThumbnail:YES withDelegate:self sizeFactor:1];
            
            
            //In case the registration process didn't go well
            if ([[error localizedDescription] length] > 0) {
                if([error code] == kErrorUserExists)
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Username exists, please select different one" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }       
            }
            else {
            //Registration process is finish, prompt the user to the game
                [[User sharedInstance] setID:newUserID];
                [self performSegueWithIdentifier:@"details" sender:self];
            }
        }
        
    }
    
}
#pragma mark - Notification observers
- (void)keyboardWillShow:(NSNotification *)notification
{
    [self.view addGestureRecognizer:tapGestrure];
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    [self.view removeGestureRecognizer:tapGestrure];
}
- (void)didTapAnywhere:(UITapGestureRecognizer *)recognizer
{
    [[self userName]resignFirstResponder];
    [[self email] resignFirstResponder];
    [[self password]resignFirstResponder];
    [[self repeatPassword]resignFirstResponder];
}
#pragma mark - UIAlerViewDelegate

#pragma mark - accessorMethods
-(BOOL) checkFieldsCorrectness
{
    if ([[[self userName] text] length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"User name can not be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return false;
    }
    if ([[[self email] text] length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"email can not be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return false;
    }
    if ([[[self password] text] length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Password can not be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return false;
    }
    if ([[[self repeatPassword] text] length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Repeated password can not be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return false;
    }
    if (![[[self password] text] isEqualToString:[[self repeatPassword] text]]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Passwords not identical" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return false;
    }    
    return true;
}



@end
