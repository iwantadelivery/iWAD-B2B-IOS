//
//  CountryCodePickerViewController.h
//  iWAD
//
//  Created by Himal Madhushan on 1/13/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CountryCodePickerDelegate <NSObject>

@optional

-(void)countryCodePicker:(UIPickerView *)datepicker didPickCode:(NSString *)code;

@end
@interface CountryCodePickerViewController : UIViewController

@property (nonatomic,weak) id <CountryCodePickerDelegate> delegate;

@property (nonatomic, strong) NSArray * countryCodesArray;

@end
