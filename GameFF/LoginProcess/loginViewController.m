//
//  loginViewController.m
//  PuzzleSomething
//
//  Created by Biton, Adi on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "loginViewController.h"
#import "AppUser.h"
#import "User.h"
#import <QuartzCore/QuartzCore.h>

@interface loginViewController ()
{
    NSString *userName;
    NSString *password;
    UITapGestureRecognizer *tapGestrure;

}
-(void) setInitialUsernamePassword;    
    
@end

@implementation loginViewController
@synthesize passwordField = _passwordField;
@synthesize usernameField = _usernameField;
@synthesize loginBtn = _loginBtn;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        userName = [[NSString alloc]init];
        password = [[NSString alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self loginBtn] setEnabled:NO];
    [[self usernameField]setDelegate:self];
    [[self passwordField]setDelegate:self];
   
    //Listen to the keyboard notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    tapGestrure = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapAnywhere:)];
 }

- (void)viewDidUnload
{
    [self setLoginBtn:nil];
    [self setPasswordField:nil];
    [self setUsernameField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (void) textFieldDidEndEditing:(UITextField *)textField {
   if(textField == [self usernameField])
            userName = textField.text;
   else if(textField == [self passwordField])
            password = textField.text;
    
    if ([userName length] != 0 && [password length] != 0 ) {
        [[self loginBtn] setEnabled:YES];
    }
    else {
        [[self loginBtn] setEnabled:NO];
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
    [[self usernameField]resignFirstResponder];
    [[self passwordField]resignFirstResponder];
}


- (IBAction)loginPushed:(id)sender {
    NSError *error = [[NSError alloc]init];
    int userID  = [AppUser logInAppUserWithUserName:userName andPassword:password Error:&error];
    if(error)
    {
        NSString *outputMessage; 
        for(NSString *errorMessage in [[error userInfo]allValues])
            outputMessage = [NSString stringWithString:errorMessage];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Failed to login" message:outputMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alertView show];
             
    }
     
    else
    {
        [[User sharedInstance] setID:userID];
        [self performSegueWithIdentifier:@"details" sender:self];
    }
}


- (IBAction)registerPushed:(id)sender {
    [self performSegueWithIdentifier:@"registrationForm" sender:self];
}
- (IBAction)test:(id)sender {
    return;
    NSLog(@"test");
}
@end
