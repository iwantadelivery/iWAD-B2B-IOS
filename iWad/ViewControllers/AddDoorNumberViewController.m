//
//  AddDoorNumberViewController.m
//  iWAD
//
//  Created by Himal Madhushan on 4/8/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "AddDoorNumberViewController.h"

@interface AddDoorNumberViewController () <UITextFieldDelegate> {
    __weak IBOutlet UITextField *txtDoorNumber;
    __weak IBOutlet UIButton *btnAdd;
}

@end

@implementation AddDoorNumberViewController
@synthesize delivery, delegate = _delegate, doorNumberType;

-(void)viewWillAppear:(BOOL)animated {
    [txtDoorNumber becomeFirstResponder];
    if (doorNumberType == DoorNumberTypeFrom) {
        if (delivery.doorNumberFrom) {
            txtDoorNumber.text = delivery.doorNumberFrom;
        }
    } else if (doorNumberType == DoorNumberTypeTo) {
        if (delivery.doorNumberTo) {
            txtDoorNumber.text = delivery.doorNumberTo;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setPreferredContentSize:CGSizeMake(300, 150)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (IBAction)addDoorNumber:(UIButton *)sender {
    if (doorNumberType == DoorNumberTypeFrom) {
        delivery.doorNumberFrom = txtDoorNumber.text;
        if ([_delegate respondsToSelector:@selector(deliveryDoorNumberAdded:)]) {
            [_delegate deliveryDoorNumberAdded:delivery.doorNumberFrom];
        }
        
    } else if (doorNumberType == DoorNumberTypeTo) {
        delivery.doorNumberTo = txtDoorNumber.text;
        if ([_delegate respondsToSelector:@selector(deliveryDoorNumberAdded:)]) {
            [_delegate deliveryDoorNumberAdded:delivery.doorNumberTo];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == txtDoorNumber) {
        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (newText.length == 0) {
            btnAdd.enabled = YES;
        } else {
            btnAdd.enabled = YES;
        }
    }
    return YES;
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
