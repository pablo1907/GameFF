//
//  openingViewController.m
//  PuzzleSomething
//
//  Created by Biton, Adi on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "openingViewController.h"


@interface openingViewController ()

@end

@implementation openingViewController
@synthesize imageView;
@synthesize registerButton;
@synthesize loginButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Add picture to the image view
    
    [[self imageView] setImage:[UIImage imageNamed:@"openBG.jpg"]];
    
    //Picture something title animation
    UILabel *appTitle = [[UILabel alloc]initWithFrame:CGRectMake(-100, 60, 200, 40)];
    [appTitle setText:@"Picture something!"];
    [appTitle setFont:[UIFont fontWithName:@"Helvetica" size:22.0]];
    [appTitle setTextColor:[UIColor whiteColor]];
    [appTitle setBackgroundColor:[UIColor clearColor]];
    
    [[self imageView] addSubview:appTitle];
    
    CGRect targetFrame = CGRectMake(60, 60, 200, 40);
    
    [UIView animateWithDuration:2.0 animations:^{
        [appTitle setFrame:targetFrame];
    }];
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setImageView:nil];
    [self setRegisterButton:nil];
    [self setLoginButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onRegisterClick:(id)sender {
    [self performSegueWithIdentifier:@"register" sender:self];
}

- (IBAction)onLoginClick:(id)sender {
    [self performSegueWithIdentifier:@"login" sender:self];
}
@end
