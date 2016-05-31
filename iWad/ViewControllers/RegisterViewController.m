//
//  RegisterViewController.m
//  iWad
//
//  Created by Saman Kumara on 12/14/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "RegisterViewController.h"
#import "DatePickerViewController.h"
#import "CountryCodePickerViewController.h"
#import "MainViewController.h"
#import "NSDate+Category.h"

@interface RegisterViewController () <DatePickerDelegate, SyncManagerDelegate, CountryCodePickerDelegate> {
    IBOutlet UIScrollView *scrollView;
    UITextField *activeField;
    NSString * gender;
    __weak IBOutlet UILabel *lblCountryCode;
    __weak IBOutlet UIButton *btnRegister;
    __weak IBOutlet IWadTextField *txtOrganisationName;
    NSString * dob;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UITextField *mobileTxt;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTxt;
@property (weak, nonatomic) IBOutlet UITextField *ddTxt;
@property (weak, nonatomic) IBOutlet UITextField *mmTxt;
@property (weak, nonatomic) IBOutlet UITextField *yyyyTxt;
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;

@end

@implementation RegisterViewController


- (void)viewDidLoad {
    [self registerForKeyboardNotifications];
    [super viewDidLoad];
    [lblCountryCode adjustsFontSizeToFitWidth];
    gender = [NSString new];
}


-(IBAction)tapBack:(UIButton *)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)tapGenderButton:(UIButton *)sender {
    [self resetButtons];
    sender.selected = YES;
    if (sender.tag == 0) {
        gender = @"MALE";
    } else {
        gender = @"FEMALE";
    }
}

