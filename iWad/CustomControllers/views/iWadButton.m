//
//  iWadButton.m
//  iWad
//
//  Created by Saman Kumara on 12/15/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "iWadButton.h"

@interface iWadButton () {
}

@end

@implementation iWadButton

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
    self.backgroundColor = IWAD_TEXT_COLOR;
}
@end
