//
//  IWadTextField.m
//  iWAD
//
//  Created by Himal Madhushan on 1/13/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "IWadTextField.h"

@implementation IWadTextField

-(void)awakeFromNib {
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.44 green:0.4915 blue:0.5337 alpha:1.0]}];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
