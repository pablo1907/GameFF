//
// AppUser.m
// Created by Applicasa dbGenerator
// 8/2/2012
//

#import "AppUser.h"
#import <Applicasa/ACL_UIImage+Resize.h>


#define kClassName                  @"AppUser"

#define KEY_appUserID				@"AppUserID"
#define KEY_appUserName				@"AppUserName"
#define KEY_appUserFirstName				@"AppUserFirstName"
#define KEY_appUserLastName				@"AppUserLastName"
#define KEY_appUserEmail				@"AppUserEmail"
#define KEY_appUserPassword				@"AppUserPassword"
#define KEY_appUserPushPerDay				@"AppUserPushPerDay"
#define KEY_appUserLastLogin				@"AppUserLastLogin"
#define KEY_appUserLastLoginStart				@"AppUserLastLoginStart"
#define KEY_appUserLastLoginEnd				@"AppUserLastLoginEnd"
#define KEY_appUserRegisterDate				@"AppUserRegisterDate"
#define KEY_appUserRegisterDateStart				@"AppUserRegisterDateStart"
#define KEY_appUserRegisterDateEnd				@"AppUserRegisterDateEnd"
#define KEY_appUserLastPosLatitude				@"AppUserLastPosLatitude"
#define KEY_appUserLastPosLongitude				@"AppUserLastPosLongitude"
#define KEY_appUserIsRegistered				@"AppUserIsRegistered"
#define KEY_appUserImage				@"AppUserImage"
#define KEY_appUserPoints				@"AppUserPoints"
#define KEY_appUserUserGroup				@"AppUserUserGroup"


@implementation AppUserFilters
@synthesize filters;

-(id)init {
	if (self = [super init]) {
		filters = [[NSMutableDictionary alloc] initWithDictionary:nil];
	}
	return self;
}

- (NSString *)setFilterName:(AppUserField)field{

	NSString *fieldName;
	switch (field) {
		case _AppUserID:
			fieldName = KEY_appUserID;
			break;

		case _AppUserName:
			fieldName = KEY_appUserName;
			break;

		case _AppUserFirstName:
			fieldName = KEY_appUserFirstName;
			break;

		case _AppUserLastName:
			fieldName = KEY_appUserLastName;
			break;

		case _AppUserEmail:
			fieldName = KEY_appUserEmail;
			break;

		case _AppUserPushPerDay:
			fieldName = KEY_appUserPushPerDay;
			break;

		case _AppUserLastLogin:
			fieldName = KEY_appUserLastLogin;
			break;

		case _AppUserLastLoginStartFilter:
			fieldName = KEY_appUserLastLoginStart;
			break;

		case _AppUserLastLoginEndFilter:
			fieldName = KEY_appUserLastLoginEnd;
			break;

		case _AppUserRegisterDate:
			fieldName = KEY_appUserRegisterDate;
			break;

		case _AppUserRegisterDateStartFilter:
			fieldName = KEY_appUserRegisterDateStart;
			break;

		case _AppUserRegisterDateEndFilter:
			fieldName = KEY_appUserRegisterDateEnd;
			break;

		case _AppUserLastPosLatitude:
			fieldName = KEY_appUserLastPosLatitude;
			break;

		case _AppUserLastPosLongitude:
			fieldName = KEY_appUserLastPosLongitude;
			break;

		case _AppUserIsRegistered:
			fieldName = KEY_appUserIsRegistered;
			break;

		case _AppUserImage:
			fieldName = KEY_appUserImage;
			break;

		case _AppUserPoints:
			fieldName = KEY_appUserPoints;
			break;

		case _AppUserUserGroup:
			fieldName = KEY_appUserUserGroup;
			break;

		default:
			fieldName = @"None";
			break;
	}
	return fieldName;

}

-(void)addFilter:(AppUserField)filterName withValue:(NSString *)value {
	[filters setValue:value forKey:[self setFilterName:filterName]];
}

-(void)addFilter:(AppUserField)filterName withIntValue:(int)value {
	[filters setValue:[NSString stringWithFormat:@"%d",value] forKey:[self setFilterName:filterName]];
}

-(void)addFilter:(AppUserField)filterName withFloatValue:(float)value {
	[filters setValue:[NSString stringWithFormat:@"%f",value] forKey:[self setFilterName:filterName]];
}

-(void)addFilter:(AppUserField)filterName withBOOLValue:(BOOL)value {
	if (value) {
		[filters setValue:@"true" forKey:[self setFilterName:filterName]];
	} else {
		[filters setValue:@"false" forKey:[self setFilterName:filterName]];
	}
}

-(void)addFilter:(AppUserField)filterName withDateValue:(NSDate *)value{
	switch (filterName) {
		case _AppUserLastLogin:
			[self addFilter:_AppUserLastLoginStartFilter withFloatValue:[value timeIntervalSince1970]];
			[self addFilter:_AppUserLastLoginEndFilter withFloatValue:[value timeIntervalSince1970]];
			break;
		case _AppUserRegisterDate:
			[self addFilter:_AppUserRegisterDateStartFilter withFloatValue:[value timeIntervalSince1970]];
			[self addFilter:_AppUserRegisterDateEndFilter withFloatValue:[value timeIntervalSince1970]];
			break;
		default:
			[self addFilter:filterName withFloatValue:[value timeIntervalSince1970]];
			break;
	}
	
}

