//
//  ACL_UIImage+Resize.h
//  Applicasa
//
//  Created by Benny Davidovich on 3/29/12.
//  Copyright (c) 2012 benny@applicasa.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ApplicasaResize)

- (UIImage *)applicasaResizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;

@end
