//
//  ForgotPasswordViewController.m
//  iWAD
//
//  Created by Himal Madhushan on 1/13/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController () <UITextFieldDelegate> {
    
    __weak IBOutlet IWadTextField *txtEmail;
}

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions
- (IBAction)sendPassword:(iWadButton *)sender {
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Text Field Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField {
//    [UIView animateWithDuration:0.4 animations:^{
//        self.view.transform = CGAffineTransformMakeTranslation(0, -100);
//    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([event touchesForView:self.view]) {
        [UIView animateWithDuration:0.4 animations:^{
            [txtEmail resignFirstResponder];
            self.view.transform = CGAffineTransformMakeTranslation(0, 0);
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

// Called when the UIKeyboardDidShowNotification is sent.

- (void)keyboardAppeared:(NSNotification*)aNotification {
    [UIView animateWithDuration:0.4 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -100);
    }];
}

-(void)keyboardDidHide:(NSNotification*)aNotification {
    [UIView animateWithDuration:0.4 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