-(void)addFilter:(AppUserField)filterName withURLValue:(NSURL *)value{
	[filters setValue:[value absoluteString] forKey:[self setFilterName:filterName]];
}

-(void)dealloc
{
	[filters release];
	[super dealloc];
}

@end

@interface AppUser (PrivateMethods) 

+ (NSString *)getAppUserSortField:(AppUserField)field;

+(BOOL)handleError:(NSError **)error ResponseType:(int)responseType ResponseMessage:(NSString *)responseMessage;

@end

@implementation AppUser

@synthesize requestID;
@synthesize delegate;
@synthesize _appUserID;
@synthesize _appUserName;
@synthesize _appUserFirstName;
@synthesize _appUserLastName;
@synthesize _appUserEmail;
@synthesize _appUserPassword;
@synthesize _appUserPushPerDay;
@synthesize _appUserLastLogin;
@synthesize _appUserRegisterDate;
@synthesize _appUserLastPosLatitude;
@synthesize _appUserLastPosLongitude;
@synthesize _appUserIsRegistered;
@synthesize _appUserImage;
@synthesize _appUserPoints;
@synthesize _appUserUserGroup;


+ (void)setKey{
	[Applicasa setApplicationKey:@"96dd60a64f5d968"];  
}

# pragma mark - Memory Management

-(void)dealloc
{
	[_appUserName release];
	[_appUserFirstName release];
	[_appUserLastName release];
	[_appUserEmail release];
	[_appUserPassword release];
	[_appUserLastLogin release];
	[_appUserRegisterDate release];
	[_appUserImage release];
	[_appUserUserGroup release];

	[super dealloc];
}


# pragma mark - Initialization

/*
*  init with defaults values
*/
-(id)init {
	if (self = [super init]) {

		self._appUserID				= ACL_INT_MIN;
		self._appUserName				= nil;
		self._appUserFirstName				= nil;
		self._appUserLastName				= nil;
		self._appUserEmail				= nil;
		self._appUserPassword				= nil;
		self._appUserPushPerDay				= ACL_INT_MIN;
		self._appUserLastLogin				= nil;
		self._appUserRegisterDate				= nil;
		self._appUserLastPosLatitude				= FLT_MIN;
		self._appUserLastPosLongitude				= FLT_MIN;
		_appUserIsRegistered				= 2;
		self._appUserImage				= nil;
		self._appUserPoints				= ACL_INT_MIN;
		self._appUserUserGroup				= nil;
		requestID = -1;

	}
	return self;
}


/*
*  init values from dictionary
*/
-(id)initWithDictionary:(NSDictionary *)item{
	if (self = [super init]) {

		self._appUserID               = [[item objectForKey:KEY_appUserID] integerValue];
		self._appUserName               = [item objectForKey:KEY_appUserName];
		self._appUserFirstName               = [item objectForKey:KEY_appUserFirstName];
		self._appUserLastName               = [item objectForKey:KEY_appUserLastName];
		self._appUserEmail               = [item objectForKey:KEY_appUserEmail];
		self._appUserPassword               = [item objectForKey:KEY_appUserPassword];
		self._appUserPushPerDay               = [[item objectForKey:KEY_appUserPushPerDay] integerValue];
		self._appUserLastLogin               = [ACLParser parseDateValue:[item objectForKey:KEY_appUserLastLogin]];
		self._appUserRegisterDate               = [ACLParser parseDateValue:[item objectForKey:KEY_appUserRegisterDate]];
		self._appUserLastPosLatitude               = [[item objectForKey:KEY_appUserLastPosLatitude] floatValue];
		self._appUserLastPosLongitude               = [[item objectForKey:KEY_appUserLastPosLongitude] floatValue];
		_appUserIsRegistered               = [[item objectForKey:KEY_appUserIsRegistered] boolValue];
		self._appUserImage               = [NSURL URLWithString:[item objectForKey:KEY_appUserImage]];
		self._appUserPoints               = [[item objectForKey:KEY_appUserPoints] integerValue];
		_appUserUserGroup               = [[UserGroup alloc] initWithDictionary:[item objectForKey:KEY_appUserUserGroup]];
		requestID = -1;

	}
	return self;
}

