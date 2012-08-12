//
// Game.m
// Created by Applicasa dbGenerator
// 8/6/2012
//

#import "Game.h"
#import <Applicasa/ACL_UIImage+Resize.h>


#define kClassName                  @"Game"

#define KEY_gameID				@"GameID"
#define KEY_gameImage				@"GameImage"
#define KEY_gameAnswer				@"GameAnswer"
#define KEY_gameStreak				@"GameStreak"
#define KEY_gameMode				@"GameMode"
#define KEY_gameStatus				@"GameStatus"
#define KEY_gameFirstPlayer				@"GameFirstPlayer"
#define KEY_gameSecondPlayer				@"GameSecondPlayer"


@implementation GameFilters
@synthesize filters;

-(id)init {
	if (self = [super init]) {
		filters = [[NSMutableDictionary alloc] initWithDictionary:nil];
	}
	return self;
}

- (NSString *)setFilterName:(GameField)field{

	NSString *fieldName;
	switch (field) {
		case _GameID:
			fieldName = KEY_gameID;
			break;

		case _GameImage:
			fieldName = KEY_gameImage;
			break;

		case _GameAnswer:
			fieldName = KEY_gameAnswer;
			break;

		case _GameStreak:
			fieldName = KEY_gameStreak;
			break;

		case _GameMode:
			fieldName = KEY_gameMode;
			break;

		case _GameStatus:
			fieldName = KEY_gameStatus;
			break;

		case _GameFirstPlayer:
			fieldName = KEY_gameFirstPlayer;
			break;

		case _GameSecondPlayer:
			fieldName = KEY_gameSecondPlayer;
			break;

		default:
			fieldName = @"None";
			break;
	}
	return fieldName;

}

-(void)addFilter:(GameField)filterName withValue:(NSString *)value {
	[filters setValue:value forKey:[self setFilterName:filterName]];
}

-(void)addFilter:(GameField)filterName withIntValue:(int)value {
	[filters setValue:[NSString stringWithFormat:@"%d",value] forKey:[self setFilterName:filterName]];
}

-(void)addFilter:(GameField)filterName withFloatValue:(float)value {
	[filters setValue:[NSString stringWithFormat:@"%f",value] forKey:[self setFilterName:filterName]];
}

-(void)addFilter:(GameField)filterName withBOOLValue:(BOOL)value {
	if (value) {
		[filters setValue:@"true" forKey:[self setFilterName:filterName]];
	} else {
		[filters setValue:@"false" forKey:[self setFilterName:filterName]];
	}
}

-(void)addFilter:(GameField)filterName withDateValue:(NSDate *)value{
	switch (filterName) {
		default:
			[self addFilter:filterName withFloatValue:[value timeIntervalSince1970]];
			break;
	}
	
}

-(void)addFilter:(GameField)filterName withURLValue:(NSURL *)value{
	[filters setValue:[value absoluteString] forKey:[self setFilterName:filterName]];
}

-(void)dealloc
{
	[filters release];
	[super dealloc];
}

@end

@interface Game (PrivateMethods) 

+ (NSString *)getGameSortField:(GameField)field;

+(BOOL)handleError:(NSError **)error ResponseType:(int)responseType ResponseMessage:(NSString *)responseMessage;

@end

@implementation Game

@synthesize requestID;
@synthesize delegate;
@synthesize _gameID;
@synthesize _gameImage;
@synthesize _gameAnswer;
@synthesize _gameStreak;
@synthesize _gameMode;
@synthesize _gameStatus;
@synthesize _gameFirstPlayer;
@synthesize _gameSecondPlayer;


# pragma mark - Memory Management

-(void)dealloc
{
	[_gameImage release];
	[_gameAnswer release];
	[_gameFirstPlayer release];
	[_gameSecondPlayer release];

	[super dealloc];
}


# pragma mark - Initialization

/*
*  init with defaults values
*/
-(id)init {
	if (self = [super init]) {

		self._gameID				= ACL_INT_MIN;
		self._gameImage				= nil;
		self._gameAnswer				= nil;
		self._gameStreak				= ACL_INT_MIN;
		self._gameMode				= ACL_INT_MIN;
		self._gameStatus				= ACL_INT_MIN;
		self._gameFirstPlayer				= nil;
		self._gameSecondPlayer				= nil;
		requestID = -1;

	}
	return self;
}


