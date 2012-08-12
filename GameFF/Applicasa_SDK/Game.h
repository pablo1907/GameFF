//
// Game.h
// Created by Applicasa dbGenerator
// 8/6/2012
//

#import <Foundation/Foundation.h>
#import <Applicasa/Applicasa.h>
#import "AppUser.h"
#import "AppUser.h"
#import <Applicasa/NSData+Base64.h>

// Object's fields and filters enum
typedef enum {
	_Game_None,
	_GameID,
	_GameImage,
	_GameAnswer,
	_GameStreak,
	_GameMode,
	_GameStatus,
	_GameFirstPlayer,
	_GameSecondPlayer
} GameField;

//*************
// Filter class
//
// Used to set filters for Get-Array methods with filters
//

@interface GameFilters : NSObject {
}
@property (nonatomic, retain) NSMutableDictionary *filters;

// Filter for Text,Multiline,Image and HTML fields
-(void)addFilter:(GameField)filterName withValue:(NSString *)value;

// Filter for Number ,Foreign-key and List fields
-(void)addFilter:(GameField)filterName withIntValue:(int)value;

// Filter for Real field
-(void)addFilter:(GameField)filterName withFloatValue:(float)value;

// Filter for True or False field
-(void)addFilter:(GameField)filterName withBOOLValue:(BOOL)value;

// Filter for Date field
-(void)addFilter:(GameField)filterName withDateValue:(NSDate *)value;

// Filter for Image field
-(void)addFilter:(GameField)filterName withURLValue:(NSURL *)value;

@end



//*************
//
// GameDelegate Protocol
//
// Implement this protocol when using A-Sync requests
//

@class Game;
@protocol GameDelegate <NSObject>;
@optional
// Optional means that you don't must to implement those methods

// Delegate method for the A-Sync add method
-(void)addGameDidFinished:(int)responseType ResponseMessage:(NSString *)responseMessage withObject:(Game *)object;

// Delegate method for the A-Sync update method
-(void)updateGameDidFinished:(int)responseType ResponseMessage:(NSString *)responseMessage withObject:(Game *)object;

// Delegate method for the A-Sync get method
-(void)getGameDidFinished:(int)responseType ResponseMessage:(NSString *)responseMessage withObject:(Game *)object;

// Delegate method for the A-Sync delete method
-(void)deleteGameDidFinished:(int)responseType ResponseMessage:(NSString *)responseMessage withID:(int)ID;

// Delegate method for the A-Sync Get-Array method
-(void)didFinishedGetGameArray:(int)responseType ResponseMessage:(NSString *)responseMessage withArray:(NSArray *)array;

// Delegate method for the A-Sync Get-Array method with request id
- (void) didFinishedGetGameArray:(int)responseType ResponseMessage:(NSString *)responseMessage withArray:(NSArray *)array AndRequestID:(int)requestID;

// Delegate method for the A-Sync Upload Image method 
-(void)didFinishedUploadImage:(int)responseType ResponseMessage:(NSString *)responseMessage URLField:(GameField)imageURLField withObject:(Game *)object;

@end



//*************
//
// Game Class
//
//

@interface Game : NSObject <ACLRequestDelegate> {

}

@property (nonatomic, assign) int requestID;
@property (nonatomic, retain) id<GameDelegate> delegate;
@property (nonatomic, assign) int _gameID;
@property (nonatomic, retain) NSURL *_gameImage;
@property (nonatomic, retain) NSString *_gameAnswer;
@property (nonatomic, assign) int _gameStreak;
@property (nonatomic, assign) int _gameMode;
@property (nonatomic, assign) int _gameStatus;
@property (nonatomic, retain) AppUser *_gameFirstPlayer;
@property (nonatomic, retain) AppUser *_gameSecondPlayer;

// Initalization methods
-(id)initWithDictionary:(NSDictionary *)item;
-(id)initWithObject:(Game *)object;

