//
//  LocationPopupViewController.m
//  iWAD
//
//  Created by Himal Madhushan on 2/5/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "LocationPopupViewController.h"

@interface LocationPopupViewController () <UIGestureRecognizerDelegate> {
    UILabel *lblAddress, *lblFromTo, *lblTo;
//    UIView *view;
    LocationType locationType;
    CGRect lblFrame;
    UIView *contentView;
    
}

@end

@implementation LocationPopupViewController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)resetLabels {
    [lblFromTo removeFromSuperview];
}

-(instancetype)initWithType:(LocationType)type address:(NSString *)address frame:(CGRect)frame {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6464170259];
        
        contentView = [[UIView alloc] initWithFrame:frame];
        contentView.backgroundColor = [UIColor colorWithRed:0.1922 green:0.2 blue:0.2314 alpha:1.0];
        contentView.layer.cornerRadius   = contentView.frame.size.height/2;
        contentView.layer.borderColor    = BORDER_COLOR.CGColor;
        contentView.layer.borderWidth    = 1;
        contentView.clipsToBounds        = YES;
        
        lblFromTo = [[UILabel alloc] initWithFrame:CGRectMake(0, contentView.frame.size.height/2 - 11, 50, 22)];
        lblFromTo.backgroundColor = [UIColor clearColor];
        lblFromTo.textAlignment = NSTextAlignmentRight;
        lblFromTo.textColor = [UIColor colorWithRed:0.4745 green:0.4863 blue:0.5137 alpha:1.0];
        lblFromTo.font = [UIFont fontWithName:@"Antenna-Regular" size:10];
        
        UIView *circularView = [[UIView alloc] initWithFrame:CGRectMake(lblFromTo.frame.size.width + 10, frame.size.height/2-3, 5, 5)];
        circularView.layer.cornerRadius = circularView.frame.size.height/2;
        circularView.clipsToBounds = YES;
        
        lblAddress = [[UILabel alloc] initWithFrame:CGRectMake(circularView.frame.origin.x + circularView.frame.size.width + 10, contentView.frame.size.height/2 - 11, 0, 22)];
        CGRect lblAddressFrame = lblAddress.frame;
        lblAddressFrame.size.width = contentView.frame.size.width - (circularView.frame.origin.x + circularView.frame.size.width + 10);
        lblAddress.frame = lblAddressFrame;
        lblAddress.text = address;
        lblAddress.textColor = [UIColor whiteColor];
        lblAddress.font     = [UIFont fontWithName:@"Antenna-Regular" size:10];
        lblAddress.backgroundColor = [UIColor clearColor];
        
        
        [self resetLabels];
        
        if (type == LocationTypeFrom) {
            lblFromTo.text = @"FROM";
            circularView.backgroundColor = [UIColor greenColor];
        } else if (type == LocationTypeTo) {
            lblFromTo.text = @"TO";
            circularView.backgroundColor = [UIColor redColor];
        }
        [contentView addSubview:lblAddress];
        [contentView addSubview:circularView];
        [contentView addSubview:lblFromTo];
        
        //shadow on label
        
        
        
        [self addSubview:contentView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
        [self addGestureRecognizer:tapGesture];
        
        
//        lblFrame = lblAddress.frame;
//        lblFrame.size.width = [text boundingRectWithSize:lblAddress.frame.size
//                                                 options:NSStringDrawingUsesLineFragmentOrigin
//                                              attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Antenna-Regular" size:8]}
//                                                 context:nil].size.width+20;
//        lblFrame.size.height = 40;
        
    }
    
    return self;
}

-(void)showInView:(UIView *)view {
    
    [view addSubview:self];
    self.alpha = 0;
    
    [UIView  animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hideView {
    [UIView animateWithDuration:.2
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}


@end