/*
*  init values from Object
*/
-(id)initWithObject:(AppUser *)object {
	if (self = [super init]) {

		self._appUserID               = object._appUserID;
		self._appUserName               = object._appUserName;
		self._appUserFirstName               = object._appUserFirstName;
		self._appUserLastName               = object._appUserLastName;
		self._appUserEmail               = object._appUserEmail;
		self._appUserPassword               = object._appUserPassword;
		self._appUserPushPerDay               = object._appUserPushPerDay;
		self._appUserLastLogin               = object._appUserLastLogin;
		self._appUserRegisterDate               = object._appUserRegisterDate;
		self._appUserLastPosLatitude               = object._appUserLastPosLatitude;
		self._appUserLastPosLongitude               = object._appUserLastPosLongitude;
		_appUserIsRegistered               = object._appUserIsRegistered;
		self._appUserImage               = object._appUserImage;
		self._appUserPoints               = object._appUserPoints;
		_appUserUserGroup               = [[UserGroup alloc] initWithObject:object._appUserUserGroup];
		requestID = -1;

	}
	return self;
}

-(void)uploadImage:(UIImage *)image andUpdateURL:(AppUserField)imageURLField CreateThumbnail:(BOOL)createThumbnail withDelegate:(id)_delegate sizeFactor:(float)factor{
	
	self.delegate = _delegate;
	switch (imageURLField) {
		case _AppUserImage:
			;
			break;
			
		default:
			if ([delegate respondsToSelector:@selector(didFinishedUploadImage:ResponseMessage:URLField:withObject:)]){
				[delegate didFinishedUploadImage:1012 ResponseMessage:@"Attempt to upload image to non-image field" URLField:imageURLField withObject:self];
		}

		return;
	}
	
	if (image==nil){
		if ([delegate respondsToSelector:@selector(didFinishedUploadImage:ResponseMessage:URLField:withObject:)]){
			[delegate didFinishedUploadImage:1009 ResponseMessage:@"Attempt To Upload nil File" URLField:imageURLField withObject:self];
		}
		return;
	}
	ACLRequest *request = [[ACLRequest alloc] init];
	request.delegate = self;
	[request setAction:@"UploadImage"];
	[request setClassName:kClassName];
	UIImage *newImage = [image applicasaResizedImage:CGSizeMake(image.size.width/factor, image.size.height/factor) interpolationQuality:5];
	
	NSData *imageData = UIImagePNGRepresentation(newImage); 
	NSString *dataStr = [imageData base64EncodedString];
	
	[request addValue:dataStr forKey:@"base64String"];
	[request addValue:@"png" forKey:@"FileType"]; 
	[request addIntValue:imageURLField forKey:@"imageURLField"]; 
	[request addBoolValue:createThumbnail forKey:@"CreateThumbnail"];
	
	[request startAsync];
	[request release];    
}


-(NSURL *)getThumbnailUrlForFiled:(AppUserField)field{

	NSURL *url=nil;

	switch (field) {
		case _AppUserImage:
			url = self._appUserImage;
			break;
			
		default:
		// error - no valid field
			return  nil;
			break;
	}

	NSString *urlString=[url absoluteString];
	urlString=[NSString stringWithFormat:@"%@_Thumbnail%@",[urlString substringToIndex:urlString.length-4],[urlString substringFromIndex:urlString.length-4]];
	return [NSURL URLWithString:urlString];
}
# pragma mark - Requests for list of objects

# pragma mark - CRUD Methods



+(void)getAppUserByID:(int)ID withDelegate:(id)delgate{
	AppUser *item = [[AppUser alloc] init];
	item._appUserID = ID;
	item.delegate = delgate;
	
	ACLRequest *request = [[ACLRequest alloc] init];
	request.delegate = item;
	[item release];
	[request setAction:@"Get"];
	[request setClassName:kClassName];
	[request addIntValue:ID forKey:@"RecordID"];
	[request startAsync];
	[request release];
}

+ (AppUser *) getAppUserByID:(int)ID Error:(NSError **)error{
	AppUser *item = nil;
	
	ACLRequest *request = [[ACLRequest alloc] init];
	[request setAction:@"Get"];
	[request setClassName:kClassName];
	[request addIntValue:ID forKey:@"RecordID"];
	
	[request startSync];
	
	NSError *responseError = nil;
	if ([AppUser handleError:&responseError ResponseType:[request responseType] ResponseMessage:[request responseMessage]]){
	
		if ([[request responseData] count] > 0) {
			item=[[[AppUser alloc] initWithDictionary:[[request responseData] objectAtIndex:0]]autorelease];
		}
	}
	[request release];
	
	if (error) {
		*error = responseError;
	}
	
	return item;
}
	
+(void)deleteAppUserByID:(int)ID withDelegate:(id)delgate {
	AppUser *item = [[AppUser alloc] init];
	item._appUserID = ID;
	item.delegate = delgate;
	
	ACLRequest *request = [[ACLRequest alloc] init];
	request.delegate = item;
	[item release];
	[request setAction:@"Delete"];
	[request setClassName:kClassName];
	[request addIntValue:ID forKey:@"RecordID"];
	[request startAsync];
	[request release];
}

+(BOOL)deleteAppUserByID:(int)ID Error:(NSError **)error{
	ACLRequest *request = [[ACLRequest alloc] init];
	[request setAction:@"Delete"];
	[request setClassName:kClassName];
	[request addIntValue:ID forKey:@"RecordID"];
	[request startSync];

	NSError *responseError = nil;
	[AppUser handleError:&responseError ResponseType:[request responseType] ResponseMessage:[request responseMessage]];
	[request release];
	
	if (error) {
		*error = responseError;
	}
	
	if (responseError)
		return NO;
	else
		return YES;
}

