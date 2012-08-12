//
// AppUser.h
// Created by Applicasa dbGenerator
// 8/2/2012
//

#import <Foundation/Foundation.h>
#import <Applicasa/Applicasa.h>
#import "UserGroup.h"
#import <Applicasa/NSData+Base64.h>

// Object's fields and filters enum
typedef enum {
	_AppUser_None,
	_AppUserID,
	_AppUserName,
	_AppUserFirstName,
	_AppUserLastName,
	_AppUserEmail,
	_AppUserPushPerDay,
	_AppUserLastLogin,
	_AppUserLastLoginStartFilter,
	_AppUserLastLoginEndFilter,
	_AppUserRegisterDate,
	_AppUserRegisterDateStartFilter,
	_AppUserRegisterDateEndFilter,
	_AppUserLastPosLatitude,
	_AppUserLastPosLongitude,
	_AppUserIsRegistered,
	_AppUserImage,
	_AppUserPoints,
	_AppUserUserGroup
} AppUserField;

//*************
// Filter class
//
// Used to set filters for Get-Array methods with filters
//

@interface AppUserFilters : NSObject {
}
@property (nonatomic, retain) NSMutableDictionary *filters;

// Filter for Text,Multiline,Image and HTML fields
-(void)addFilter:(AppUserField)filterName withValue:(NSString *)value;

// Filter for Number ,Foreign-key and List fields
-(void)addFilter:(AppUserField)filterName withIntValue:(int)value;

// Filter for Real field
-(void)addFilter:(AppUserField)filterName withFloatValue:(float)value;

// Filter for True or False field
-(void)addFilter:(AppUserField)filterName withBOOLValue:(BOOL)value;

// Filter for Date field
-(void)addFilter:(AppUserField)filterName withDateValue:(NSDate *)value;

// Filter for Image field
-(void)addFilter:(AppUserField)filterName withURLValue:(NSURL *)value;

@end



//*************
//
// AppUserDelegate Protocol
//
// Implement this protocol when using A-Sync requests
//

@class AppUser;
@protocol AppUserDelegate <NSObject>;
@optional
// Optional means that you don't must to implement those methods

// Delegate method for the A-Sync add method
-(void)addAppUserDidFinished:(int)responseType ResponseMessage:(NSString *)responseMessage withObject:(AppUser *)object;

// Delegate method for the A-Sync update method
-(void)updateAppUserDidFinished:(int)responseType ResponseMessage:(NSString *)responseMessage withObject:(AppUser *)object;

// Delegate method for the A-Sync get method
-(void)getAppUserDidFinished:(int)responseType ResponseMessage:(NSString *)responseMessage withObject:(AppUser *)object;

// Delegate method for the A-Sync delete method
-(void)deleteAppUserDidFinished:(int)responseType ResponseMessage:(NSString *)responseMessage withID:(int)ID;

// Delegate method for the A-Sync Get-Array method
-(void)didFinishedGetAppUserArray:(int)responseType ResponseMessage:(NSString *)responseMessage withArray:(NSArray *)array;

// Delegate method for the A-Sync Get-Array method with request id
- (void) didFinishedGetAppUserArray:(int)responseType ResponseMessage:(NSString *)responseMessage withArray:(NSArray *)array AndRequestID:(int)requestID;

// Delegate method for the A-Sync Upload Image method 
-(void)didFinishedUploadImage:(int)responseType ResponseMessage:(NSString *)responseMessage URLField:(AppUserField)imageURLField withObject:(AppUser *)object;

@end



//*************
//
// AppUser Class
//
//

@interface AppUser : NSObject <ACLRequestDelegate> {

}

@property (nonatomic, assign) int requestID;
@property (nonatomic, retain) id<AppUserDelegate> delegate;
@property (nonatomic, assign) int _appUserID;
@property (nonatomic, retain) NSString *_appUserName;
@property (nonatomic, retain) NSString *_appUserFirstName;
@property (nonatomic, retain) NSString *_appUserLastName;
@property (nonatomic, retain) NSString *_appUserEmail;
@property (nonatomic, retain) NSString *_appUserPassword;
@property (nonatomic, assign) int _appUserPushPerDay;
@property (nonatomic, retain) NSDate *_appUserLastLogin;
@property (nonatomic, retain) NSDate *_appUserRegisterDate;
@property (nonatomic, assign) float _appUserLastPosLatitude;
@property (nonatomic, assign) float _appUserLastPosLongitude;
@property (nonatomic, assign, readonly) BOOL _appUserIsRegistered;
@property (nonatomic, retain) NSURL *_appUserImage;
@property (nonatomic, assign) int _appUserPoints;
@property (nonatomic, retain) UserGroup *_appUserUserGroup;

+ (void)setKey;

// Initalization methods
-(id)initWithDictionary:(NSDictionary *)item;
-(id)initWithObject:(AppUser *)object;

