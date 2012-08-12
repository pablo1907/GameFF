//
//  Applicasa.h
//  Framework-iOS
//
//  Created by Assaf Allon on 12/2/11.
//  Copyright (c) 2011 Applicasa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import <Applicasa/ACLRequest.h>
#import <Applicasa/ACLParser.h>
#import <Applicasa/ACL_UIImage+Resize.h>
#import <Applicasa/ACLLocationDelegate.h>
#import <Applicasa/ACLUpdateLocationDelegate.h>

#define FORMAT_KEY(key) [NSString stringWithFormat:(@"%d"), key]
#define ACL_INT_MIN -2147483648

typedef enum {
	Ascending,
	Descending
} SortType;


@interface Applicasa : NSObject

+ (void)setApplicationKey:(NSString *)appKey;
// Push Notification
+ (void)registerDeviceToken:(NSData *)deviceToken;
+ (void)failToRegisterDeviceToken;

// Location Services
+ (void)getCurrentLocation:(id)delegate;
+ (void)updateAppUserLocation:(id)delegate;
+ (void)startUpdatingUserLocationWithDelegate:(id)delegate;
+ (void)stopUpdatingUserLocation;
+ (void)setDistanceFilter:(CLLocationDistance)distanceFilter;
+ (void)setDesireAccuracy:(CLLocationAccuracy)desireAccuracy;

// Device ID , User ID & UserName
+ (NSInteger)getDeviceID;
+ (NSInteger)getUserID;
+ (NSString *)getUserName;

+(void)didReceivedPushNotification:(NSInteger)pushID;

@end