+ (NSString *)getAppUserSortField:(AppUserField)field {
	NSString *fieldName;
	
	switch (field) {
		case _AppUser_None:
			fieldName = @"";
			break;
	
		case _AppUserID:
			fieldName = KEY_appUserID;
			break;

		case _AppUserName:
			fieldName = KEY_appUserName;
			break;

		case _AppUserFirstName:
			fieldName = KEY_appUserFirstName;
			break;

		case _AppUserLastName:
			fieldName = KEY_appUserLastName;
			break;

		case _AppUserEmail:
			fieldName = KEY_appUserEmail;
			break;

		case _AppUserPushPerDay:
			fieldName = KEY_appUserPushPerDay;
			break;

		case _AppUserLastLogin:
			fieldName = KEY_appUserLastLogin;
			break;

		case _AppUserLastLoginStartFilter:
			fieldName = KEY_appUserLastLoginStart;
			break;

		case _AppUserLastLoginEndFilter:
			fieldName = KEY_appUserLastLoginEnd;
			break;

		case _AppUserRegisterDate:
			fieldName = KEY_appUserRegisterDate;
			break;

		case _AppUserRegisterDateStartFilter:
			fieldName = KEY_appUserRegisterDateStart;
			break;

		case _AppUserRegisterDateEndFilter:
			fieldName = KEY_appUserRegisterDateEnd;
			break;

		case _AppUserLastPosLatitude:
			fieldName = KEY_appUserLastPosLatitude;
			break;

		case _AppUserLastPosLongitude:
			fieldName = KEY_appUserLastPosLongitude;
			break;

		case _AppUserIsRegistered:
			fieldName = KEY_appUserIsRegistered;
			break;

		case _AppUserImage:
			fieldName = KEY_appUserImage;
			break;

		case _AppUserPoints:
			fieldName = KEY_appUserPoints;
			break;

		case _AppUserUserGroup:
			fieldName = KEY_appUserUserGroup;
			break;

		default:
			fieldName = @"";
			break;
	}
	
	return fieldName;
}

+(NSArray *)getAppUserArray:(NSError **)error SortField:(AppUserField)sortField SortType:(SortType)sortType{
	return [AppUser getAppUserArray:error SortField:sortField SortType:sortType WithFilters:nil AndPager:0 RecsPerPage:0];
}

+(NSArray *)getAppUserArray:(NSError **)error SortField:(AppUserField)sortField SortType:(SortType)sortType WithFilters:(AppUserFilters *)filters{
	return [AppUser getAppUserArray:error SortField:sortField SortType:sortType WithFilters:filters AndPager:0 RecsPerPage:0];
}

+(NSArray *)getAppUserArray:(NSError **)error SortField:(AppUserField)sortField SortType:(SortType)sortType WithFilters:(AppUserFilters *)filters AndPager:(int)page RecsPerPage:(int)recsPerPage{
	
	ACLRequest *request = [[[ACLRequest alloc] init] autorelease];
	
	[request setAction:@"GetArray"];
	[request setClassName:kClassName];
	[request addValue:[AppUser getAppUserSortField:sortField] forKey:@"SortField"]; 
	[request addIntValue:sortType forKey:@"SortType"];
	[request addIntValue:page forKey:@"Page"];
	[request addIntValue:recsPerPage forKey:@"RecsPerPage"];
	
	NSArray *keys = [NSArray arrayWithArray:[filters.filters allKeys]];
	for (NSString *key in keys) {
		[request addValue:[filters.filters objectForKey:key] forKey:key];
	}
	
	[request startSync];
	
	NSError *responseError = nil;
	[AppUser handleError:&responseError ResponseType:[request responseType] ResponseMessage:[request responseMessage]];
	
	if (error) {
		*error = responseError;
	}
	if (responseError) {
		return nil; 
	}
	
	NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:nil];
	for (NSDictionary *dictionary in [request responseData]) {
		AppUser *item = [[AppUser alloc] initWithDictionary:dictionary];
		[tempArray addObject:item];
		[item release];
	}
	NSArray *responseArray = [NSArray arrayWithArray:tempArray];
	[tempArray release];
	
	return responseArray;
	
}

+(void)getAppUserArrayWithDelegate:(id)delegate SortField:(AppUserField)sortField SortType:(SortType)sortType{
	[AppUser getAppUserArrayWithDelegate:delegate SortField:sortField SortType:sortType WithFilters:nil AndPager:0 RecsPerPage:0];
}

+(void)getAppUserArrayWithDelegate:(id)delegate SortField:(AppUserField)sortField SortType:(SortType)sortType WithFilters:(AppUserFilters *)filters{
	[AppUser getAppUserArrayWithDelegate:delegate SortField:sortField SortType:sortType WithFilters:filters AndPager:0 RecsPerPage:0];
}

