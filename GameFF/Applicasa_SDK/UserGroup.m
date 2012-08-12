//
// UserGroup.m
// Created by Applicasa dbGenerator
// 6/14/2012
//

#import "UserGroup.h"
#import <Applicasa/ACL_UIImage+Resize.h>


#define kClassName                  @"UserGroup"

#define KEY_userGroupID				@"UserGroupID"
#define KEY_userGroupName				@"UserGroupName"


@implementation UserGroupFilters
@synthesize filters;

-(id)init {
	if (self = [super init]) {
		filters = [[NSMutableDictionary alloc] initWithDictionary:nil];
	}
	return self;
}

- (NSString *)setFilterName:(UserGroupField)field{

	NSString *fieldName;
	switch (field) {
		case _UserGroupID:
			fieldName = KEY_userGroupID;
			break;

		case _UserGroupName:
			fieldName = KEY_userGroupName;
			break;

		default:
			fieldName = @"None";
			break;
	}
	return fieldName;

}

-(void)addFilter:(UserGroupField)filterName withValue:(NSString *)value {
	[filters setValue:value forKey:[self setFilterName:filterName]];
}

-(void)addFilter:(UserGroupField)filterName withIntValue:(int)value {
	[filters setValue:[NSString stringWithFormat:@"%d",value] forKey:[self setFilterName:filterName]];
}

-(void)addFilter:(UserGroupField)filterName withFloatValue:(float)value {
	[filters setValue:[NSString stringWithFormat:@"%f",value] forKey:[self setFilterName:filterName]];
}

-(void)addFilter:(UserGroupField)filterName withBOOLValue:(BOOL)value {
	if (value) {
		[filters setValue:@"true" forKey:[self setFilterName:filterName]];
	} else {
		[filters setValue:@"false" forKey:[self setFilterName:filterName]];
	}
}

-(void)addFilter:(UserGroupField)filterName withDateValue:(NSDate *)value{
	switch (filterName) {
		default:
			[self addFilter:filterName withFloatValue:[value timeIntervalSince1970]];
			break;
	}
	
}

-(void)addFilter:(UserGroupField)filterName withURLValue:(NSURL *)value{
	[filters setValue:[value absoluteString] forKey:[self setFilterName:filterName]];
}

-(void)dealloc
{
	[filters release];
	[super dealloc];
}

@end

@interface UserGroup (PrivateMethods) 

+ (NSString *)getUserGroupSortField:(UserGroupField)field;

+(BOOL)handleError:(NSError **)error ResponseType:(int)responseType ResponseMessage:(NSString *)responseMessage;

@end

@implementation UserGroup

@synthesize requestID;
@synthesize delegate;
@synthesize _userGroupID;
@synthesize _userGroupName;


# pragma mark - Memory Management

-(void)dealloc
{
	[_userGroupName release];

	[super dealloc];
}


# pragma mark - Initialization

/*
*  init with defaults values
*/
-(id)init {
	if (self = [super init]) {

		self._userGroupID				= ACL_INT_MIN;
		self._userGroupName				= nil;
		requestID = -1;

	}
	return self;
}


/*
*  init values from dictionary
*/
-(id)initWithDictionary:(NSDictionary *)item{
	if (self = [super init]) {

		self._userGroupID               = [[item objectForKey:KEY_userGroupID] integerValue];
		self._userGroupName               = [item objectForKey:KEY_userGroupName];
		requestID = -1;

	}
	return self;
}

/*
*  init values from Object
*/
-(id)initWithObject:(UserGroup *)object {
	if (self = [super init]) {

		self._userGroupID               = object._userGroupID;
		self._userGroupName               = object._userGroupName;
		requestID = -1;

	}
	return self;
}

