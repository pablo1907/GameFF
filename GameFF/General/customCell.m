//
//  customCell.m
//  GameFF
//
//  Created by Biton, Adi on 8/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "customCell.h"

@implementation customCell
- (void)layoutSubviews {  
    [super layoutSubviews];  
    self.imageView.frame = CGRectMake(5,5,40,32.5);  
    float limgW =  self.imageView.image.size.width;  
    if(limgW > 0) {  
        self.textLabel.frame = CGRectMake(55,self.textLabel.frame.origin.y,self.textLabel.frame.size.width,self.textLabel.frame.size.height);  
        self.detailTextLabel.frame = CGRectMake(55,self.detailTextLabel.frame.origin.y,self.detailTextLabel.frame.size.width,self.detailTextLabel.frame.size.height);  
    }  
}  
@end
