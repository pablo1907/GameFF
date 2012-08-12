//
//  ACLRequest.h
//  AppliKit
//
//  Created by Assaf Allon on 11/8/11.
//  Copyright 2011 Applicasa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ACLRequest;

@protocol ACLRequestDelegate <NSObject>;
@optional
- (void)requsetDidFinished:(NSString *)action ResponseType:(NSInteger)responseType ResponseMessage:(NSString *)responseMessage responseData:(NSMutableArray *)responseData;

-(void)uploadImageDidFinished:(int)imageURLField ResponseType:(NSInteger)responseType ResponseMessage:(NSString *)responseMessage responseData:(NSMutableArray  *)responseData;

- (id)getObjectDelegate;
@end

@interface ACLRequest : NSObject {
    
    NSURLConnection *connection;
    NSMutableData *response;

    NSInteger retryCounter; // for internet connection
    NSInteger tokenRetryCounter; // for request for Token
    BOOL deviceTokenIsNotValid;

    BOOL shouldReturnToDelegate;
}

@property(nonatomic,retain)     id<ACLRequestDelegate>  delegate;
@property(nonatomic,retain)     NSString                *className;
@property(nonatomic,retain)     NSString                *action;
@property(nonatomic,retain)     NSMutableDictionary     *request;

@property(nonatomic,retain)     NSMutableArray          *responseData;
@property(nonatomic, assign)    NSInteger               responseType;
@property(nonatomic, retain)    NSString                *responseMessage;

- (void) addValue:(NSString *)value forKey:(NSString *)key;
- (void) addIntValue:(NSInteger)value forKey:(NSString *)key;
- (void) addBoolValue:(BOOL)value forKey:(NSString *)key;
- (void) addFloatValue:(float)value forKey:(NSString *)key;

- (void)startSync;
- (void)startAsync;


@end