-(void)uploadImage:(UIImage *)image andUpdateURL:(UserGroupField)imageURLField CreateThumbnail:(BOOL)createThumbnail withDelegate:(id)_delegate sizeFactor:(float)factor{
	
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


-(NSURL *)getThumbnailUrlForFiled:(UserGroupField)field{

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



+(void)getUserGroupByID:(int)ID withDelegate:(id)delgate{
	UserGroup *item = [[UserGroup alloc] init];
	item._userGroupID = ID;
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

+ (UserGroup *) getUserGroupByID:(int)ID Error:(NSError **)error{
	UserGroup *item = nil;
	
	ACLRequest *request = [[ACLRequest alloc] init];
	[request setAction:@"Get"];
	[request setClassName:kClassName];
	[request addIntValue:ID forKey:@"RecordID"];
	
	[request startSync];
	
	NSError *responseError = nil;
	if ([UserGroup handleError:&responseError ResponseType:[request responseType] ResponseMessage:[request responseMessage]]){
	
		if ([[request responseData] count] > 0) {
			item=[[[UserGroup alloc] initWithDictionary:[[request responseData] objectAtIndex:0]]autorelease];
		}
	}
	[request release];
	
	if (error) {
		*error = responseError;
	}
	
	return item;
}
	
+(void)deleteUserGroupByID:(int)ID withDelegate:(id)delgate {
	UserGroup *item = [[UserGroup alloc] init];
	item._userGroupID = ID;
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

+(BOOL)deleteUserGroupByID:(int)ID Error:(NSError **)error{
	ACLRequest *request = [[ACLRequest alloc] init];
	[request setAction:@"Delete"];
	[request setClassName:kClassName];
	[request addIntValue:ID forKey:@"RecordID"];
	[request startSync];

	NSError *responseError = nil;
	[UserGroup handleError:&responseError ResponseType:[request responseType] ResponseMessage:[request responseMessage]];
	[request release];
	
	if (error) {
		*error = responseError;
	}
	
	if (responseError)
		return NO;
	else
		return YES;
}

+(void)addUserGroup:(UserGroup *)item withDelegate:(id)delgate{
	item.delegate = delgate;
	ACLRequest *request = [[ACLRequest alloc] init];
	request.delegate = item;
	[request setAction:@"Add"];
	[request setClassName:kClassName];
	
	if (item._userGroupName)
		[request addValue:item._userGroupName forKey:KEY_userGroupName];
	
	[request startAsync];
	[request release];
}

+(int)addUserGroup:(UserGroup *)item Error:(NSError **)error{
	
	ACLRequest *request = [[ACLRequest alloc] init];
	[request setAction:@"Add"];
	[request setClassName:kClassName];

	if (item._userGroupName)
		[request addValue:item._userGroupName forKey:KEY_userGroupName];
	
	[request startSync];
	
	NSError *responseError = nil;
	if ([UserGroup handleError:&responseError ResponseType:[request responseType] ResponseMessage:[request responseMessage]]){
		if ([[request responseData] count] > 0) {
			item._userGroupID = [[[[request responseData] objectAtIndex:0] objectForKey:KEY_userGroupID]intValue];
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
		return item._userGroupID;
}

+(void)updateUserGroupByID:(int)ID item:(UserGroup *)item withDelegate:(id)delgate{
	if (!item){
		item=[[[UserGroup alloc]init]autorelease];
	}
	item._userGroupID = ID;
	[UserGroup updateUserGroupByItemID:item withDelegate:delgate];
}

+(BOOL)updateUserGroupByID:(int)ID item:(UserGroup *)item Error:(NSError **)error{
	if (!item){
		item=[[[UserGroup alloc]init]autorelease];
	}
	item._userGroupID = ID;
	return [UserGroup updateUserGroupByItemID:item Error:error];
}

+(void)updateUserGroupByItemID:(UserGroup *)item withDelegate:(id)delgate{
	
	item.delegate = delgate;
	ACLRequest *request = [[ACLRequest alloc] init];
	request.delegate = item;    [request setAction:@"Update"];
	[request setClassName:kClassName];
	
	if (item._userGroupID == ACL_INT_MIN) {
		return;
	} else {
		[request addIntValue:item._userGroupID forKey:@"RecordID"];
	}

	if (item._userGroupName)
		[request addValue:item._userGroupName forKey:KEY_userGroupName];
	

	[request startAsync];
	[request release];
}

+(BOOL)updateUserGroupByItemID:(UserGroup *)item Error:(NSError **)error{
	
	ACLRequest *request = [[ACLRequest alloc] init];
	[request setAction:@"Update"];
	[request setClassName:kClassName];
	
	if (item._userGroupID == ACL_INT_MIN) {
		[request release];
		return NO;
	} else {
		[request addIntValue:item._userGroupID forKey:@"RecordID"];
	}

	if (item._userGroupName)
		[request addValue:item._userGroupName forKey:KEY_userGroupName];
	

	[request startSync];
	
	NSError *responseError = nil;
	[UserGroup handleError:&responseError ResponseType:[request responseType] ResponseMessage:[request responseMessage]];
	
	[request release];

	if (error) {
		*error = responseError;
	}

	if (responseError)
		return NO; 
	else
		return YES;
}

+ (NSString *)getUserGroupSortField:(UserGroupField)field {
	NSString *fieldName;
	
	switch (field) {
		case _UserGroup_None:
			fieldName = @"";
			break;
	
		case _UserGroupID:
			fieldName = KEY_userGroupID;
			break;

		case _UserGroupName:
			fieldName = KEY_userGroupName;
			break;

		default:
			fieldName = @"";
			break;
	}
	
	return fieldName;
}

+(NSArray *)getUserGroupArray:(NSError **)error SortField:(UserGroupField)sortField SortType:(SortType)sortType{
	return [UserGroup getUserGroupArray:error SortField:sortField SortType:sortType WithFilters:nil AndPager:0 RecsPerPage:0];
}

+(NSArray *)getUserGroupArray:(NSError **)error SortField:(UserGroupField)sortField SortType:(SortType)sortType WithFilters:(UserGroupFilters *)filters{
	return [UserGroup getUserGroupArray:error SortField:sortField SortType:sortType WithFilters:filters AndPager:0 RecsPerPage:0];
}

+(NSArray *)getUserGroupArray:(NSError **)error SortField:(UserGroupField)sortField SortType:(SortType)sortType WithFilters:(UserGroupFilters *)filters AndPager:(int)page RecsPerPage:(int)recsPerPage{
	
	ACLRequest *request = [[[ACLRequest alloc] init] autorelease];
	
	[request setAction:@"GetArray"];
	[request setClassName:kClassName];
	[request addValue:[UserGroup getUserGroupSortField:sortField] forKey:@"SortField"]; 
	[request addIntValue:sortType forKey:@"SortType"];
	[request addIntValue:page forKey:@"Page"];
	[request addIntValue:recsPerPage forKey:@"RecsPerPage"];
	
	NSArray *keys = [NSArray arrayWithArray:[filters.filters allKeys]];
	for (NSString *key in keys) {
		[request addValue:[filters.filters objectForKey:key] forKey:key];
	}
	
	[request startSync];
	
	NSError *responseError = nil;
	[UserGroup handleError:&responseError ResponseType:[request responseType] ResponseMessage:[request responseMessage]];
	
	if (error) {
		*error = responseError;
	}
	if (responseError) {
		return nil; 
	}
	
	NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:nil];
	for (NSDictionary *dictionary in [request responseData]) {
		UserGroup *item = [[UserGroup alloc] initWithDictionary:dictionary];
		[tempArray addObject:item];
		[item release];
	}
	NSArray *responseArray = [NSArray arrayWithArray:tempArray];
	[tempArray release];
	
	return responseArray;
	
}

+(void)getUserGroupArrayWithDelegate:(id)delegate SortField:(UserGroupField)sortField SortType:(SortType)sortType{
	[UserGroup getUserGroupArrayWithDelegate:delegate SortField:sortField SortType:sortType WithFilters:nil AndPager:0 RecsPerPage:0];
}

+(void)getUserGroupArrayWithDelegate:(id)delegate SortField:(UserGroupField)sortField SortType:(SortType)sortType WithFilters:(UserGroupFilters *)filters{
	[UserGroup getUserGroupArrayWithDelegate:delegate SortField:sortField SortType:sortType WithFilters:filters AndPager:0 RecsPerPage:0];
}

+ (void)getUserGroupArrayWithDelegate:(id)delegate SortField:(UserGroupField)sortField SortType:(SortType)sortType WithFilters:(UserGroupFilters *)filters AndPager:(int)page RecsPerPage:(int)recsPerPage{
	[UserGroup getUserGroupArrayWithDelegate:delegate SortField:sortField SortType:sortType WithFilters:filters AndPager:page RecsPerPage:recsPerPage AndRequestID:-1];
}

+ (void)getUserGroupArrayWithDelegate:(id)delegate SortField:(UserGroupField)sortField SortType:(SortType)sortType WithFilters:(UserGroupFilters *)filters AndPager:(int)page RecsPerPage:(int)recsPerPage AndRequestID:(int)requestID {
	
	UserGroup *item = [[UserGroup alloc] init];
	item.requestID = requestID;
	item.delegate = delegate;
	ACLRequest *request = [[[ACLRequest alloc] init] autorelease];
	request.delegate = item;
	[item release];
	
	[request setAction:@"GetArray"];
	[request setClassName:kClassName];
	[request addValue:[UserGroup getUserGroupSortField:sortField] forKey:@"SortField"]; 
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
		if (![delegate respondsToSelector:@selector(deleteUserGroupDidFinished:ResponseMessage:withID:)])
			return;
		[delegate deleteUserGroupDidFinished:responseType ResponseMessage:responseMessage withID:[self _userGroupID]];
	
	} else if ([action isEqualToString:@"Add"]) {
		if (![delegate respondsToSelector:@selector(addUserGroupDidFinished:ResponseMessage:withObject:)])
			return;
		NSError *responseError = nil;
		if ([UserGroup handleError:&responseError ResponseType:responseType ResponseMessage:responseMessage]){
			if ([responseData count] > 0) {
				self._userGroupID = [[[responseData objectAtIndex:0] objectForKey:KEY_userGroupID] intValue];
			} 
		}
		[delegate addUserGroupDidFinished:responseType ResponseMessage:responseMessage withObject:self];
	} else if ([action isEqualToString:@"Update"]) {
		if (![delegate respondsToSelector:@selector(updateUserGroupDidFinished:ResponseMessage:withObject:)])
			return;
		[delegate updateUserGroupDidFinished:responseType ResponseMessage:responseMessage withObject:self];
	
	} else if ([action isEqualToString:@"Get"]) {
		if (![delegate respondsToSelector:@selector(getUserGroupDidFinished:ResponseMessage:withObject:)])
			return;
		NSError *responseError = nil;
		if ([UserGroup handleError:&responseError ResponseType:responseType ResponseMessage:responseMessage]){
			if ([responseData count] > 0) {
				UserGroup *item = [[[UserGroup alloc] initWithDictionary:[responseData objectAtIndex:0]] autorelease];
				[delegate getUserGroupDidFinished:responseType ResponseMessage:responseMessage withObject:item];
			} else {
				[delegate getUserGroupDidFinished:responseType ResponseMessage:responseMessage withObject:nil];            }
		} else {
			[delegate getUserGroupDidFinished:responseType ResponseMessage:responseMessage withObject:nil];                    }
	}
	else if ([action isEqualToString:@"GetArray"]){
		NSError *responseError = nil;
		NSArray *responseArray;
		[UserGroup handleError:&responseError ResponseType:responseType ResponseMessage:responseMessage];
		if (responseError) {
			responseArray=nil;
		}else{
			NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:nil];
			for (NSDictionary *dictionary in responseData) {
				UserGroup *item = [[UserGroup alloc] initWithDictionary:dictionary];
				[tempArray addObject:item];
				[item release];
			}
			responseArray = [NSArray arrayWithArray:tempArray];
			[tempArray release];
		}
		if (([delegate respondsToSelector:@selector(didFinishedGetUserGroupArray:ResponseMessage:withArray:)])&&(requestID==-1)){
			[delegate didFinishedGetUserGroupArray:responseType ResponseMessage:responseMessage withArray:responseArray];
		} 
		if (([delegate respondsToSelector:@selector(didFinishedGetUserGroupArray:ResponseMessage:withArray:AndRequestID:)])&&(requestID!=-1)){
			[delegate didFinishedGetUserGroupArray:responseType ResponseMessage:responseMessage withArray:responseArray AndRequestID:requestID];
		}
	}
}

-(void)uploadImageDidFinished:(int)imageURLField ResponseType:(NSInteger)responseType ResponseMessage:(NSString *)responseMessage responseData:(NSMutableArray *)responseData{
	
	// check for error
	BOOL respondToSelector=[delegate respondsToSelector:@selector(didFinishedUploadImage:ResponseMessage:URLField:withObject:)];
	NSError *responseError = nil;
	if ([UserGroup handleError:&responseError ResponseType:responseType ResponseMessage:responseMessage]){
		if ([responseData count] > 0) {
		
			NSURL *finalUrl = [NSURL URLWithString:[[responseData objectAtIndex:0]objectForKey:@"ImageFullPath"]];
		
			switch (imageURLField) {
				default:
					// error - no valid field to update - return
					finalUrl = nil;
					break;
			}
			if ([UserGroup updateUserGroupByItemID:self Error:nil]) {
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
