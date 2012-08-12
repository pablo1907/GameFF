//
// UserGroup.h
// Created by Applicasa dbGenerator
// 6/14/2012
//

#import <Foundation/Foundation.h>
#import <Applicasa/Applicasa.h>
#import <Applicasa/NSData+Base64.h>

// Object's fields and filters enum
typedef enum {
	_UserGroup_None,
	_UserGroupID,
	_UserGroupName
} UserGroupField;

//*************
// Filter class
//
// Used to set filters for Get-Array methods with filters
//

@interface UserGroupFilters : NSObject {
}
@property (nonatomic, retain) NSMutableDictionary *filters;

// Filter for Text,Multiline,Image and HTML fields
-(void)addFilter:(UserGroupField)filterName withValue:(NSString *)value;

// Filter for Number ,Foreign-key and List fields
-(void)addFilter:(UserGroupField)filterName withIntValue:(int)value;

// Filter for Real field
-(void)addFilter:(UserGroupField)filterName withFloatValue:(float)value;

// Filter for True or False field
-(void)addFilter:(UserGroupField)filterName withBOOLValue:(BOOL)value;

// Filter for Date field
-(void)addFilter:(UserGroupField)filterName withDateValue:(NSDate *)value;

// Filter for Image field
-(void)addFilter:(UserGroupField)filterName withURLValue:(NSURL *)value;

@end



//*************
//
// UserGroupDelegate Protocol
//
// Implement this protocol when using A-Sync requests
//

@class UserGroup;
@protocol UserGroupDelegate <NSObject>;
@optional
// Optional means that you don't must to implement those methods

// Delegate method for the A-Sync add method
-(void)addUserGroupDidFinished:(int)responseType ResponseMessage:(NSString *)responseMessage withObject:(UserGroup *)object;

// Delegate method for the A-Sync update method
-(void)updateUserGroupDidFinished:(int)responseType ResponseMessage:(NSString *)responseMessage withObject:(UserGroup *)object;

// Delegate method for the A-Sync get method
-(void)getUserGroupDidFinished:(int)responseType ResponseMessage:(NSString *)responseMessage withObject:(UserGroup *)object;

// Delegate method for the A-Sync delete method
-(void)deleteUserGroupDidFinished:(int)responseType ResponseMessage:(NSString *)responseMessage withID:(int)ID;

// Delegate method for the A-Sync Get-Array method
-(void)didFinishedGetUserGroupArray:(int)responseType ResponseMessage:(NSString *)responseMessage withArray:(NSArray *)array;

// Delegate method for the A-Sync Get-Array method with request id
- (void) didFinishedGetUserGroupArray:(int)responseType ResponseMessage:(NSString *)responseMessage withArray:(NSArray *)array AndRequestID:(int)requestID;

// Delegate method for the A-Sync Upload Image method 
-(void)didFinishedUploadImage:(int)responseType ResponseMessage:(NSString *)responseMessage URLField:(UserGroupField)imageURLField withObject:(UserGroup *)object;

@end



//*************
//
// UserGroup Class
//
//

@interface UserGroup : NSObject <ACLRequestDelegate> {

}

@property (nonatomic, assign) int requestID;
@property (nonatomic, retain) id<UserGroupDelegate> delegate;
@property (nonatomic, assign) int _userGroupID;
@property (nonatomic, retain) NSString *_userGroupName;

// Initalization methods
-(id)initWithDictionary:(NSDictionary *)item;
-(id)initWithObject:(UserGroup *)object;

-(void)uploadImage:(UIImage *)image andUpdateURL:(UserGroupField)imageURLField CreateThumbnail:(BOOL)createThumbnail withDelegate:(id)_delegate sizeFactor:(float)factor;
-(NSURL *)getThumbnailUrlForFiled:(UserGroupField)field;
// ****
// Add UserGroup item to Applicasa DB
//
// A-Sync Add method (optional to implement UserGroupDelegate protocol)
+(void)addUserGroup:(UserGroup *)item withDelegate:(id)delgate;
// Sync Add method
+ (int)addUserGroup:(UserGroup *)item Error:(NSError **)error;


