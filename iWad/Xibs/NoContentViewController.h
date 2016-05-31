//
//  NoContentViewController.h
//  iWAD
//
//  Created by Himal Madhushan on 2/16/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NoContentViewController;
@protocol NoContentDelegate <NSObject>

@optional

/**
 *  Tells the delegate that button was tapped.
 *
 *  @param view NoContentViewController
 *  @param type Delivery type - Now or Later
 */
-(void)noContentView:(NoContentViewController *)view buttonTappedWithType:(DeliveryType)type;

@end

@interface NoContentViewController : UIViewController
@property (nonatomic, assign) id <NoContentDelegate> delegate;
@end
