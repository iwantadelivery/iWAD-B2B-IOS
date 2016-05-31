//
//  IWadAlertViewController.h
//  iWAD
//
//  Created by Himal Madhushan on 2/4/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IWadAlertViewController;

@protocol AlertDelegate <NSObject>

@optional

-(void)alertView:(IWadAlertViewController *)alertView didAccept:(BOOL)accept;

@end

@interface IWadAlertViewController : UIViewController
@property (nonatomic, assign) AlertViewType alertType;
@property (nonatomic, weak) id <AlertDelegate> delegate;
-(void)setMessage:(NSString *)message;

@end
