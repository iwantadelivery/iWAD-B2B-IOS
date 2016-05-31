//
//  AddDoorNumberViewController.h
//  iWAD
//
//  Created by Himal Madhushan on 4/8/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DoorNumberType) {
    DoorNumberTypeFrom = 0,
    DoorNumberTypeTo = 1
};

@protocol DoorNumberDelegate <NSObject>
@optional
- (void)deliveryDoorNumberAdded:(nullable NSString *)doorNumber;
@end

@interface AddDoorNumberViewController : UIViewController
@property (nonatomic, strong, nullable) Delivery * delivery;
@property (nonatomic, assign) DatePickerType doorNumberType;
@property (nonnull, assign) id <DoorNumberDelegate> delegate;
@end
