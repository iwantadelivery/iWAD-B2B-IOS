//
//  LocationPopupViewController.h
//  iWAD
//
//  Created by Himal Madhushan on 2/5/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LocationType){
    LocationTypeFrom,
    LocationTypeTo
};

@interface LocationPopupViewController : UIView

-(instancetype)initWithType:(LocationType)type address:(NSString *)address frame:(CGRect)frame;

-(void)showInView:(UIView*)view;

@end