/*
*  init values from dictionary
*/
-(id)initWithDictionary:(NSDictionary *)item{
	if (self = [super init]) {

		self._gameID               = [[item objectForKey:KEY_gameID] integerValue];
		self._gameImage               = [NSURL URLWithString:[item objectForKey:KEY_gameImage]];
		self._gameAnswer               = [item objectForKey:KEY_gameAnswer];
		self._gameStreak               = [[item objectForKey:KEY_gameStreak] integerValue];
		self._gameMode               = [[item objectForKey:KEY_gameMode] integerValue];
		self._gameStatus               = [[item objectForKey:KEY_gameStatus] integerValue];
		_gameFirstPlayer               = [[AppUser alloc] initWithDictionary:[item objectForKey:KEY_gameFirstPlayer]];
		_gameSecondPlayer               = [[AppUser alloc] initWithDictionary:[item objectForKey:KEY_gameSecondPlayer]];
		requestID = -1;

	}
	return self;
}

/*
*  init values from Object
*/
-(id)initWithObject:(Game *)object {
	if (self = [super init]) {

		self._gameID               = object._gameID;
		self._gameImage               = object._gameImage;
		self._gameAnswer               = object._gameAnswer;
		self._gameStreak               = object._gameStreak;
		self._gameMode               = object._gameMode;
		self._gameStatus               = object._gameStatus;
		_gameFirstPlayer               = [[AppUser alloc] initWithObject:object._gameFirstPlayer];
		_gameSecondPlayer               = [[AppUser alloc] initWithObject:object._gameSecondPlayer];
		requestID = -1;

	}
	return self;
}