+ (void)getAppUserArrayWithDelegate:(id)delegate SortField:(AppUserField)sortField SortType:(SortType)sortType WithFilters:(AppUserFilters *)filters AndPager:(int)page RecsPerPage:(int)recsPerPage{
	[AppUser getAppUserArrayWithDelegate:delegate SortField:sortField SortType:sortType WithFilters:filters AndPager:page RecsPerPage:recsPerPage AndRequestID:-1];
}

+ (void)getAppUserArrayWithDelegate:(id)delegate SortField:(AppUserField)sortField SortType:(SortType)sortType WithFilters:(AppUserFilters *)filters AndPager:(int)page RecsPerPage:(int)recsPerPage AndRequestID:(int)requestID {
	
	AppUser *item = [[AppUser alloc] init];
	item.requestID = requestID;
	item.delegate = delegate;
	ACLRequest *request = [[[ACLRequest alloc] init] autorelease];
	request.delegate = item;
	[item release];
	
	[request setAction:@"GetArray"];
	[request setClassName:kClassName];
	[request addValue:[AppUser getAppUserSortField:sortField] forKey:@"SortField"]; 
	[request addIntValue:sortType forKey:@"SortType"];
	[request addIntValue:page forKey:@"Page"];
	[request addIntValue:recsPerPage forKey:@"RecsPerPage"];
	
	NSArray *keys = [NSArray arrayWithArray:[filters.filters allKeys]];
	for (NSString *key in keys) {
		[request addValue:[filters.filters objectForKey:key] forKey:key];
	}
	
	[request startAsync];    
	
}

#pragma mark - Register AppUser
+(void)registerAppUserByItem:(AppUser *)item Error:(NSError **)error{
	if (!item){
		[AppUser handleError:error ResponseType:1007 ResponseMessage:@"Attempt to update nil item"];
		return;
	}
	
	if ((!item._appUserName)||(!item._appUserPassword)||[item._appUserName isEqualToString:@""]||[item._appUserPassword isEqualToString:@""]){
		[AppUser handleError:error ResponseType:1011 ResponseMessage:@"You have to register with username and password"];
		return;
	}
	NSInteger userID=[Applicasa getUserID];
	
	ACLRequest *request=[[ACLRequest alloc]init];
	[request setAction:@"Register"];
	[request setClassName:kClassName];
	[request addIntValue:userID forKey:@"RecordID"];
	[request addValue:item._appUserName forKey:KEY_appUserName];
	[request addValue:item._appUserPassword forKey:KEY_appUserPassword];
	
	if (item._appUserFirstName)
		[request addValue:item._appUserFirstName forKey:KEY_appUserFirstName];
	if (item._appUserLastName)
		[request addValue:item._appUserLastName forKey:KEY_appUserLastName];
	if (item._appUserEmail)
		[request addValue:item._appUserEmail forKey:KEY_appUserEmail];
	if (item._appUserPushPerDay > ACL_INT_MIN)
		[request addIntValue:item._appUserPushPerDay forKey:KEY_appUserPushPerDay];
	if (item._appUserLastLogin)
		[request addFloatValue:[item._appUserLastLogin timeIntervalSince1970] forKey:KEY_appUserLastLogin];
	if (item._appUserRegisterDate)
		[request addFloatValue:[item._appUserRegisterDate timeIntervalSince1970] forKey:KEY_appUserRegisterDate];
	if (item._appUserLastPosLatitude > FLT_MIN)
		[request addFloatValue:item._appUserLastPosLatitude forKey:KEY_appUserLastPosLatitude];
	if (item._appUserLastPosLongitude > FLT_MIN)
		[request addFloatValue:item._appUserLastPosLongitude forKey:KEY_appUserLastPosLongitude];
	if (item._appUserImage)
		[request addValue:item._appUserImage.absoluteString forKey:KEY_appUserImage];
	if (item._appUserPoints > ACL_INT_MIN)
		[request addIntValue:item._appUserPoints forKey:KEY_appUserPoints];
	if (item._appUserUserGroup)
		[request addIntValue:item._appUserUserGroup._userGroupID forKey:KEY_appUserUserGroup];
	[request startSync];
	
	NSError *responseError = nil;
	[AppUser handleError:&responseError ResponseType:[request responseType] ResponseMessage:[request responseMessage]];
	
	if (error) {
		*error = responseError;
	}
	[request release];
	return;
}


#pragma mark - Login Method
+(int)logInAppUserWithUserName:(NSString *)userName andPassword:(NSString *)password Error:(NSError **)error{
	
	ACLRequest *request = [[ACLRequest alloc] init];
	[request setAction:@"Login"];
	[request setClassName:kClassName];
	
	[request addValue:userName forKey:KEY_appUserName];
	[request addValue:password forKey:KEY_appUserPassword];
	
	[request startSync];
	
	NSError *responseError = nil;
	[AppUser handleError:&responseError ResponseType:[request responseType] ResponseMessage:[request responseMessage]];
	
	if (error) {
		*error = responseError;
	}
	
	if (responseError) {
		[request release];
		return ACL_INT_MIN;
	}
	
	if ([[request responseData] count] > 0) {
		NSInteger userID = [Applicasa getUserID];
		[request release];
		return userID;
	} else {
		[request release];
		return -1;
	}    
}

