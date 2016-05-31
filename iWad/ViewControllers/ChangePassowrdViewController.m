//
//  ChnagePassowrdViewController.m
//  iWad
//
//  Created by Saman Kumara on 12/18/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "ChangePassowrdViewController.h"

@interface ChangePassowrdViewController () <SyncManagerDelegate, UITextFieldDelegate, AlertDelegate> {
    UITextField *activeField;
    IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIButton * btnChangePwd;
    __weak IBOutlet UITextField *txtOldPwd;
    __weak IBOutlet UITextField *txtNewPwd;
    __weak IBOutlet UITextField *txtConfirmPwd;
}

@end

@implementation ChangePassowrdViewController

#pragma mark - View

- (void)viewDidLoad {
    [self registerForKeyboardNotifications];
    [super viewDidLoad];
}


#pragma mark - Button Actions

- (IBAction)tapUpdateBtn:(id)sender {
    [self syncChangePwdWithServer];
}


#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == txtOldPwd) {
        [txtNewPwd becomeFirstResponder];
    } else if (textField == txtNewPwd) {
        [txtConfirmPwd becomeFirstResponder];
    } else if (textField == txtConfirmPwd) {
        [txtConfirmPwd resignFirstResponder];
        [self syncChangePwdWithServer];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    activeField = nil;
}
- (void)registerForKeyboardNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - Keyboard
// Called when the UIKeyboardDidShowNotification is sent.

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    CGRect rect = activeField.frame;
    rect.origin.y = rect.origin.y + 180;
    
    
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, rect.origin) ) {
        [scrollView scrollRectToVisible:rect animated:YES];
    }}



// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}


#pragma mark - Sync Manager Delegate

-(void)syncManagerResponseSuccessWithResponse:(NSDictionary *)response withTag:(NSInteger)tag {
    
    if ([[response valueForKey:@"success"] isEqualToString:@"true"]) {
        [BaseUtilClass showAlertViewInViewController:self title:@"Success" message:@"Password successfully changed" actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
    } else {
        NSArray * messageArray = [response objectForKey:@"errors"];
        NSString * message = [NSString string];
        message = [messageArray componentsJoinedByString:@" ,"];
        [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:message actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
    }
    txtNewPwd.text = nil;
    txtOldPwd.text = nil;
    txtConfirmPwd.text = nil;
}

#pragma mark - Other Methods

-(void)syncChangePwdWithServer {
    if (![txtNewPwd.text isEqualToString:txtConfirmPwd.text]) {
        [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:@"Passwords do not match." actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
        return;
    } else {
        NSDictionary * params = @{@"old_password":txtOldPwd.text,
                                  @"password":txtNewPwd.text,
                                  @"confirm_password":txtConfirmPwd.text};
        SyncManager * sm = [[SyncManager alloc] initWithDelegate:self];
        [sm changePassword:params parentView:[BaseUtilClass superView]];
    }
}

@end