-(void)uploadImage:(UIImage *)image andUpdateURL:(GameField)imageURLField CreateThumbnail:(BOOL)createThumbnail withDelegate:(id)_delegate sizeFactor:(float)factor{
	
	self.delegate = _delegate;
	switch (imageURLField) {
		case _GameImage:
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


-(NSURL *)getThumbnailUrlForFiled:(GameField)field{

	NSURL *url=nil;

	switch (field) {
		case _GameImage:
			url = self._gameImage;
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



+(void)getGameByID:(int)ID withDelegate:(id)delgate{
	Game *item = [[Game alloc] init];
	item._gameID = ID;
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

+ (Game *) getGameByID:(int)ID Error:(NSError **)error{
	Game *item = nil;
	
	ACLRequest *request = [[ACLRequest alloc] init];
	[request setAction:@"Get"];
	[request setClassName:kClassName];
	[request addIntValue:ID forKey:@"RecordID"];
	
	[request startSync];
	
	NSError *responseError = nil;
	if ([Game handleError:&responseError ResponseType:[request responseType] ResponseMessage:[request responseMessage]]){
	
		if ([[request responseData] count] > 0) {
			item=[[[Game alloc] initWithDictionary:[[request responseData] objectAtIndex:0]]autorelease];
		}
	}
	[request release];
	
	if (error) {
		*error = responseError;
	}
	
	return item;
}
	
+(void)deleteGameByID:(int)ID withDelegate:(id)delgate {
	Game *item = [[Game alloc] init];
	item._gameID = ID;
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

+(BOOL)deleteGameByID:(int)ID Error:(NSError **)error{
	ACLRequest *request = [[ACLRequest alloc] init];
	[request setAction:@"Delete"];
	[request setClassName:kClassName];
	[request addIntValue:ID forKey:@"RecordID"];
	[request startSync];

	NSError *responseError = nil;
	[Game handleError:&responseError ResponseType:[request responseType] ResponseMessage:[request responseMessage]];
	[request release];
	
	if (error) {
		*error = responseError;
	}
	
	if (responseError)
		return NO;
	else
		return YES;
}

+(void)addGame:(Game *)item withDelegate:(id)delgate{
	item.delegate = delgate;
	ACLRequest *request = [[ACLRequest alloc] init];
	request.delegate = item;
	[request setAction:@"Add"];
	[request setClassName:kClassName];
	
	if (item._gameImage)
		[request addValue:item._gameImage.absoluteString forKey:KEY_gameImage];
	if (item._gameAnswer)
		[request addValue:item._gameAnswer forKey:KEY_gameAnswer];
	if (item._gameStreak > ACL_INT_MIN)
		[request addIntValue:item._gameStreak forKey:KEY_gameStreak];
	if (item._gameMode > ACL_INT_MIN)
		[request addIntValue:item._gameMode forKey:KEY_gameMode];
	if (item._gameStatus > ACL_INT_MIN)
		[request addIntValue:item._gameStatus forKey:KEY_gameStatus];
	if (item._gameFirstPlayer)
		[request addIntValue:item._gameFirstPlayer._appUserID forKey:KEY_gameFirstPlayer];
	if (item._gameSecondPlayer)
		[request addIntValue:item._gameSecondPlayer._appUserID forKey:KEY_gameSecondPlayer];
	
	[request startAsync];
	[request release];
}

+(int)addGame:(Game *)item Error:(NSError **)error{
	
	ACLRequest *request = [[ACLRequest alloc] init];
	[request setAction:@"Add"];
	[request setClassName:kClassName];

	if (item._gameImage)
		[request addValue:item._gameImage.absoluteString forKey:KEY_gameImage];
	if (item._gameAnswer)
		[request addValue:item._gameAnswer forKey:KEY_gameAnswer];
	if (item._gameStreak > ACL_INT_MIN)
		[request addIntValue:item._gameStreak forKey:KEY_gameStreak];
	if (item._gameMode > ACL_INT_MIN)
		[request addIntValue:item._gameMode forKey:KEY_gameMode];
	if (item._gameStatus > ACL_INT_MIN)
		[request addIntValue:item._gameStatus forKey:KEY_gameStatus];
	if (item._gameFirstPlayer)
		[request addIntValue:item._gameFirstPlayer._appUserID forKey:KEY_gameFirstPlayer];
	if (item._gameSecondPlayer)
		[request addIntValue:item._gameSecondPlayer._appUserID forKey:KEY_gameSecondPlayer];
	
	[request startSync];
	
	NSError *responseError = nil;
	if ([Game handleError:&responseError ResponseType:[request responseType] ResponseMessage:[request responseMessage]]){
		if ([[request responseData] count] > 0) {
			item._gameID = [[[[request responseData] objectAtIndex:0] objectForKey:KEY_gameID]intValue];
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
		return item._gameID;
}

+(void)updateGameByID:(int)ID item:(Game *)item withDelegate:(id)delgate{
	if (!item){
		item=[[[Game alloc]init]autorelease];
	}
	item._gameID = ID;
	[Game updateGameByItemID:item withDelegate:delgate];
}

+(BOOL)updateGameByID:(int)ID item:(Game *)item Error:(NSError **)error{
	if (!item){
		item=[[[Game alloc]init]autorelease];
	}
	item._gameID = ID;
	return [Game updateGameByItemID:item Error:error];
}

+(void)updateGameByItemID:(Game *)item withDelegate:(id)delgate{
	
	item.delegate = delgate;
	ACLRequest *request = [[ACLRequest alloc] init];
	request.delegate = item;    [request setAction:@"Update"];
	[request setClassName:kClassName];
	
	if (item._gameID == ACL_INT_MIN) {
		return;
	} else {
		[request addIntValue:item._gameID forKey:@"RecordID"];
	}

	if (item._gameImage)
		[request addValue:item._gameImage.absoluteString forKey:KEY_gameImage];
	if (item._gameAnswer)
		[request addValue:item._gameAnswer forKey:KEY_gameAnswer];
	if (item._gameStreak > ACL_INT_MIN)
		[request addIntValue:item._gameStreak forKey:KEY_gameStreak];
	if (item._gameMode > ACL_INT_MIN)
		[request addIntValue:item._gameMode forKey:KEY_gameMode];
	if (item._gameStatus > ACL_INT_MIN)
		[request addIntValue:item._gameStatus forKey:KEY_gameStatus];
	if (item._gameFirstPlayer)
		[request addIntValue:item._gameFirstPlayer._appUserID forKey:KEY_gameFirstPlayer];
	if (item._gameSecondPlayer)
		[request addIntValue:item._gameSecondPlayer._appUserID forKey:KEY_gameSecondPlayer];
	

	[request startAsync];
	[request release];
}

+(BOOL)updateGameByItemID:(Game *)item Error:(NSError **)error{
	
	ACLRequest *request = [[ACLRequest alloc] init];
	[request setAction:@"Update"];
	[request setClassName:kClassName];
	
	if (item._gameID == ACL_INT_MIN) {
		[request release];
		return NO;
	} else {
		[request addIntValue:item._gameID forKey:@"RecordID"];
	}

	if (item._gameImage)
		[request addValue:item._gameImage.absoluteString forKey:KEY_gameImage];
	if (item._gameAnswer)
		[request addValue:item._gameAnswer forKey:KEY_gameAnswer];
	if (item._gameStreak > ACL_INT_MIN)
		[request addIntValue:item._gameStreak forKey:KEY_gameStreak];
	if (item._gameMode > ACL_INT_MIN)
		[request addIntValue:item._gameMode forKey:KEY_gameMode];
	if (item._gameStatus > ACL_INT_MIN)
		[request addIntValue:item._gameStatus forKey:KEY_gameStatus];
	if (item._gameFirstPlayer)
		[request addIntValue:item._gameFirstPlayer._appUserID forKey:KEY_gameFirstPlayer];
	if (item._gameSecondPlayer)
		[request addIntValue:item._gameSecondPlayer._appUserID forKey:KEY_gameSecondPlayer];
	

	[request startSync];
	
	NSError *responseError = nil;
	[Game handleError:&responseError ResponseType:[request responseType] ResponseMessage:[request responseMessage]];
	
	[request release];

	if (error) {
		*error = responseError;
	}

	if (responseError)
		return NO; 
	else
		return YES;
}

+ (NSString *)getGameSortField:(GameField)field {
	NSString *fieldName;
	
	switch (field) {
		case _Game_None:
			fieldName = @"";
			break;
	
		case _GameID:
			fieldName = KEY_gameID;
			break;

		case _GameImage:
			fieldName = KEY_gameImage;
			break;

		case _GameAnswer:
			fieldName = KEY_gameAnswer;
			break;

		case _GameStreak:
			fieldName = KEY_gameStreak;
			break;

		case _GameMode:
			fieldName = KEY_gameMode;
			break;

		case _GameStatus:
			fieldName = KEY_gameStatus;
			break;

		case _GameFirstPlayer:
			fieldName = KEY_gameFirstPlayer;
			break;

		case _GameSecondPlayer:
			fieldName = KEY_gameSecondPlayer;
			break;

		default:
			fieldName = @"";
			break;
	}
	
	return fieldName;
}

+(NSArray *)getGameArray:(NSError **)error SortField:(GameField)sortField SortType:(SortType)sortType{
	return [Game getGameArray:error SortField:sortField SortType:sortType WithFilters:nil AndPager:0 RecsPerPage:0];
}

+(NSArray *)getGameArray:(NSError **)error SortField:(GameField)sortField SortType:(SortType)sortType WithFilters:(GameFilters *)filters{
	return [Game getGameArray:error SortField:sortField SortType:sortType WithFilters:filters AndPager:0 RecsPerPage:0];
}

+(NSArray *)getGameArray:(NSError **)error SortField:(GameField)sortField SortType:(SortType)sortType WithFilters:(GameFilters *)filters AndPager:(int)page RecsPerPage:(int)recsPerPage{
	
	ACLRequest *request = [[[ACLRequest alloc] init] autorelease];
	
	[request setAction:@"GetArray"];
	[request setClassName:kClassName];
	[request addValue:[Game getGameSortField:sortField] forKey:@"SortField"]; 
	[request addIntValue:sortType forKey:@"SortType"];
	[request addIntValue:page forKey:@"Page"];
	[request addIntValue:recsPerPage forKey:@"RecsPerPage"];
	
	NSArray *keys = [NSArray arrayWithArray:[filters.filters allKeys]];
	for (NSString *key in keys) {
		[request addValue:[filters.filters objectForKey:key] forKey:key];
	}
	
	[request startSync];
	
	NSError *responseError = nil;
	[Game handleError:&responseError ResponseType:[request responseType] ResponseMessage:[request responseMessage]];
	
	if (error) {
		*error = responseError;
	}
	if (responseError) {
		return nil; 
	}
	
	NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:nil];
	for (NSDictionary *dictionary in [request responseData]) {
		Game *item = [[Game alloc] initWithDictionary:dictionary];
		[tempArray addObject:item];
		[item release];
	}
	NSArray *responseArray = [NSArray arrayWithArray:tempArray];
	[tempArray release];
	
	return responseArray;
	
}

+(void)getGameArrayWithDelegate:(id)delegate SortField:(GameField)sortField SortType:(SortType)sortType{
	[Game getGameArrayWithDelegate:delegate SortField:sortField SortType:sortType WithFilters:nil AndPager:0 RecsPerPage:0];
}

+(void)getGameArrayWithDelegate:(id)delegate SortField:(GameField)sortField SortType:(SortType)sortType WithFilters:(GameFilters *)filters{
	[Game getGameArrayWithDelegate:delegate SortField:sortField SortType:sortType WithFilters:filters AndPager:0 RecsPerPage:0];
}

+ (void)getGameArrayWithDelegate:(id)delegate SortField:(GameField)sortField SortType:(SortType)sortType WithFilters:(GameFilters *)filters AndPager:(int)page RecsPerPage:(int)recsPerPage{
	[Game getGameArrayWithDelegate:delegate SortField:sortField SortType:sortType WithFilters:filters AndPager:page RecsPerPage:recsPerPage AndRequestID:-1];
}

+ (void)getGameArrayWithDelegate:(id)delegate SortField:(GameField)sortField SortType:(SortType)sortType WithFilters:(GameFilters *)filters AndPager:(int)page RecsPerPage:(int)recsPerPage AndRequestID:(int)requestID {
	
	Game *item = [[Game alloc] init];
	item.requestID = requestID;
	item.delegate = delegate;
	ACLRequest *request = [[[ACLRequest alloc] init] autorelease];
	request.delegate = item;
	[item release];
	
	[request setAction:@"GetArray"];
	[request setClassName:kClassName];
	[request addValue:[Game getGameSortField:sortField] forKey:@"SortField"]; 
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
		if (![delegate respondsToSelector:@selector(deleteGameDidFinished:ResponseMessage:withID:)])
			return;
		[delegate deleteGameDidFinished:responseType ResponseMessage:responseMessage withID:[self _gameID]];
	
	} else if ([action isEqualToString:@"Add"]) {
		if (![delegate respondsToSelector:@selector(addGameDidFinished:ResponseMessage:withObject:)])
			return;
		NSError *responseError = nil;
		if ([Game handleError:&responseError ResponseType:responseType ResponseMessage:responseMessage]){
			if ([responseData count] > 0) {
				self._gameID = [[[responseData objectAtIndex:0] objectForKey:KEY_gameID] intValue];
			} 
		}
		[delegate addGameDidFinished:responseType ResponseMessage:responseMessage withObject:self];
	} else if ([action isEqualToString:@"Update"]) {
		if (![delegate respondsToSelector:@selector(updateGameDidFinished:ResponseMessage:withObject:)])
			return;
		[delegate updateGameDidFinished:responseType ResponseMessage:responseMessage withObject:self];
	
	} else if ([action isEqualToString:@"Get"]) {
		if (![delegate respondsToSelector:@selector(getGameDidFinished:ResponseMessage:withObject:)])
			return;
		NSError *responseError = nil;
		if ([Game handleError:&responseError ResponseType:responseType ResponseMessage:responseMessage]){
			if ([responseData count] > 0) {
				Game *item = [[[Game alloc] initWithDictionary:[responseData objectAtIndex:0]] autorelease];
				[delegate getGameDidFinished:responseType ResponseMessage:responseMessage withObject:item];
			} else {
				[delegate getGameDidFinished:responseType ResponseMessage:responseMessage withObject:nil];            }
		} else {
			[delegate getGameDidFinished:responseType ResponseMessage:responseMessage withObject:nil];                    }
	}
	else if ([action isEqualToString:@"GetArray"]){
		NSError *responseError = nil;
		NSArray *responseArray;
		[Game handleError:&responseError ResponseType:responseType ResponseMessage:responseMessage];
		if (responseError) {
			responseArray=nil;
		}else{
			NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:nil];
			for (NSDictionary *dictionary in responseData) {
				Game *item = [[Game alloc] initWithDictionary:dictionary];
				[tempArray addObject:item];
				[item release];
			}
			responseArray = [NSArray arrayWithArray:tempArray];
			[tempArray release];
		}
		if (([delegate respondsToSelector:@selector(didFinishedGetGameArray:ResponseMessage:withArray:)])&&(requestID==-1)){
			[delegate didFinishedGetGameArray:responseType ResponseMessage:responseMessage withArray:responseArray];
		} 
		if (([delegate respondsToSelector:@selector(didFinishedGetGameArray:ResponseMessage:withArray:AndRequestID:)])&&(requestID!=-1)){
			[delegate didFinishedGetGameArray:responseType ResponseMessage:responseMessage withArray:responseArray AndRequestID:requestID];
		}
	}
}

-(void)uploadImageDidFinished:(int)imageURLField ResponseType:(NSInteger)responseType ResponseMessage:(NSString *)responseMessage responseData:(NSMutableArray *)responseData{
	
	// check for error
	BOOL respondToSelector=[delegate respondsToSelector:@selector(didFinishedUploadImage:ResponseMessage:URLField:withObject:)];
	NSError *responseError = nil;
	if ([Game handleError:&responseError ResponseType:responseType ResponseMessage:responseMessage]){
		if ([responseData count] > 0) {
		
			NSURL *finalUrl=[NSURL URLWithString:[[responseData objectAtIndex:0]objectForKey:@"ImageFullPath"]];
		
			switch (imageURLField) {
				case _GameImage:
					self._gameImage =  finalUrl;
					break;
					
				default:
					// error - no valid field to update - return
					finalUrl = nil;
					break;
			}
			if ([Game updateGameByItemID:self Error:nil]) {
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
