//
//  DatePickerViewController.m
//  iWad
//
//  Created by Himal Madhushan on 1/12/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController () {
    
    __weak IBOutlet UIDatePicker *iWadDatePicker;
    
}

@end

@implementation DatePickerViewController

@synthesize delegate = _delegate, pickerType, datePickerFromRegister, isDeliveryDate;

-(void)viewWillAppear:(BOOL)animated {
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
//    [iWadDatePicker setLocale:locale];
    NSDateComponents* components=[[NSDateComponents alloc] init];
    if (pickerType == DatePickerTypeDate) {
        iWadDatePicker.datePickerMode = UIDatePickerModeDate;
        /**
         *  if the this view was shown when user selects the date for user's DOB in register UI, datePickerFromRegister has to be YES. then there will be date limitations.
         *  maximum date the user will get 10 years back from the current year.
         *  minimum year will be 1900/1/1.
         */
        if (datePickerFromRegister) {
            [components setYear:1900];
            [components setMonth:1];
            [components setDay:1];
            iWadDatePicker.minimumDate = [[NSCalendar currentCalendar] dateFromComponents:components];
            
            NSDate * currentDate = [NSDate date];
            NSString * dateStr = [currentDate stringFromFormat:@"yyyy"];
            NSInteger maximumYear = [dateStr intValue]-10;
            [components setYear:maximumYear];
            [components setMonth:12];
            [components setDay:31];
            iWadDatePicker.maximumDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        } else if (isDeliveryDate) {
            iWadDatePicker.datePickerMode = UIDatePickerModeDate;
            iWadDatePicker.minimumDate = [NSDate date];
        }
        
    } else if (pickerType == DatePickerTypeTime) {
        iWadDatePicker.datePickerMode = UIDatePickerModeTime;
        
        UILabel *hours = [[UILabel alloc] initWithFrame:CGRectMake(100, 70, 50, 22)];
        UILabel *mins = [[UILabel alloc] initWithFrame:CGRectMake(165, 70, 70, 22)];
        hours.text = @"Hours";
        mins.text = @"Minutes";
        hours.textColor = [UIColor colorWithRed:0.5412 green:0.5529 blue:0.5804 alpha:1.0];
        mins.textColor = [UIColor colorWithRed:0.5412 green:0.5529 blue:0.5804 alpha:1.0];
        hours.textAlignment = NSTextAlignmentCenter;
        mins.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:hours];
        [self.view addSubview:mins];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(320, 300);
    self.view.backgroundColor = IWAD_POPOVER_ARROW_COLOR;
    [iWadDatePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Actions
- (IBAction)done:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSDate * calendar = iWadDatePicker.date;
        if ([_delegate respondsToSelector:@selector(datePicker:didPickDate:type:)]) {
            [_delegate datePicker:iWadDatePicker didPickDate:calendar type:pickerType];
        }
    }];
}

@end