#pragma mark - Log Out Method

+(int)logOutCurrentAppUser:(NSError **)error{
	NSInteger userID=[Applicasa getUserID];
	
	ACLRequest *request=[[ACLRequest alloc]init];
	[request setAction:@"Logout"];
	[request setClassName:kClassName];
	[request addIntValue:userID forKey:@"RecordID"];
	[request startSync];
	
	NSError *responseError=nil;
	[AppUser handleError:&responseError ResponseType:[request responseType] ResponseMessage:[request responseMessage]];
	
	if (error){
		*error=responseError;
	}
	
	NSInteger newUserID=ACL_INT_MIN;
	if ([[request responseData]count]>0){
		newUserID=[[[[request responseData]objectAtIndex:0]objectForKey:KEY_appUserID]intValue];
	}
	[request release];
	
	return newUserID;
}

#pragma mark - Update AppUser Password
+(BOOL)updateAppUserPasswordByPassword:(NSString *)passowrd Error:(NSError **)error{
	NSInteger userID=[Applicasa getUserID];
	
	ACLRequest *request = [[ACLRequest alloc]init];
	[request setAction:@"UpdatePassword"];
	[request setClassName:kClassName];
	[request addIntValue:userID forKey:@"RecordID"];
	[request addValue:[Applicasa getUserName] forKey:KEY_appUserName];
	[request addValue:passowrd forKey:KEY_appUserPassword];
	[request startSync];
	
	NSError *responseError = nil;
	[AppUser handleError:&responseError ResponseType:[request responseType] ResponseMessage:[request responseMessage]];
	
	if (error){
		*error=responseError;
	}
	
	[request release];
	
	if (responseError){
		return FALSE;
	}else{
		return TRUE;
	}
}

+(BOOL)updateAppUserPasswordByItem:(AppUser *)item Error:(NSError **)error{
	if (!item){
		//Generate Error
		[AppUser handleError:error ResponseType:1007 ResponseMessage:@"Attempt to update nil item"];
		return FALSE;
	}
	return [AppUser updateAppUserPasswordByPassword:item._appUserPassword Error:error];
}

#pragma mark - Update AppUserName
+(BOOL)updateAppUserName:(NSString *)appUserName Password:(NSString *)password Error:(NSError **)error{
	NSInteger userID=[Applicasa getUserID];
	
	ACLRequest *request=[[ACLRequest alloc]init];
	[request setAction:@"UpdateUserName"];
	[request setClassName:kClassName];
	[request addIntValue:userID forKey:@"RecordID"];
	[request addValue:appUserName forKey:KEY_appUserName];
	[request addValue:password forKey:KEY_appUserPassword];
	[request startSync];
	
	NSError *responseError = nil;
	[AppUser handleError:&responseError ResponseType:[request responseType] ResponseMessage:[request responseMessage]];
	[request release];
	
	if (error){
		*error=responseError;
	}
	
	if (responseError){
		return FALSE;
	}else{
		return TRUE;
	}
}

+(BOOL)updateAppUserNameByItem:(AppUser *)item Error:(NSError **)error{
	if (!item){
		//Generate Error
		[AppUser handleError:error ResponseType:1007 ResponseMessage:@"Attempt to update nil item"];
		return FALSE;
	}
	return [self updateAppUserName:item._appUserName Password:item._appUserPassword Error:error];
}

#pragma mark - Update Methods

+(void)updateAppUserByItemID:(AppUser *)item withDelegate:(id)delgate{
	if (!item){
		if ([delgate respondsToSelector:@selector(updateAppUserDidFinished:ResponseMessage:withObject:)]){
			[delgate updateAppUserDidFinished:6 ResponseMessage:@"Attempt to update nil item" withObject:item];
		}
		return;
	}
	
	item.delegate = delgate;
	ACLRequest *request = [[ACLRequest alloc] init];
	request.delegate = item;
	[request setAction:@"Update"];
	[request setClassName:kClassName];
	if (item._appUserID>ACL_INT_MIN)
		[request addIntValue:item._appUserID forKey:@"RecordID"];
	
	//Parametrs Array
	
	if (item._appUserFirstName)
		[request addValue:item._appUserFirstName forKey:KEY_appUserFirstName];
	if (item._appUserLastName)
		[request addValue:item._appUserLastName forKey:KEY_appUserLastName];
	if (item._appUserEmail)
		[request addValue:item._appUserEmail forKey:KEY_appUserEmail];
	if (item._appUserPushPerDay > ACL_INT_MIN)
		[request addIntValue:item._appUserPushPerDay forKey:KEY_appUserPushPerDay];
	if (item._appUserLastLogin)
		[request addFloatValue:[item._appUserLastLogin timeIntervalSince1970] forKey:KEY_appUserLastLogin];
	if (item._appUserRegisterDate)
		[request addFloatValue:[item._appUserRegisterDate timeIntervalSince1970] forKey:KEY_appUserRegisterDate];
	if (item._appUserLastPosLatitude > FLT_MIN)
		[request addFloatValue:item._appUserLastPosLatitude forKey:KEY_appUserLastPosLatitude];
	if (item._appUserLastPosLongitude > FLT_MIN)
		[request addFloatValue:item._appUserLastPosLongitude forKey:KEY_appUserLastPosLongitude];
	if (item._appUserImage)
		[request addValue:item._appUserImage.absoluteString forKey:KEY_appUserImage];
	if (item._appUserPoints > ACL_INT_MIN)
		[request addIntValue:item._appUserPoints forKey:KEY_appUserPoints];
	if (item._appUserUserGroup)
		[request addIntValue:item._appUserUserGroup._userGroupID forKey:KEY_appUserUserGroup];
	
	[request startAsync];
	[request release];
}

