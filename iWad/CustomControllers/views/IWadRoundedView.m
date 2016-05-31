//
//  IWadRoundedView.m
//  iWad
//
//  Created by Saman Kumara on 12/16/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "IWadRoundedView.h"

@implementation IWadRoundedView

-(void)awakeFromNib {
    self.layer.cornerRadius = self.frame.size.height/2;
    self.clipsToBounds      = YES;
}

@end
