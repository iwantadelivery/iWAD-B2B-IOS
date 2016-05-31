//
//  RoundedImageView.m
//  iWad
//
//  Created by Saman Kumara on 12/18/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "RoundedImageView.h"

@implementation RoundedImageView

-(void)awakeFromNib {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.borderWidth = 1;
    self.layer.borderColor = BORDER_COLOR.CGColor;
}


@end
