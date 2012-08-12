//
//  ACLUpdateLocationDelegate.h
//  Applicasa
//
//  Created by Benny Davidovich on 4/9/12.
//  Copyright (c) 2012 benny@applicasa.com. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@protocol ACLUpdateLocationDelegate <NSObject>

@optional

-(void)LocationControllerDidUpdateLocation:(CLLocation *)location;
-(void)LocationControllerDidFailToUpdateLocation:(NSError *)error;

@end
