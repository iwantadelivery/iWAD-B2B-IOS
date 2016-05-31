//
//  IWadCancelButton.m
//  iWAD
//
//  Created by Himal Madhushan on 2/26/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "IWadCancelButton.h"

@implementation IWadCancelButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    self.layer.cornerRadius = self.frame.size.height/2;
    self.clipsToBounds      = YES;
    [self.titleLabel setFont:[UIFont fontWithName:@"Antenna-Bold" size:self.titleLabel.font.pointSize]];
    self.backgroundColor = [UIColor colorWithRed:0.2627 green:0.2745 blue:0.3098 alpha:1.0];
    self.layer.borderColor = [UIColor colorWithRed:0.5412 green:0.5529 blue:0.5804 alpha:1.0].CGColor;
    self.layer.borderWidth = 1;
}

@end
