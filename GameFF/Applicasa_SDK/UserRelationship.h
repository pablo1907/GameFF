//
// UserRelationship.h
// Created by Applicasa dbGenerator
// 8/2/2012
//

#import <Foundation/Foundation.h>
#import <Applicasa/Applicasa.h>
#import "AppUser.h"
#import "AppUser.h"
#import <Applicasa/NSData+Base64.h>

// Object's fields and filters enum
typedef enum {
	_UserRelationship_None,
	_UserRelationshipID,
	_UserRelationshipType,
	_UserRelationshipFriendID,
	_UserRelationshipUserID
} UserRelationshipField;

//*************
// Filter class
//
// Used to set filters for Get-Array methods with filters
//

@interface UserRelationshipFilters : NSObject {
}
@property (nonatomic, retain) NSMutableDictionary *filters;

// Filter for Text,Multiline,Image and HTML fields
-(void)addFilter:(UserRelationshipField)filterName withValue:(NSString *)value;

// Filter for Number ,Foreign-key and List fields
-(void)addFilter:(UserRelationshipField)filterName withIntValue:(int)value;

// Filter for Real field
-(void)addFilter:(UserRelationshipField)filterName withFloatValue:(float)value;

// Filter for True or False field
-(void)addFilter:(UserRelationshipField)filterName withBOOLValue:(BOOL)value;

// Filter for Date field
-(void)addFilter:(UserRelationshipField)filterName withDateValue:(NSDate *)value;

// Filter for Image field
-(void)addFilter:(UserRelationshipField)filterName withURLValue:(NSURL *)value;

@end



//*************
//
// UserRelationshipDelegate Protocol
//
// Implement this protocol when using A-Sync requests
//

@class UserRelationship;
@protocol UserRelationshipDelegate <NSObject>;
@optional
// Optional means that you don't must to implement those methods

// Delegate method for the A-Sync add method
-(void)addUserRelationshipDidFinished:(int)responseType ResponseMessage:(NSString *)responseMessage withObject:(UserRelationship *)object;

// Delegate method for the A-Sync update method
-(void)updateUserRelationshipDidFinished:(int)responseType ResponseMessage:(NSString *)responseMessage withObject:(UserRelationship *)object;

// Delegate method for the A-Sync get method
-(void)getUserRelationshipDidFinished:(int)responseType ResponseMessage:(NSString *)responseMessage withObject:(UserRelationship *)object;

// Delegate method for the A-Sync delete method
-(void)deleteUserRelationshipDidFinished:(int)responseType ResponseMessage:(NSString *)responseMessage withID:(int)ID;

// Delegate method for the A-Sync Get-Array method
-(void)didFinishedGetUserRelationshipArray:(int)responseType ResponseMessage:(NSString *)responseMessage withArray:(NSArray *)array;

// Delegate method for the A-Sync Get-Array method with request id
- (void) didFinishedGetUserRelationshipArray:(int)responseType ResponseMessage:(NSString *)responseMessage withArray:(NSArray *)array AndRequestID:(int)requestID;

// Delegate method for the A-Sync Upload Image method 
-(void)didFinishedUploadImage:(int)responseType ResponseMessage:(NSString *)responseMessage URLField:(UserRelationshipField)imageURLField withObject:(UserRelationship *)object;

@end



//*************
//
// UserRelationship Class
//
//

@interface UserRelationship : NSObject <ACLRequestDelegate> {

}

@property (nonatomic, assign) int requestID;
@property (nonatomic, retain) id<UserRelationshipDelegate> delegate;
@property (nonatomic, assign) int _userRelationshipID;
@property (nonatomic, retain) NSString *_userRelationshipType;
@property (nonatomic, retain) AppUser *_userRelationshipFriendID;
@property (nonatomic, retain) AppUser *_userRelationshipUserID;

// Initalization methods
-(id)initWithDictionary:(NSDictionary *)item;
-(id)initWithObject:(UserRelationship *)object;