- (IBAction)tapRegister:(id)sender {
    
    if ([BaseUtilClass isConnectedToInternetInVC:self]) {
        dob = [self.yyyyTxt.text stringByAppendingFormat:@"-%@-%@", self.mmTxt.text, self.ddTxt.text];
        
        /*
        if ([gender isEmpty] || [gender isKindOfClass:[NSNull class]]) {
            [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:@"Please selecet your gender." actionTitle:@"OK"];
            return;
        } else if ([self.nameTxt.text isEmpty]) {
            [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:@"Please enter your name." actionTitle:@"OK"];
            return;
        } else if ([self.emailTxt.text isEmpty]){
            [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:@"Please enter your email address." actionTitle:@"OK"];
            return;
        } else if ([self.yyyyTxt.text isEmpty]){
            [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:@"Please enter your date of birth." actionTitle:@"OK"];
            return;
        } else if ([self.mobileTxt.text isEmpty] || [lblCountryCode.text isEmpty]){
            [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:@"Please enter your country code and mobile number." actionTitle:@"OK"];
            return;
        } else */
        
        if ([gender isEmpty] || [gender isKindOfClass:[NSNull class]] ||
            [self.nameTxt.text isEmpty] ||
            [self.emailTxt.text isEmpty] ||
            [self.yyyyTxt.text isEmpty] ||
            [self.mobileTxt.text isEmpty] || [lblCountryCode.text isEmpty]) {
            [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:IWAD_ERROR_MSG_GENERAL actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
            return;
        }
        
        if (![self.mobileTxt.text isValidPhoneNumber]) {
            [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:IWAD_ERROR_NOT_VALID_PHONE actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
            return;
        }
        
        if (![self.passwordTxt.text isEqualToString:self.confirmPasswordTxt.text]) {
            [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:IWAD_ERROR_PASSWORD_NOT_MATCH actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
            return;
        }
        NSString *pushToken;
        if ([AppDelegate sharedInstance].pushToken) {
            pushToken = [AppDelegate sharedInstance].pushToken;
        }else {
            pushToken = @"SIMULATOR_PUSH";
        }
        btnRegister.enabled = NO;
        SyncManager * sm = [[SyncManager alloc] initWithDelegate:self];
        NSDictionary * params = @{@"user[email]":self.emailTxt.text,
                                  @"user[name]":self.nameTxt.text,
                                  @"user[password]":self.passwordTxt.text,
                                  @"user[password_confirmation]":self.confirmPasswordTxt.text,
                                  @"user[date_of_birth]":dob,
                                  @"user[gender]":gender,
                                  @"user[phone_no]":self.mobileTxt.text,
                                  @"push_token":pushToken,
                                  @"device_type":@"IPHONE",
                                  @"user[country_code]":[NSString stringWithFormat:@"%@",lblCountryCode.text]};
        [sm registerUser:params parentView:self.navigationController.view];
    }
}

- (IBAction)tapDateOfBirth:(id)sender {
    
}

-(void)resetButtons{
    self.maleBtn.selected = NO;
    self.femaleBtn.selected = NO;
}

#pragma mark - Sync Manager Delegate
-(void)syncManagerResponseSuccessWithResponse:(NSDictionary *)response withTag:(NSInteger)tag{
    
    btnRegister.enabled = YES;
    if ([[response objectForKey:@"success"] isEqualToString:@"false"]) {
        
        NSArray * messageArray = [response objectForKey:@"errors"];
        NSString * message = [NSString string];
        
        for (NSString * msg in messageArray) {
            message = [message stringByAppendingFormat:@" %@",msg];
        }
        
        [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:message actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
        
    } else if ([[response objectForKey:@"success"] isEqualToString:@"true"]){
        NSDictionary * userDic = [response valueForKey:@"user"];
        [[AppDelegate sharedInstance] login:YES];
        
        NSString *cc = [NSString string];
        if ( [[userDic valueForKey:@"country_code"] isKindOfClass:[NSNull class]] || [[userDic valueForKey:@"country_code"] isEqualToString:@"<null>"]) {
            cc = @"";
        } else {
            cc = [NSString stringWithFormat:@"+%@",[userDic valueForKey:@"country_code"]];
        }
        
        NSString *pushToken;
        if ([AppDelegate sharedInstance].pushToken) {
            pushToken = [AppDelegate sharedInstance].pushToken;
        }else {
            pushToken = @"SIMULATOR_PUSH";
        }
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUSER_LOGGED];
        [CoreDataManager saveUserProfileDetails:self.nameTxt.text
                                          email:self.emailTxt.text
                                    phoneNumber:self.mobileTxt.text
                                          token:[userDic valueForKey:@"token"]
                                         userID:[userDic valueForKey:@"id"]
                                         gender:gender
                                            dob:dob
                                      pushToken:pushToken
                                    countryCode:cc];
    }
    
}


#pragma mark - Text Field Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameTxt) {
        [self.emailTxt becomeFirstResponder];
    } else if (textField == self.emailTxt) {
        [self.passwordTxt becomeFirstResponder];
    } else if (textField == self.passwordTxt) {
        [self.confirmPasswordTxt becomeFirstResponder];
    } else if (textField == self.confirmPasswordTxt) {
        [self.mobileTxt becomeFirstResponder];
    } else if (textField == self.mobileTxt) {
        [self.mobileTxt resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    activeField = nil;
}


#pragma mark - Keyboard

- (void)registerForKeyboardNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        [scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}



// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}


-(NSString *)getTitlle {
    return @"Register";
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"datePickerSegue"]) {
        DatePickerViewController * dp = [segue destinationViewController];
        dp.delegate = self;
        dp.pickerType = DatePickerTypeDate;
        dp.datePickerFromRegister = YES;
        [BaseUtilClass setPopOverArrowColorForViewController:dp];
    }
    
    if ([segue.identifier  isEqual: @"ccPicker"]) {
        CountryCodePickerViewController * dp = [segue destinationViewController];
        dp.delegate = self;
        [BaseUtilClass setPopOverArrowColorForViewController:dp];
    }
}


#pragma mark - Date Picker Delegate
-(void)datePicker:(UIDatePicker *)datepicker didPickDate:(NSDate *)date type:(DatePickerType)type{
    NSLog(@"%@",date);
    
    if (date == [NSDate date]) {
        [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:@"Invalid date of birth." actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
        return;
    }
    
    NSString * month = [date stringFromFormat:@"MM"];
    self.mmTxt.text = month;
    
    NSString * year = [date stringFromFormat:@"yyyy"];
    self.yyyyTxt.text = year;
    
    NSString * dat = [date stringFromFormat:@"dd"];
    self.ddTxt.text = dat;
    
}

#pragma mark - Country Code Picker Delegate
-(void)countryCodePicker:(UIPickerView *)datepicker didPickCode:(NSString *)code {
    lblCountryCode.text = [NSString stringWithFormat:@"+%@",code];
}

#pragma mark - Touch
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([event touchesForView:self.view] || [event touchesForView:scrollView]) {
        [self.nameTxt resignFirstResponder];
        [self.mobileTxt resignFirstResponder];
        [self.passwordTxt resignFirstResponder];
        [self.confirmPasswordTxt resignFirstResponder];
        [self.emailTxt resignFirstResponder];
    }
}
@end
