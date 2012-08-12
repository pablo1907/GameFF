//
// UserRelationship.m
// Created by Applicasa dbGenerator
// 8/2/2012
//

#import "UserRelationship.h"
#import <Applicasa/ACL_UIImage+Resize.h>


#define kClassName                  @"UserRelationship"

#define KEY_userRelationshipID				@"UserRelationshipID"
#define KEY_userRelationshipType				@"UserRelationshipType"
#define KEY_userRelationshipFriendID				@"UserRelationshipFriendID"
#define KEY_userRelationshipUserID				@"UserRelationshipUserID"


@implementation UserRelationshipFilters
@synthesize filters;

-(id)init {
	if (self = [super init]) {
		filters = [[NSMutableDictionary alloc] initWithDictionary:nil];
	}
	return self;
}

- (NSString *)setFilterName:(UserRelationshipField)field{

	NSString *fieldName;
	switch (field) {
		case _UserRelationshipID:
			fieldName = KEY_userRelationshipID;
			break;

		case _UserRelationshipType:
			fieldName = KEY_userRelationshipType;
			break;

		case _UserRelationshipFriendID:
			fieldName = KEY_userRelationshipFriendID;
			break;

		case _UserRelationshipUserID:
			fieldName = KEY_userRelationshipUserID;
			break;

		default:
			fieldName = @"None";
			break;
	}
	return fieldName;

}

-(void)addFilter:(UserRelationshipField)filterName withValue:(NSString *)value {
	[filters setValue:value forKey:[self setFilterName:filterName]];
}

-(void)addFilter:(UserRelationshipField)filterName withIntValue:(int)value {
	[filters setValue:[NSString stringWithFormat:@"%d",value] forKey:[self setFilterName:filterName]];
}

-(void)addFilter:(UserRelationshipField)filterName withFloatValue:(float)value {
	[filters setValue:[NSString stringWithFormat:@"%f",value] forKey:[self setFilterName:filterName]];
}

-(void)addFilter:(UserRelationshipField)filterName withBOOLValue:(BOOL)value {
	if (value) {
		[filters setValue:@"true" forKey:[self setFilterName:filterName]];
	} else {
		[filters setValue:@"false" forKey:[self setFilterName:filterName]];
	}
}

-(void)addFilter:(UserRelationshipField)filterName withDateValue:(NSDate *)value{
	switch (filterName) {
		default:
			[self addFilter:filterName withFloatValue:[value timeIntervalSince1970]];
			break;
	}
	
}

-(void)addFilter:(UserRelationshipField)filterName withURLValue:(NSURL *)value{
	[filters setValue:[value absoluteString] forKey:[self setFilterName:filterName]];
}

-(void)dealloc
{
	[filters release];
	[super dealloc];
}

@end

@interface UserRelationship (PrivateMethods) 

+ (NSString *)getUserRelationshipSortField:(UserRelationshipField)field;

+(BOOL)handleError:(NSError **)error ResponseType:(int)responseType ResponseMessage:(NSString *)responseMessage;

@end

@implementation UserRelationship

@synthesize requestID;
@synthesize delegate;
@synthesize _userRelationshipID;
@synthesize _userRelationshipType;
@synthesize _userRelationshipFriendID;
@synthesize _userRelationshipUserID;


# pragma mark - Memory Management

-(void)dealloc
{
	[_userRelationshipType release];
	[_userRelationshipFriendID release];
	[_userRelationshipUserID release];

	[super dealloc];
}


# pragma mark - Initialization

/*
*  init with defaults values
*/
-(id)init {
	if (self = [super init]) {

		self._userRelationshipID				= ACL_INT_MIN;
		self._userRelationshipType				= nil;
		self._userRelationshipFriendID				= nil;
		self._userRelationshipUserID				= nil;
		requestID = -1;

	}
	return self;
}


/*
*  init values from dictionary
*/
-(id)initWithDictionary:(NSDictionary *)item{
	if (self = [super init]) {

		self._userRelationshipID               = [[item objectForKey:KEY_userRelationshipID] integerValue];
		self._userRelationshipType               = [item objectForKey:KEY_userRelationshipType];
		_userRelationshipFriendID               = [[AppUser alloc] initWithDictionary:[item objectForKey:KEY_userRelationshipFriendID]];
		_userRelationshipUserID               = [[AppUser alloc] initWithDictionary:[item objectForKey:KEY_userRelationshipUserID]];
		requestID = -1;

	}
	return self;
}

