//
//  ACLLocationDelegate.h
//  Applicasa
//
//  Created by Assaf Allon on 4/5/12.
//  Copyright (c) 2012 assaf@hippotec.com. All rights reserved.
//


#import <CoreLocation/CoreLocation.h>

@protocol ACLLocationDelegate <NSObject>
@required

-(void)LocationControllerDidFinishGetCurrentLocation:(CLLocation *)location Error:(NSError *)error;

@end