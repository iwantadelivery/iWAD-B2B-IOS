//
//  DatePickerViewController.h
//  iWad
//
//  Created by Himal Madhushan on 1/12/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DatePickerType) {
    DatePickerTypeDate = 0,
    DatePickerTypeTime = 1
};

@protocol DatePickerDelegate <NSObject>

@optional

-(void)datePicker:(UIDatePicker *)datepicker didPickDate:(NSDate *)date type:(DatePickerType)type;

@end

@interface DatePickerViewController : UIViewController

@property (nonatomic,weak) id <DatePickerDelegate> delegate;
@property (nonatomic, assign) DatePickerType pickerType;
@property (nonatomic, assign) BOOL datePickerFromRegister, isDeliveryDate;

@end