-(void)uploadImage:(UIImage *)image andUpdateURL:(UserRelationshipField)imageURLField CreateThumbnail:(BOOL)createThumbnail withDelegate:(id)_delegate sizeFactor:(float)factor;
-(NSURL *)getThumbnailUrlForFiled:(UserRelationshipField)field;
// ****
// Add UserRelationship item to Applicasa DB
//
// A-Sync Add method (optional to implement UserRelationshipDelegate protocol)
+(void)addUserRelationship:(UserRelationship *)item withDelegate:(id)delgate;
// Sync Add method
+ (int)addUserRelationship:(UserRelationship *)item Error:(NSError **)error;


// ****
// Update UserRelationship item in Applicasa DB
//
// A-Sync Update method by ID (optional to implement UserRelationshipDelegate)
+(void)updateUserRelationshipByID:(int)ID item:(UserRelationship *)item withDelegate:(id)delgate;
//Sync Update method by ID
+(BOOL)updateUserRelationshipByID:(int)ID item:(UserRelationship *)item Error:(NSError **)error;

// A-Sync Update method by UserRelationship item (optional to implement UserRelationshipDelegate)
+(void)updateUserRelationshipByItemID:(UserRelationship *)item withDelegate:(id)delgate;
//Sync Update method by UserRelationship item
+(BOOL)updateUserRelationshipByItemID:(UserRelationship *)item Error:(NSError **)error;


// ****
// Get UserRelationship item from Applicasa DB
//
// A-Sync Get method (optional to implement UserRelationshipDelegate)
//
// A-Sync Get method
+(void)getUserRelationshipByID:(int)ID withDelegate:(id)delgate;
// Sync Get method
+(UserRelationship *)getUserRelationshipByID:(int)ID Error:(NSError **)error;


// ****
// Delete UserRelationship item from Applicasa DB
//
// A-Sync Delete method (optional to implement UserRelationshipDelegate protocol)
+(void)deleteUserRelationshipByID:(int)ID withDelegate:(id)delgate;
// Sync Delete method
+(BOOL)deleteUserRelationshipByID:(int)ID Error:(NSError **)error;

// ****
// Get UserRelationship Array from Applicasa DB
// Use sortField to sort the array according the field you choosed
// Use sortType to set the sort order (Ascesnding/Descending)
// Use filters to filter the data by using an instance UserRelationshipFilters class
// Use pager to get specified indexes
//
// Sync Get-Array method
+(NSArray *)getUserRelationshipArray:(NSError **)error SortField:(UserRelationshipField)sortField SortType:(SortType)sortType;
// Sync Get-Array method with Filter
+(NSArray *)getUserRelationshipArray:(NSError **)error SortField:(UserRelationshipField)sortField SortType:(SortType)sortType WithFilters:(UserRelationshipFilters *)filters;
// Sync Get-Array method with Filter and Pager
+(NSArray *)getUserRelationshipArray:(NSError **)error SortField:(UserRelationshipField)sortField SortType:(SortType)sortType WithFilters:(UserRelationshipFilters *)filters AndPager:(int)page RecsPerPage:(int)recsPerPage;

// A-Sync Get-Array method (optional to implement UserRelationshipDelegate protocol)
+(void)getUserRelationshipArrayWithDelegate:(id)delegate SortField:(UserRelationshipField)sortField SortType:(SortType)sortType;
// A-Sync Get-Array method with Filter (optional to implement UserRelationshipDelegate protocol)
+ (void)getUserRelationshipArrayWithDelegate:(id)delegate SortField:(UserRelationshipField)sortField SortType:(SortType)sortType WithFilters:(UserRelationshipFilters *)filters;
// A-Sync Get-Array method with Filter and Pager (optional to implement UserRelationshipDelegate protocol)
+(void)getUserRelationshipArrayWithDelegate:(id)delegate SortField:(UserRelationshipField)sortField SortType:(SortType)sortType WithFilters:(UserRelationshipFilters *)filters AndPager:(int)page RecsPerPage:(int)recsPerPage;

// A-Sync Get-Array method with Filter and Pager with request id(optional to implement UserRelationshipDelegate protocol)
+ (void)getUserRelationshipArrayWithDelegate:(id)delegate SortField:(UserRelationshipField)sortField SortType:(SortType)sortType WithFilters:(UserRelationshipFilters *)filters AndPager:(int)page RecsPerPage:(int)recsPerPage AndRequestID:(int)requestID;

// Cancel requests
+ (void)cancelRequestsForDelegate:(id)delegate;

@end