-(void)uploadImage:(UIImage *)image andUpdateURL:(GameField)imageURLField CreateThumbnail:(BOOL)createThumbnail withDelegate:(id)_delegate sizeFactor:(float)factor;
-(NSURL *)getThumbnailUrlForFiled:(GameField)field;
// ****
// Add Game item to Applicasa DB
//
// A-Sync Add method (optional to implement GameDelegate protocol)
+(void)addGame:(Game *)item withDelegate:(id)delgate;
// Sync Add method
+ (int)addGame:(Game *)item Error:(NSError **)error;


// ****
// Update Game item in Applicasa DB
//
// A-Sync Update method by ID (optional to implement GameDelegate)
+(void)updateGameByID:(int)ID item:(Game *)item withDelegate:(id)delgate;
//Sync Update method by ID
+(BOOL)updateGameByID:(int)ID item:(Game *)item Error:(NSError **)error;

// A-Sync Update method by Game item (optional to implement GameDelegate)
+(void)updateGameByItemID:(Game *)item withDelegate:(id)delgate;
//Sync Update method by Game item
+(BOOL)updateGameByItemID:(Game *)item Error:(NSError **)error;


// ****
// Get Game item from Applicasa DB
//
// A-Sync Get method (optional to implement GameDelegate)
//
// A-Sync Get method
+(void)getGameByID:(int)ID withDelegate:(id)delgate;
// Sync Get method
+(Game *)getGameByID:(int)ID Error:(NSError **)error;


// ****
// Delete Game item from Applicasa DB
//
// A-Sync Delete method (optional to implement GameDelegate protocol)
+(void)deleteGameByID:(int)ID withDelegate:(id)delgate;
// Sync Delete method
+(BOOL)deleteGameByID:(int)ID Error:(NSError **)error;

// ****
// Get Game Array from Applicasa DB
// Use sortField to sort the array according the field you choosed
// Use sortType to set the sort order (Ascesnding/Descending)
// Use filters to filter the data by using an instance GameFilters class
// Use pager to get specified indexes
//
// Sync Get-Array method
+(NSArray *)getGameArray:(NSError **)error SortField:(GameField)sortField SortType:(SortType)sortType;
// Sync Get-Array method with Filter
+(NSArray *)getGameArray:(NSError **)error SortField:(GameField)sortField SortType:(SortType)sortType WithFilters:(GameFilters *)filters;
// Sync Get-Array method with Filter and Pager
+(NSArray *)getGameArray:(NSError **)error SortField:(GameField)sortField SortType:(SortType)sortType WithFilters:(GameFilters *)filters AndPager:(int)page RecsPerPage:(int)recsPerPage;

// A-Sync Get-Array method (optional to implement GameDelegate protocol)
+(void)getGameArrayWithDelegate:(id)delegate SortField:(GameField)sortField SortType:(SortType)sortType;
// A-Sync Get-Array method with Filter (optional to implement GameDelegate protocol)
+ (void)getGameArrayWithDelegate:(id)delegate SortField:(GameField)sortField SortType:(SortType)sortType WithFilters:(GameFilters *)filters;
// A-Sync Get-Array method with Filter and Pager (optional to implement GameDelegate protocol)
+(void)getGameArrayWithDelegate:(id)delegate SortField:(GameField)sortField SortType:(SortType)sortType WithFilters:(GameFilters *)filters AndPager:(int)page RecsPerPage:(int)recsPerPage;

// A-Sync Get-Array method with Filter and Pager with request id(optional to implement GameDelegate protocol)
+ (void)getGameArrayWithDelegate:(id)delegate SortField:(GameField)sortField SortType:(SortType)sortType WithFilters:(GameFilters *)filters AndPager:(int)page RecsPerPage:(int)recsPerPage AndRequestID:(int)requestID;

// Cancel requests
+ (void)cancelRequestsForDelegate:(id)delegate;

@end