// ****
// Update UserGroup item in Applicasa DB
//
// A-Sync Update method by ID (optional to implement UserGroupDelegate)
+(void)updateUserGroupByID:(int)ID item:(UserGroup *)item withDelegate:(id)delgate;
//Sync Update method by ID
+(BOOL)updateUserGroupByID:(int)ID item:(UserGroup *)item Error:(NSError **)error;

// A-Sync Update method by UserGroup item (optional to implement UserGroupDelegate)
+(void)updateUserGroupByItemID:(UserGroup *)item withDelegate:(id)delgate;
//Sync Update method by UserGroup item
+(BOOL)updateUserGroupByItemID:(UserGroup *)item Error:(NSError **)error;


// ****
// Get UserGroup item from Applicasa DB
//
// A-Sync Get method (optional to implement UserGroupDelegate)
//
// A-Sync Get method
+(void)getUserGroupByID:(int)ID withDelegate:(id)delgate;
// Sync Get method
+(UserGroup *)getUserGroupByID:(int)ID Error:(NSError **)error;


// ****
// Delete UserGroup item from Applicasa DB
//
// A-Sync Delete method (optional to implement UserGroupDelegate protocol)
+(void)deleteUserGroupByID:(int)ID withDelegate:(id)delgate;
// Sync Delete method
+(BOOL)deleteUserGroupByID:(int)ID Error:(NSError **)error;

// ****
// Get UserGroup Array from Applicasa DB
// Use sortField to sort the array according the field you choosed
// Use sortType to set the sort order (Ascesnding/Descending)
// Use filters to filter the data by using an instance UserGroupFilters class
// Use pager to get specified indexes
//
// Sync Get-Array method
+(NSArray *)getUserGroupArray:(NSError **)error SortField:(UserGroupField)sortField SortType:(SortType)sortType;
// Sync Get-Array method with Filter
+(NSArray *)getUserGroupArray:(NSError **)error SortField:(UserGroupField)sortField SortType:(SortType)sortType WithFilters:(UserGroupFilters *)filters;
// Sync Get-Array method with Filter and Pager
+(NSArray *)getUserGroupArray:(NSError **)error SortField:(UserGroupField)sortField SortType:(SortType)sortType WithFilters:(UserGroupFilters *)filters AndPager:(int)page RecsPerPage:(int)recsPerPage;

// A-Sync Get-Array method (optional to implement UserGroupDelegate protocol)
+(void)getUserGroupArrayWithDelegate:(id)delegate SortField:(UserGroupField)sortField SortType:(SortType)sortType;
// A-Sync Get-Array method with Filter (optional to implement UserGroupDelegate protocol)
+ (void)getUserGroupArrayWithDelegate:(id)delegate SortField:(UserGroupField)sortField SortType:(SortType)sortType WithFilters:(UserGroupFilters *)filters;
// A-Sync Get-Array method with Filter and Pager (optional to implement UserGroupDelegate protocol)
+(void)getUserGroupArrayWithDelegate:(id)delegate SortField:(UserGroupField)sortField SortType:(SortType)sortType WithFilters:(UserGroupFilters *)filters AndPager:(int)page RecsPerPage:(int)recsPerPage;

// A-Sync Get-Array method with Filter and Pager with request id(optional to implement UserGroupDelegate protocol)
+ (void)getUserGroupArrayWithDelegate:(id)delegate SortField:(UserGroupField)sortField SortType:(SortType)sortType WithFilters:(UserGroupFilters *)filters AndPager:(int)page RecsPerPage:(int)recsPerPage AndRequestID:(int)requestID;

// Cancel requests
+ (void)cancelRequestsForDelegate:(id)delegate;

@end
