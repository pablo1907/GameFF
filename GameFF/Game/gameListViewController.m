//
//  gameListViewController.m
//  PuzzleSomething
//
//  Created by Biton, Adi on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "gameListViewController.h"
#import "Game.h"
#import "AppUser.h"
#import "User.h"
#import "gameViewController.h"
#import "customCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface gameListViewController ()
{
    NSInteger currentGame;
}
@property(strong,nonatomic)NSArray* userTurnArray;
@property(strong,nonatomic)NSArray* theirTurnArray;
@end

@implementation gameListViewController
@synthesize gameListTableView = _gameListTableView;
@synthesize userTurnArray = _userTurnArray;
@synthesize theirTurnArray = _theirTurnArray;

int const YOUR_TURN = 0;
int const THIER_TURN = 1;

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
    GameFilters* filters = [[GameFilters alloc]init];
    NSError *error;
    AppUser *user = [AppUser getAppUserByID:[[User sharedInstance] ID] Error:&error];
    [filters addFilter:_GameSecondPlayer withIntValue:[user _appUserID]];
    _userTurnArray = [Game getGameArray:&error SortField:_GameFirstPlayer SortType:Ascending WithFilters:filters AndPager:0 RecsPerPage:0];
    
    filters = [[GameFilters alloc]init];
    [filters addFilter:_GameFirstPlayer withIntValue:[user _appUserID]];
    _theirTurnArray = [Game getGameArray:&error SortField:_GameFirstPlayer SortType:Ascending WithFilters:filters AndPager:0 RecsPerPage:0];
    
	[[self gameListTableView] setDelegate:self];
    [[self gameListTableView] setDataSource:self];
}

- (void)viewDidUnload
{
    [self setGameListTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case YOUR_TURN:
            return [self.userTurnArray count];
            break;
            
        case THIER_TURN:
            return [self.theirTurnArray count];
            break;
        default:
            return 1;
            break;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    switch (section) {
        case YOUR_TURN:
            title = @"Your Turn";
            break;
        case THIER_TURN:
            title = @"Their Turn";
            break;
        default:
            break;
    }
    return title;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell"; 
    customCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[customCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    switch ([indexPath section]) {
        case YOUR_TURN:
        {
            Game *game = (Game *)[[self userTurnArray] objectAtIndex:[indexPath row]];
            //cell.imageView.image = [[game _gameFirstPlayer] _appUser];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ - %d", [[game _gameFirstPlayer]_appUserName], [game _gameStreak]]; 
            //set Game id as cell identifier
            cell.tag = [game _gameID];
            
            //Set user image
            [cell.imageView setImageWithURL:[[game _gameFirstPlayer] getThumbnailUrlForFiled:_AppUserImage] 
                           placeholderImage:[UIImage imageNamed:@"man.png"]];
            //cell.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            //NSData *imageData = [NSData dataWithContentsOfURL:[[game _gameFirstPlayer] getThumbnailUrlForFiled:_AppUserImage]];
            //UIImage *myImage = [UIImage imageWithData:imageData];
            //cell.imageView.image = myImage;
            
            //TTImageView *ttImageView = [[TTImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
            //ttImageView.defaultImage = [UIImage imageNamed:@"111-user.png"];
            //ttImageView.urlPath = [[[game _gameFirstPlayer] getThumbnailUrlForFiled:_AppUserImage] absoluteString];
            
            //[cell.contentView addSubview:ttImageView];
            break;
        }    
        case THIER_TURN:
        {
            Game *game = (Game *)[[self theirTurnArray] objectAtIndex:[indexPath row]];
            //cell.textLabel.text = [NSString stringWithFormat:@"%@ - %d",[[game _gameSecondPlayer]_appUserName], [game _gameStreak]]; 
            //set Game id as cell identifier
            cell.tag = [game _gameID];
            
            //Set user image
            [cell.imageView setImageWithURL:[[game _gameSecondPlayer] getThumbnailUrlForFiled:_AppUserImage] 
                           placeholderImage:[UIImage imageNamed:@"111-user.png"]];
            //NSData *imageData = [NSData dataWithContentsOfURL:[[game _gameSecondPlayer] getThumbnailUrlForFiled:_AppUserImage]];
            //UIImage *myImage = [UIImage imageWithData:imageData];
            //cell.imageView.image = myImage;

           // TTImageView *ttImageView = [[TTImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
           // ttImageView.defaultImage = [UIImage imageNamed:@"111-user.png"];
           // ttImageView.urlPath = [[[game _gameSecondPlayer] getThumbnailUrlForFiled:_AppUserImage] absoluteString];
            
           // [cell.contentView addSubview:ttImageView];
            break;
        }    
        default:
            break;
    }
    

    return cell;
}

#pragma mark - UITableViewDelagate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    if ([indexPath section] == YOUR_TURN) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        currentGame = cell.tag;
        //Go to play the relevant game
        [self performSegueWithIdentifier:@"playGame" sender:self];
        
    }
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"playGame"]) {
        gameViewController* nextVC =  (gameViewController*)segue.destinationViewController;
        [nextVC setGameID:currentGame];
    }
}
@end
