//
//  AvailableDriversViewController.h
//  iWAD
//
//  Created by Himal Madhushan on 2/11/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectDriverDelegate <NSObject>

@optional

-(void)driverSelected:(IWadDriver *)driver;

@end

@interface SelectDriverViewController : UIViewController
@property (nonatomic, weak) id <SelectDriverDelegate> delegate;
@property (nonatomic, strong) IWadDriver *selectedDriver;
@property (nonatomic, strong) Delivery *delivery;
@end