+(BOOL)updateAppUserByItemID:(AppUser *)item Error:(NSError **)error{
	if (!item){
		[AppUser handleError:error ResponseType:1007 ResponseMessage:@"Attempt to update nil item"];
		return FALSE;
	}
	
	ACLRequest *request = [[ACLRequest alloc] init];
	[request setAction:@"Update"];
	[request setClassName:kClassName];
	if (item._appUserID>ACL_INT_MIN)
		[request addIntValue:item._appUserID forKey:@"RecordID"];
	
	if (item._appUserFirstName)
		[request addValue:item._appUserFirstName forKey:KEY_appUserFirstName];
	if (item._appUserLastName)
		[request addValue:item._appUserLastName forKey:KEY_appUserLastName];
	if (item._appUserEmail)
		[request addValue:item._appUserEmail forKey:KEY_appUserEmail];
	if (item._appUserPushPerDay > ACL_INT_MIN)
		[request addIntValue:item._appUserPushPerDay forKey:KEY_appUserPushPerDay];
	if (item._appUserLastLogin)
		[request addFloatValue:[item._appUserLastLogin timeIntervalSince1970] forKey:KEY_appUserLastLogin];
	if (item._appUserRegisterDate)
		[request addFloatValue:[item._appUserRegisterDate timeIntervalSince1970] forKey:KEY_appUserRegisterDate];
	if (item._appUserLastPosLatitude > FLT_MIN)
		[request addFloatValue:item._appUserLastPosLatitude forKey:KEY_appUserLastPosLatitude];
	if (item._appUserLastPosLongitude > FLT_MIN)
		[request addFloatValue:item._appUserLastPosLongitude forKey:KEY_appUserLastPosLongitude];
	if (item._appUserImage)
		[request addValue:item._appUserImage.absoluteString forKey:KEY_appUserImage];
	if (item._appUserPoints > ACL_INT_MIN)
		[request addIntValue:item._appUserPoints forKey:KEY_appUserPoints];
	if (item._appUserUserGroup)
		[request addIntValue:item._appUserUserGroup._userGroupID forKey:KEY_appUserUserGroup];
	
	[request startSync];
	
	NSError *responseError = nil;
	[AppUser handleError:&responseError ResponseType:[request responseType] ResponseMessage:[request responseMessage]];
	
	[request release];
	if (error) {
		*error = responseError;
	}
	if (responseError)
		return NO;
	else
		return YES;
}

+(void)updateAppUserLocationWithDelegate:(id)delegate{
	[Applicasa updateAppUserLocation:delegate];
}

+(void)stopUpdatingCurrentAppUserLocation{
	[Applicasa stopUpdatingUserLocation];
}

+(void)startUpdatingCurrentAppUserLocationWithDelegate:(id)delegate DesireAccuracy:(CLLocationAccuracy)desireAccuracy DistanceFilter:(CLLocationDistance)distanceFilter{
	[Applicasa setDesireAccuracy:desireAccuracy];
	[Applicasa setDistanceFilter:distanceFilter];
	[Applicasa startUpdatingUserLocationWithDelegate:delegate];
}


#pragma mark - Applicasa Delegate Methods
	
