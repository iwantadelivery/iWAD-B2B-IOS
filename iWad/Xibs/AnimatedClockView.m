//
//  AnimatedClockView.m
//  iWAD
//
//  Created by Himal Madhushan on 3/1/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "AnimatedClockView.h"

@implementation AnimatedClockView

-(instancetype)init {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        imgViewHourHand = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        imgViewHourHand.image = [UIImage imageNamed:@"hourHand"];
        
        imgViewOuter = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        imgViewOuter.image = [UIImage imageNamed:@"clockOuterBorder"];
        
        imgViewMinuteHand = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        imgViewMinuteHand.image = [UIImage imageNamed:@"minuteHand"];
    }
    return self;
}

-(void)showInView:(UIView *)view {
    
    [view addSubview:self];
    
    [self addSubview:imgViewHourHand];
    [self addSubview:imgViewMinuteHand];
    [self addSubview:imgViewOuter];
    
    [self animateImageViews:imgViewHourHand duration:6];
    [self animateImageViews:imgViewMinuteHand duration:3];
}

-(void)animateImageViews:(UIImageView *)imageView duration:(float)duration {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = duration;
//    rotationAnimation.autoreverses = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end