/*
*  init values from Object
*/
-(id)initWithObject:(UserRelationship *)object {
	if (self = [super init]) {

		self._userRelationshipID               = object._userRelationshipID;
		self._userRelationshipType               = object._userRelationshipType;
		_userRelationshipFriendID               = [[AppUser alloc] initWithObject:object._userRelationshipFriendID];
		_userRelationshipUserID               = [[AppUser alloc] initWithObject:object._userRelationshipUserID];
		requestID = -1;

	}
	return self;
}

-(void)uploadImage:(UIImage *)image andUpdateURL:(UserRelationshipField)imageURLField CreateThumbnail:(BOOL)createThumbnail withDelegate:(id)_delegate sizeFactor:(float)factor{
	
	self.delegate = _delegate;
	switch (imageURLField) {
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


-(NSURL *)getThumbnailUrlForFiled:(UserRelationshipField)field{

	NSURL *url=nil;

	switch (field) {
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



+(void)getUserRelationshipByID:(int)ID withDelegate:(id)delgate{
	UserRelationship *item = [[UserRelationship alloc] init];
	item._userRelationshipID = ID;
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

+ (UserRelationship *) getUserRelationshipByID:(int)ID Error:(NSError **)error{
	UserRelationship *item = nil;
	
	ACLRequest *request = [[ACLRequest alloc] init];
	[request setAction:@"Get"];
	[request setClassName:kClassName];
	[request addIntValue:ID forKey:@"RecordID"];
	
	[request startSync];
	
	NSError *responseError = nil;
	if ([UserRelationship handleError:&responseError ResponseType:[request responseType] ResponseMessage:[request responseMessage]]){
	
		if ([[request responseData] count] > 0) {
			item=[[[UserRelationship alloc] initWithDictionary:[[request responseData] objectAtIndex:0]]autorelease];
		}
	}
	[request release];
	
	if (error) {
		*error = responseError;
	}
	
	return item;
}
	
+(void)deleteUserRelationshipByID:(int)ID withDelegate:(id)delgate {
	UserRelationship *item = [[UserRelationship alloc] init];
	item._userRelationshipID = ID;
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

+(BOOL)deleteUserRelationshipByID:(int)ID Error:(NSError **)error{
	ACLRequest *request = [[ACLRequest alloc] init];
	[request setAction:@"Delete"];
	[request setClassName:kClassName];
	[request addIntValue:ID forKey:@"RecordID"];
	[request startSync];

	NSError *responseError = nil;
	[UserRelationship handleError:&responseError ResponseType:[request responseType] ResponseMessage:[request responseMessage]];
	[request release];
	
	if (error) {
		*error = responseError;
	}
	
	if (responseError)
		return NO;
	else
		return YES;
}

+(void)addUserRelationship:(UserRelationship *)item withDelegate:(id)delgate{
	item.delegate = delgate;
	ACLRequest *request = [[ACLRequest alloc] init];
	request.delegate = item;
	[request setAction:@"Add"];
	[request setClassName:kClassName];
	
	if (item._userRelationshipType)
		[request addValue:item._userRelationshipType forKey:KEY_userRelationshipType];
	if (item._userRelationshipFriendID)
		[request addIntValue:item._userRelationshipFriendID._appUserID forKey:KEY_userRelationshipFriendID];
	if (item._userRelationshipUserID)
		[request addIntValue:item._userRelationshipUserID._appUserID forKey:KEY_userRelationshipUserID];
	
	[request startAsync];
	[request release];
}

+(int)addUserRelationship:(UserRelationship *)item Error:(NSError **)error{
	
	ACLRequest *request = [[ACLRequest alloc] init];
	[request setAction:@"Add"];
	[request setClassName:kClassName];

	if (item._userRelationshipType)
		[request addValue:item._userRelationshipType forKey:KEY_userRelationshipType];
	if (item._userRelationshipFriendID)
		[request addIntValue:item._userRelationshipFriendID._appUserID forKey:KEY_userRelationshipFriendID];
	if (item._userRelationshipUserID)
		[request addIntValue:item._userRelationshipUserID._appUserID forKey:KEY_userRelationshipUserID];
	
	[request startSync];
	
	NSError *responseError = nil;
	if ([UserRelationship handleError:&responseError ResponseType:[request responseType] ResponseMessage:[request responseMessage]]){
		if ([[request responseData] count] > 0) {
			item._userRelationshipID = [[[[request responseData] objectAtIndex:0] objectForKey:KEY_userRelationshipID]intValue];
		}
	}

	[request release];
	if (error) {
		*error = responseError;
	}

	if (responseError) { 
		return ACL_INT_MIN;
	}
	else
		return item._userRelationshipID;
}

+(void)updateUserRelationshipByID:(int)ID item:(UserRelationship *)item withDelegate:(id)delgate{
	if (!item){
		item=[[[UserRelationship alloc]init]autorelease];
	}
	item._userRelationshipID = ID;
	[UserRelationship updateUserRelationshipByItemID:item withDelegate:delgate];
}

+(BOOL)updateUserRelationshipByID:(int)ID item:(UserRelationship *)item Error:(NSError **)error{
	if (!item){
		item=[[[UserRelationship alloc]init]autorelease];
	}
	item._userRelationshipID = ID;
	return [UserRelationship updateUserRelationshipByItemID:item Error:error];
}

+(void)updateUserRelationshipByItemID:(UserRelationship *)item withDelegate:(id)delgate{
	
	item.delegate = delgate;
	ACLRequest *request = [[ACLRequest alloc] init];
	request.delegate = item;    [request setAction:@"Update"];
	[request setClassName:kClassName];
	
	if (item._userRelationshipID == ACL_INT_MIN) {
		return;
	} else {
		[request addIntValue:item._userRelationshipID forKey:@"RecordID"];
	}

	if (item._userRelationshipType)
		[request addValue:item._userRelationshipType forKey:KEY_userRelationshipType];
	if (item._userRelationshipFriendID)
		[request addIntValue:item._userRelationshipFriendID._appUserID forKey:KEY_userRelationshipFriendID];
	if (item._userRelationshipUserID)
		[request addIntValue:item._userRelationshipUserID._appUserID forKey:KEY_userRelationshipUserID];
	

	[request startAsync];
	[request release];
}

+(BOOL)updateUserRelationshipByItemID:(UserRelationship *)item Error:(NSError **)error{
	
	ACLRequest *request = [[ACLRequest alloc] init];
	[request setAction:@"Update"];
	[request setClassName:kClassName];
	
	if (item._userRelationshipID == ACL_INT_MIN) {
		[request release];
		return NO;
	} else {
		[request addIntValue:item._userRelationshipID forKey:@"RecordID"];
	}

	if (item._userRelationshipType)
		[request addValue:item._userRelationshipType forKey:KEY_userRelationshipType];
	if (item._userRelationshipFriendID)
		[request addIntValue:item._userRelationshipFriendID._appUserID forKey:KEY_userRelationshipFriendID];
	if (item._userRelationshipUserID)
		[request addIntValue:item._userRelationshipUserID._appUserID forKey:KEY_userRelationshipUserID];
	

	[request startSync];
	
	NSError *responseError = nil;
	[UserRelationship handleError:&responseError ResponseType:[request responseType] ResponseMessage:[request responseMessage]];
	
	[request release];

	if (error) {
		*error = responseError;
	}

	if (responseError)
		return NO; 
	else
		return YES;
}

+ (NSString *)getUserRelationshipSortField:(UserRelationshipField)field {
	NSString *fieldName;
	
	switch (field) {
		case _UserRelationship_None:
			fieldName = @"";
			break;
	
		case _UserRelationshipID:
			fieldName = KEY_userRelationshipID;
			break;

		case _UserRelationshipType:
			fieldName = KEY_userRelationshipType;
			break;

		case _UserRelationshipFriendID:
			fieldName = KEY_userRelationshipFriendID;
			break;

		case _UserRelationshipUserID:
			fieldName = KEY_userRelationshipUserID;
			break;

		default:
			fieldName = @"";
			break;
	}
	
	return fieldName;
}

+(NSArray *)getUserRelationshipArray:(NSError **)error SortField:(UserRelationshipField)sortField SortType:(SortType)sortType{
	return [UserRelationship getUserRelationshipArray:error SortField:sortField SortType:sortType WithFilters:nil AndPager:0 RecsPerPage:0];
}

+(NSArray *)getUserRelationshipArray:(NSError **)error SortField:(UserRelationshipField)sortField SortType:(SortType)sortType WithFilters:(UserRelationshipFilters *)filters{
	return [UserRelationship getUserRelationshipArray:error SortField:sortField SortType:sortType WithFilters:filters AndPager:0 RecsPerPage:0];
}

+(NSArray *)getUserRelationshipArray:(NSError **)error SortField:(UserRelationshipField)sortField SortType:(SortType)sortType WithFilters:(UserRelationshipFilters *)filters AndPager:(int)page RecsPerPage:(int)recsPerPage{
	
	ACLRequest *request = [[[ACLRequest alloc] init] autorelease];
	
	[request setAction:@"GetArray"];
	[request setClassName:kClassName];
	[request addValue:[UserRelationship getUserRelationshipSortField:sortField] forKey:@"SortField"]; 
	[request addIntValue:sortType forKey:@"SortType"];
	[request addIntValue:page forKey:@"Page"];
	[request addIntValue:recsPerPage forKey:@"RecsPerPage"];
	
	NSArray *keys = [NSArray arrayWithArray:[filters.filters allKeys]];
	for (NSString *key in keys) {
		[request addValue:[filters.filters objectForKey:key] forKey:key];
	}
	
	[request startSync];
	
	NSError *responseError = nil;
	[UserRelationship handleError:&responseError ResponseType:[request responseType] ResponseMessage:[request responseMessage]];
	
	if (error) {
		*error = responseError;
	}
	if (responseError) {
		return nil; 
	}
	
	NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:nil];
	for (NSDictionary *dictionary in [request responseData]) {
		UserRelationship *item = [[UserRelationship alloc] initWithDictionary:dictionary];
		[tempArray addObject:item];
		[item release];
	}
	NSArray *responseArray = [NSArray arrayWithArray:tempArray];
	[tempArray release];
	
	return responseArray;
	
}

+(void)getUserRelationshipArrayWithDelegate:(id)delegate SortField:(UserRelationshipField)sortField SortType:(SortType)sortType{
	[UserRelationship getUserRelationshipArrayWithDelegate:delegate SortField:sortField SortType:sortType WithFilters:nil AndPager:0 RecsPerPage:0];
}

+(void)getUserRelationshipArrayWithDelegate:(id)delegate SortField:(UserRelationshipField)sortField SortType:(SortType)sortType WithFilters:(UserRelationshipFilters *)filters{
	[UserRelationship getUserRelationshipArrayWithDelegate:delegate SortField:sortField SortType:sortType WithFilters:filters AndPager:0 RecsPerPage:0];
}

+ (void)getUserRelationshipArrayWithDelegate:(id)delegate SortField:(UserRelationshipField)sortField SortType:(SortType)sortType WithFilters:(UserRelationshipFilters *)filters AndPager:(int)page RecsPerPage:(int)recsPerPage{
	[UserRelationship getUserRelationshipArrayWithDelegate:delegate SortField:sortField SortType:sortType WithFilters:filters AndPager:page RecsPerPage:recsPerPage AndRequestID:-1];
}

+ (void)getUserRelationshipArrayWithDelegate:(id)delegate SortField:(UserRelationshipField)sortField SortType:(SortType)sortType WithFilters:(UserRelationshipFilters *)filters AndPager:(int)page RecsPerPage:(int)recsPerPage AndRequestID:(int)requestID {
	
	UserRelationship *item = [[UserRelationship alloc] init];
	item.requestID = requestID;
	item.delegate = delegate;
	ACLRequest *request = [[[ACLRequest alloc] init] autorelease];
	request.delegate = item;
	[item release];
	
	[request setAction:@"GetArray"];
	[request setClassName:kClassName];
	[request addValue:[UserRelationship getUserRelationshipSortField:sortField] forKey:@"SortField"]; 
	[request addIntValue:sortType forKey:@"SortType"];
	[request addIntValue:page forKey:@"Page"];
	[request addIntValue:recsPerPage forKey:@"RecsPerPage"];
	
	NSArray *keys = [NSArray arrayWithArray:[filters.filters allKeys]];
	for (NSString *key in keys) {
		[request addValue:[filters.filters objectForKey:key] forKey:key];
	}
	
	[request startAsync];    
	
}

#pragma mark - Applicasa Delegate Methods
	
-(void)requsetDidFinished:(NSString *)action ResponseType:(NSInteger)responseType ResponseMessage:(NSString *)responseMessage responseData:(NSMutableArray *)responseData{
	if ([action isEqualToString:@"Delete"]) {
		if (![delegate respondsToSelector:@selector(deleteUserRelationshipDidFinished:ResponseMessage:withID:)])
			return;
		[delegate deleteUserRelationshipDidFinished:responseType ResponseMessage:responseMessage withID:[self _userRelationshipID]];
	
	} else if ([action isEqualToString:@"Add"]) {
		if (![delegate respondsToSelector:@selector(addUserRelationshipDidFinished:ResponseMessage:withObject:)])
			return;
		NSError *responseError = nil;
		if ([UserRelationship handleError:&responseError ResponseType:responseType ResponseMessage:responseMessage]){
			if ([responseData count] > 0) {
				self._userRelationshipID = [[[responseData objectAtIndex:0] objectForKey:KEY_userRelationshipID] intValue];
			} 
		}
		[delegate addUserRelationshipDidFinished:responseType ResponseMessage:responseMessage withObject:self];
	} else if ([action isEqualToString:@"Update"]) {
		if (![delegate respondsToSelector:@selector(updateUserRelationshipDidFinished:ResponseMessage:withObject:)])
			return;
		[delegate updateUserRelationshipDidFinished:responseType ResponseMessage:responseMessage withObject:self];
	
	} else if ([action isEqualToString:@"Get"]) {
		if (![delegate respondsToSelector:@selector(getUserRelationshipDidFinished:ResponseMessage:withObject:)])
			return;
		NSError *responseError = nil;
		if ([UserRelationship handleError:&responseError ResponseType:responseType ResponseMessage:responseMessage]){
			if ([responseData count] > 0) {
				UserRelationship *item = [[[UserRelationship alloc] initWithDictionary:[responseData objectAtIndex:0]] autorelease];
				[delegate getUserRelationshipDidFinished:responseType ResponseMessage:responseMessage withObject:item];
			} else {
				[delegate getUserRelationshipDidFinished:responseType ResponseMessage:responseMessage withObject:nil];            }
		} else {
			[delegate getUserRelationshipDidFinished:responseType ResponseMessage:responseMessage withObject:nil];                    }
	}
	else if ([action isEqualToString:@"GetArray"]){
		NSError *responseError = nil;
		NSArray *responseArray;
		[UserRelationship handleError:&responseError ResponseType:responseType ResponseMessage:responseMessage];
		if (responseError) {
			responseArray=nil;
		}else{
			NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:nil];
			for (NSDictionary *dictionary in responseData) {
				UserRelationship *item = [[UserRelationship alloc] initWithDictionary:dictionary];
				[tempArray addObject:item];
				[item release];
			}
			responseArray = [NSArray arrayWithArray:tempArray];
			[tempArray release];
		}
		if (([delegate respondsToSelector:@selector(didFinishedGetUserRelationshipArray:ResponseMessage:withArray:)])&&(requestID==-1)){
			[delegate didFinishedGetUserRelationshipArray:responseType ResponseMessage:responseMessage withArray:responseArray];
		} 
		if (([delegate respondsToSelector:@selector(didFinishedGetUserRelationshipArray:ResponseMessage:withArray:AndRequestID:)])&&(requestID!=-1)){
			[delegate didFinishedGetUserRelationshipArray:responseType ResponseMessage:responseMessage withArray:responseArray AndRequestID:requestID];
		}
	}
}

-(void)uploadImageDidFinished:(int)imageURLField ResponseType:(NSInteger)responseType ResponseMessage:(NSString *)responseMessage responseData:(NSMutableArray *)responseData{
	
	// check for error
	BOOL respondToSelector=[delegate respondsToSelector:@selector(didFinishedUploadImage:ResponseMessage:URLField:withObject:)];
	NSError *responseError = nil;
	if ([UserRelationship handleError:&responseError ResponseType:responseType ResponseMessage:responseMessage]){
		if ([responseData count] > 0) {
		
			NSURL *finalUrl=[NSURL URLWithString:[[responseData objectAtIndex:0]objectForKey:@"ImageFullPath"]];
		
			switch (imageURLField) {
				default:
					// error - no valid field to update - return
					finalUrl = nil;
					break;
			}
			if ([UserRelationship updateUserRelationshipByItemID:self Error:nil]) {
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
