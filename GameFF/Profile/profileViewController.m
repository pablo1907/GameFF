//
//  profileViewController.m
//  PuzzleSomething
//
//  Created by Biton, Adi on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "profileViewController.h"
#import "AppUser.h"
#import "User.h"
#import "ProfileUploadImageCell.h"

#define TAKE_PHOTO_BUTTON_INDEX                 0
#define CHOOSE_PHOTO_BUTTON_INDEX               1

@interface profileViewController ()
@property (strong,nonatomic)UIImage* image;
@end

@implementation profileViewController
@synthesize profileSettings = _profileSettings;
@synthesize image = _image;

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
    NSError *error;
    AppUser *user = [AppUser getAppUserByID:[[User sharedInstance] ID] Error:&error];
   // NSURL * url = [user getThumbnailUrlForFiled:_AppUserImage];
    NSData * data = [NSData dataWithContentsOfURL:[user _appUserImage] ];
    self.image = [UIImage imageWithData: data];
}

- (void)viewDidUnload
{
    [self setProfileSettings:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row ] ==0) {
        return 88;
    }
    return 44;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    //Image + name cell
    if ([indexPath row] == 0) {
        CellIdentifier = @"imageUpload";
    ProfileUploadImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ProfileUploadImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        cell.userImage.image = self.image;
        //cell.textLabel.text = [[[User sharedInstance] loginUser]_appUserName];
        //cell.contentMode = UIViewCon
        return cell;
    }
    else {
        CellIdentifier = @"Cell"; 
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
            switch ([indexPath row]) {
                case 1:
                { 
                    cell.textLabel.text = @"First name";
                    cell.detailTextLabel.text = [[[User sharedInstance] loginUser]_appUserFirstName];
                    break;
                }
                case 2:
                {
                    cell.textLabel.text = @"Last name";
                    cell.detailTextLabel.text = [[[User sharedInstance] loginUser ]_appUserLastName];    
                    break;
                }
                case 3:
                {
                    cell.textLabel.text = @"Email";
                    cell.detailTextLabel.text = [[[User sharedInstance] loginUser]_appUserEmail];
                    break;
                }
                case 4:
                {
                    cell.textLabel.text = @"Points";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[[[User sharedInstance] loginUser]_appUserPoints]];
                    break;
                }
                default:
                    break;
            }
        }
        return cell;
    }
    
    return nil;

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
        
      //  CGSize constraintSize = CGSizeMake(70.0f, 70.0f);
        self.image = image;
        NSError *error;
        AppUser *user = [AppUser getAppUserByID:[[User sharedInstance] ID] Error:&error];
        [user uploadImage:image andUpdateURL:(_AppUserImage) CreateThumbnail:YES withDelegate:self sizeFactor:1];
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


-(void)didFinishedUploadImage:(int)responseType ResponseMessage:(NSString *)responseMessage URLField:(AppUserField)imageURLField withObject:(AppUser *)object{
    ProfileUploadImageCell* cell = [self.profileSettings cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.userImage.image = self.image;
}

@end
