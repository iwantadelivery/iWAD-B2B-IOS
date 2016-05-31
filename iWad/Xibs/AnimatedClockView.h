//
//  AnimatedClockView.h
//  iWAD
//
//  Created by Himal Madhushan on 3/1/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimatedClockView : UIView {
    UIImageView *imgViewOuter, *imgViewHourHand, *imgViewMinuteHand;
}

/**
 *  Adding self view to parent view.
 *
 *  @param view Parent view
 */
-(void)showInView:(UIView *)view;

@end
