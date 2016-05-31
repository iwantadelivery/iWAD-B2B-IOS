//
//  BorderUiView.m
//  iWad
//
//  Created by Saman Kumara on 12/14/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "BorderUiView.h"

@implementation BorderUiView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    UIColor *boaderColor = UIColorFromRGB(0x2d2f39);
    self.layer.borderColor = boaderColor.CGColor;
}
@end
