//
//  LoginViewController.m
//  iWad
//
//  Created by Saman Kumara on 12/14/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "LoginViewController.h"
#import "NSString+Category.h"

@interface LoginViewController () <SyncManagerDelegate, UITextFieldDelegate> {
    SyncManager * syncManager;
    __weak IBOutlet UIButton * btnLogin;
}
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation LoginViewController

#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
    syncManager = [[SyncManager alloc] initWithDelegate:self];
    [self registerForKeyboardNotifications];
    [self.navigationController setNavigationBarHidden:YES];
}


#pragma mark - Button Actions

-(IBAction)tapLogin:(UIButton *)sender{
    sender.enabled = NO;
    if ([BaseUtilClass isConnectedToInternetInVC:self]) {
        if ([self.emailTxt.text isEmpty] || [self.passwordTxt.text isEmpty]) {
            [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:@"Please fill the required field(s)" actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
            return;
        }
        
        if ([self.emailTxt.text isValidEmail]) {
            [self authenticateLogin];
        } else {
            [BaseUtilClass showAlertViewInViewController:self title:@"Email Invalid!" message:IWAD_ERROR_INVALID_EMAIL actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
        }
    }
}

- (IBAction)tapForgotPassword:(id)sender {
    
}

-(NSString *)getTitlle {
    return @"Login";
}

-(void)authenticateLogin {
    [self.passwordTxt resignFirstResponder];
    [self.emailTxt resignFirstResponder];
    
    NSString *pushToken;
    if ([AppDelegate sharedInstance].pushToken) {
        pushToken = [AppDelegate sharedInstance].pushToken;
    }else {
        pushToken = @"SIMULATOR_PUSH";
    }
    NSDictionary * params = @{@"email" : self.emailTxt.text,
                              @"password": self.passwordTxt.text,
                              @"push_token":pushToken,
                              @"device_type":@"IPHONE"};
    [syncManager loginUser:params parentView:self.navigationController.view];
}

#pragma mark - SyncManager Delegate

-(void)syncManagerResponseSuccessWithResponse:(NSDictionary *)response withTag:(NSInteger)tag{
    
    btnLogin.enabled = YES;
    
    if ([[response objectForKey:@"success"] isEqualToString:@"false"]) {
        
        NSArray * messageArray = [response objectForKey:@"errors"];
        NSString * message = [NSString string];
        message = [messageArray componentsJoinedByString:@" ,"];
        [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:message actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
        
    } else {
        
        NSDictionary * user = [response objectForKey:@"user"];
        
        [[NSUserDefaults standardUserDefaults] setValue:self.passwordTxt.text forKey:kUSER_PASSWORD];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUSER_LOGGED];
        
        NSString *cc = [NSString string];
        if ( [[user valueForKey:@"country_code"] isKindOfClass:[NSNull class]] || [[user valueForKey:@"country_code"] isEqualToString:@"<null>"]) {
            cc = @"";
        } else {
            cc = [user valueForKey:@"country_code"];
        }
        NSString *pushToken;
        if ([AppDelegate sharedInstance].pushToken) {
            pushToken = [AppDelegate sharedInstance].pushToken;
        }else {
            pushToken = @"SIMULATOR_PUSH";
        }
        [CoreDataManager saveUserProfileDetails:[user objectForKey:@"name"]
                                          email:self.emailTxt.text
                                    phoneNumber:[user objectForKey:@"phone_no"]
                                          token:[user objectForKey:@"token"]
                                         userID:[user objectForKey:@"id"]
                                         gender:[user objectForKey:@"gender"]
                                            dob:[user objectForKey:@"date_of_birth"]
                                      pushToken:pushToken
                                    countryCode:cc];
        
        [[AppDelegate sharedInstance] login:YES];
//        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

-(void)syncManagerResponseFailedWithError:(NSError *)error withTag:(NSInteger)tag{
    [self.appDelegate login:NO];
}


#pragma mark - Text Field Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailTxt) {
        [self.passwordTxt becomeFirstResponder];
    } else {
        if ([self.emailTxt.text isEmpty]) {
            [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:IWAD_ERROR_ENTER_EMAIL actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
        } else {
            [self authenticateLogin];
        }
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.emailTxt || textField == self.passwordTxt) {
        [UIView animateWithDuration:0.4 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -50);
        }];
    }
}


#pragma mark - Keyboard

- (void)registerForKeyboardNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardAppeared:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardAppeared:(NSNotification*)aNotification {
}

-(void)keyboardDidHide:(NSNotification*)aNotification {
    [UIView animateWithDuration:0.4 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}

#pragma mark - Touch

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([event touchesForView:self.view]) {
        [self.emailTxt resignFirstResponder];
        [self.passwordTxt resignFirstResponder];
    }
}
@end