-(void)uploadImage:(UIImage *)image andUpdateURL:(AppUserField)imageURLField CreateThumbnail:(BOOL)createThumbnail withDelegate:(id)_delegate sizeFactor:(float)factor;
-(NSURL *)getThumbnailUrlForFiled:(AppUserField)field;
// ****
// Get AppUser item from Applicasa DB
//
// A-Sync Get method (optional to implement AppUserDelegate)
//
// A-Sync Get method
+(void)getAppUserByID:(int)ID withDelegate:(id)delgate;
// Sync Get method
+(AppUser *)getAppUserByID:(int)ID Error:(NSError **)error;


// ****
// Delete AppUser item from Applicasa DB
//
// A-Sync Delete method (optional to implement AppUserDelegate protocol)
+(void)deleteAppUserByID:(int)ID withDelegate:(id)delgate;
// Sync Delete method
+(BOOL)deleteAppUserByID:(int)ID Error:(NSError **)error;

// ****
// Get AppUser Array from Applicasa DB
// Use sortField to sort the array according the field you choosed
// Use sortType to set the sort order (Ascesnding/Descending)
// Use filters to filter the data by using an instance AppUserFilters class
// Use pager to get specified indexes
//
// Sync Get-Array method
+(NSArray *)getAppUserArray:(NSError **)error SortField:(AppUserField)sortField SortType:(SortType)sortType;
// Sync Get-Array method with Filter
+(NSArray *)getAppUserArray:(NSError **)error SortField:(AppUserField)sortField SortType:(SortType)sortType WithFilters:(AppUserFilters *)filters;
// Sync Get-Array method with Filter and Pager
+(NSArray *)getAppUserArray:(NSError **)error SortField:(AppUserField)sortField SortType:(SortType)sortType WithFilters:(AppUserFilters *)filters AndPager:(int)page RecsPerPage:(int)recsPerPage;

// A-Sync Get-Array method (optional to implement AppUserDelegate protocol)
+(void)getAppUserArrayWithDelegate:(id)delegate SortField:(AppUserField)sortField SortType:(SortType)sortType;
// A-Sync Get-Array method with Filter (optional to implement AppUserDelegate protocol)
+ (void)getAppUserArrayWithDelegate:(id)delegate SortField:(AppUserField)sortField SortType:(SortType)sortType WithFilters:(AppUserFilters *)filters;
// A-Sync Get-Array method with Filter and Pager (optional to implement AppUserDelegate protocol)
+(void)getAppUserArrayWithDelegate:(id)delegate SortField:(AppUserField)sortField SortType:(SortType)sortType WithFilters:(AppUserFilters *)filters AndPager:(int)page RecsPerPage:(int)recsPerPage;

// A-Sync Get-Array method with Filter and Pager with request id(optional to implement AppUserDelegate protocol)
+ (void)getAppUserArrayWithDelegate:(id)delegate SortField:(AppUserField)sortField SortType:(SortType)sortType WithFilters:(AppUserFilters *)filters AndPager:(int)page RecsPerPage:(int)recsPerPage AndRequestID:(int)requestID;

// A sync method to initalize the current AppUser fields
+(void)registerAppUserByItem:(AppUser *)item Error:(NSError **)error;

//Login sync method
//Returns the user-id and save it on the device
+(int)logInAppUserWithUserName:(NSString *)userName andPassword:(NSString *)password Error:(NSError **)error;

//Log out sync method
//Delete the current AppUser and Return & save new AppUser id
+(int)logOutCurrentAppUser:(NSError **)error;

//Update password sync method
//This method updates the current AppUser password
+(BOOL)updateAppUserPasswordByPassword:(NSString *)passowrd Error:(NSError **)error;

//Update password sync method by item
//This method updates the current AppUser password
+(BOOL)updateAppUserPasswordByItem:(AppUser *)item Error:(NSError **)error;

//Update Username sync method
//This method updates the current AppUser name
+(BOOL)updateAppUserName:(NSString *)appUserName Password:(NSString *)password Error:(NSError **)error;

//Update Username sync method by item
//This method updates the current AppUser name
+(BOOL)updateAppUserNameByItem:(AppUser *)item Error:(NSError **)error;

//Sync update method to update all AppUser's Field but not AppUserName & AppUserPassword
+(BOOL)updateAppUserByItemID:(AppUser *)item Error:(NSError **)error;

//A-sync update method to update all AppUser's Field but not AppUserName & AppUserPassword
+(void)updateAppUserLocationWithDelegate:(id)delegate;

//A method to stop auto location update
+(void)stopUpdatingCurrentAppUserLocation;

//A method to start auto location update
+(void)startUpdatingCurrentAppUserLocationWithDelegate:(id)delegate DesireAccuracy:(CLLocationAccuracy)desireAccuracy DistanceFilter:(CLLocationDistance)distanceFilter;

// Cancel requests
+ (void)cancelRequestsForDelegate:(id)delegate;

@end
