//
//  FriendListViewController.m
//  PuzzleSomething
//
//  Created by Biton, Adi on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "friendListViewController.h"
#import "gameCreationViewController.h"
#import "AppUser.h"
#import "User.h"
#import "customCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <stdlib.h>



@interface friendListViewController ()
{
    NSArray *friendsArray;
}
@end

@implementation friendListViewController
@synthesize friendList;
@synthesize createdGame = _createdGame;


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
    
    friendList.dataSource = self;
    friendList.delegate = self;
    
    UserRelationshipFilters *filter = [[UserRelationshipFilters alloc]init];
    [filter addFilter:_UserRelationshipUserID withIntValue:[[User sharedInstance] ID]];

    [UserRelationship getUserRelationshipArrayWithDelegate:self SortField:_UserRelationshipID SortType:Ascending WithFilters:filter];


}

- (void)viewDidUnload
{
    [self setFriendList:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - UserRelationshipDelegate
-(void)didFinishedGetUserRelationshipArray:(int)responseType ResponseMessage:(NSString *)responseMessage withArray:(NSArray *)array
{
    if([array count] > 0)
    {
        friendsArray = array;
        [[self friendList] reloadData];
    }
        
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [friendsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell"; 
    //handle image - async
    //asyncImage *_asyncImage = nil;
    
    customCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[customCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
        UserRelationship *relationship = [friendsArray objectAtIndex:[indexPath row]];
        //Set user namge
        [cell.textLabel setText:[[relationship _userRelationshipFriendID]_appUserName]];
        
        //Set user image
        // NSData *imageData = [NSData dataWithContentsOfURL:[[relationship _userRelationshipFriendID] getThumbnailUrlForFiled:_AppUserImage]];
        // UIImage *myImage = [UIImage imageWithData:imageData];
        //cell.imageView.image = myImage;
        
        [cell.imageView setImageWithURL:[[relationship _userRelationshipFriendID] getThumbnailUrlForFiled:_AppUserImage] 
                       placeholderImage:[UIImage imageNamed:@"111-user.png"]];
        
//    UserRelationship *relationship = [friendsArray objectAtIndex:[indexPath row]];
//    dispatch_async(imageQueue, ^{
//        NSURL *imageThumbnailURL = [[relationship _userRelationshipFriendID] getThumbnailUrlForFiled:_AppUserImage];
//        if(![_imageCache imageForKey:[imageThumbnailURL absoluteString]])
//        {
//            NSData *imageData = [NSData dataWithContentsOfURL:imageThumbnailURL];
//            dispatch_async(dispatch_get_main_queue(),^{
//                [_imageCache insertImage:[UIImage imageWithData:imageData] withSize:[imageData length]  forKey: [imageThumbnailURL absoluteString]];
//                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        });
//        }
//        else {
//            cell.imageView.image = [_imageCache imageForKey:[imageThumbnailURL absoluteString]];
//            [cell setNeedsDisplay];
//        }
//    });
    
   // _asyncImage = [[asyncImage alloc] initWithImageView:cell.imageView];
   // UserRelationship *relationship = [friendsArray objectAtIndex:[indexPath row]];
   // NSURL *url = [[relationship _userRelationshipFriendID] getThumbnailUrlForFiled:_AppUserImage];
   // [_asyncImage loadImageFromURL:url];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserRelationship *relationship = [friendsArray objectAtIndex:[indexPath row]];
    _createdGame = [[Game alloc]initWithDictionary:nil];
    self.createdGame._gameFirstPlayer = [relationship _userRelationshipUserID] ;
    self.createdGame._gameSecondPlayer =  [relationship _userRelationshipFriendID];
    [self performSegueWithIdentifier:@"StartGame" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"StartGame"]) {
        gameCreationViewController* nextVC =  (gameCreationViewController*)segue.destinationViewController;
        [nextVC setCurrentGame:self.createdGame];
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
@end