-(void)requsetDidFinished:(NSString *)action ResponseType:(NSInteger)responseType ResponseMessage:(NSString *)responseMessage responseData:(NSMutableArray *)responseData{
	if ([action isEqualToString:@"Delete"]) {
		if (![delegate respondsToSelector:@selector(deleteAppUserDidFinished:ResponseMessage:withID:)])
			return;
		[delegate deleteAppUserDidFinished:responseType ResponseMessage:responseMessage withID:[self _appUserID]];
	
	} else if ([action isEqualToString:@"Add"]) {
		if (![delegate respondsToSelector:@selector(addAppUserDidFinished:ResponseMessage:withObject:)])
			return;
		NSError *responseError = nil;
		if ([AppUser handleError:&responseError ResponseType:responseType ResponseMessage:responseMessage]){
			if ([responseData count] > 0) {
				self._appUserID = [[[responseData objectAtIndex:0] objectForKey:KEY_appUserID] intValue];
			} 
		}
		[delegate addAppUserDidFinished:responseType ResponseMessage:responseMessage withObject:self];
	} else if ([action isEqualToString:@"Update"]) {
		if (![delegate respondsToSelector:@selector(updateAppUserDidFinished:ResponseMessage:withObject:)])
			return;
		[delegate updateAppUserDidFinished:responseType ResponseMessage:responseMessage withObject:self];
	
	} else if ([action isEqualToString:@"Get"]) {
		if (![delegate respondsToSelector:@selector(getAppUserDidFinished:ResponseMessage:withObject:)])
			return;
		NSError *responseError = nil;
		if ([AppUser handleError:&responseError ResponseType:responseType ResponseMessage:responseMessage]){
			if ([responseData count] > 0) {
				AppUser *item = [[[AppUser alloc] initWithDictionary:[responseData objectAtIndex:0]] autorelease];
				[delegate getAppUserDidFinished:responseType ResponseMessage:responseMessage withObject:item];
			} else {
				[delegate getAppUserDidFinished:responseType ResponseMessage:responseMessage withObject:nil];            }
		} else {
			[delegate getAppUserDidFinished:responseType ResponseMessage:responseMessage withObject:nil];                    }
	}
	else if ([action isEqualToString:@"GetArray"]){
		NSError *responseError = nil;
		NSArray *responseArray;
		[AppUser handleError:&responseError ResponseType:responseType ResponseMessage:responseMessage];
		if (responseError) {
			responseArray=nil;
		}else{
			NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:nil];
			for (NSDictionary *dictionary in responseData) {
				AppUser *item = [[AppUser alloc] initWithDictionary:dictionary];
				[tempArray addObject:item];
				[item release];
			}
			responseArray = [NSArray arrayWithArray:tempArray];
			[tempArray release];
		}
		if (([delegate respondsToSelector:@selector(didFinishedGetAppUserArray:ResponseMessage:withArray:)])&&(requestID==-1)){
			[delegate didFinishedGetAppUserArray:responseType ResponseMessage:responseMessage withArray:responseArray];
		} 
		if (([delegate respondsToSelector:@selector(didFinishedGetAppUserArray:ResponseMessage:withArray:AndRequestID:)])&&(requestID!=-1)){
			[delegate didFinishedGetAppUserArray:responseType ResponseMessage:responseMessage withArray:responseArray AndRequestID:requestID];
		}
	}
}

-(void)uploadImageDidFinished:(int)imageURLField ResponseType:(NSInteger)responseType ResponseMessage:(NSString *)responseMessage responseData:(NSMutableArray *)responseData{
	
	// check for error
	BOOL respondToSelector=[delegate respondsToSelector:@selector(didFinishedUploadImage:ResponseMessage:URLField:withObject:)];
	NSError *responseError = nil;
	if ([AppUser handleError:&responseError ResponseType:responseType ResponseMessage:responseMessage]){
		if ([responseData count] > 0) {
		
			NSURL *finalUrl=[NSURL URLWithString:[[responseData objectAtIndex:0]objectForKey:@"ImageFullPath"]];
		
			switch (imageURLField) {
				case _AppUserImage:
					self._appUserImage =  finalUrl;
					break;
					
				default:
					// error - no valid field to update - return
					finalUrl = nil;
					break;
			}
			if ([AppUser updateAppUserByItemID:self Error:nil]) {
				if (respondToSelector){
					[delegate didFinishedUploadImage:1 ResponseMessage:@"Upload Image and Update Record Succeed" URLField:imageURLField withObject:self];  
				}
			} else {
				// generate error - upload succeed but record update failed
				if (respondToSelector){
					[delegate didFinishedUploadImage:1005 ResponseMessage:@"Upload Image Succeed\nBut Update Record Failed" URLField:imageURLField withObject:self];
				}
			}
		}  else {
			// error - no response data (no url) from server after uploading the image
			if (respondToSelector){
				[delegate didFinishedUploadImage:1006 ResponseMessage:@"Upload Image Succeed\nBut No Url Recieved" URLField:imageURLField withObject:self];
			}
		}
	}   else {
		// upload failed
		if (respondToSelector){
			[delegate didFinishedUploadImage:responseType ResponseMessage:responseMessage URLField:imageURLField withObject:self];
		}
	}
}

+(BOOL)handleError:(NSError **)error ResponseType:(int)responseType ResponseMessage:(NSString *)responseMessage{
	// error handling
	if (responseType != 1) {
		NSDictionary *details = [NSDictionary dictionaryWithObject:responseMessage forKey:NSLocalizedDescriptionKey];
		if (error){
			*error = [NSError errorWithDomain:@"Applicasa" code:responseType userInfo:details];
		}
		return NO;
	}
	return YES;
}

- (id)getObjectDelegate{
	return delegate;
}

+ (void)cancelRequestsForDelegate:(id)delegate{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"cancelRequestsForDelegate" object:delegate];
}
@end
