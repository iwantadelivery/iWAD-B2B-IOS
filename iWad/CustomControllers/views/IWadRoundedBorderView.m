//
//  iWadRoundedBorderView.m
//  iWad
//
//  Created by Saman Kumara on 12/16/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "IWadRoundedBorderView.h"

@implementation IWadRoundedBorderView

-(void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderColor = BORDER_COLOR.CGColor;
    self.layer.borderWidth = 1.0;
}
@end
