//
//  IWadAlertViewController.m
//  iWAD
//
//  Created by Himal Madhushan on 2/4/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "IWadAlertViewController.h"

@interface IWadAlertViewController () {
    
    __weak IBOutlet UIView *viewContainer;
    __weak IBOutlet UIButton *btnCancel;
    __weak IBOutlet iWadButton *btnOK;
    __weak IBOutlet UILabel *lblMessage;
}

@end

@implementation IWadAlertViewController

@synthesize delegate = _delegate, alertType;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect selfFrame = self.view.frame;
    selfFrame = [BaseUtilClass superView].frame;
    selfFrame.origin.x -= 129;
    self.view.frame = selfFrame;
    
    self.view.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1;
    }];
    
    //shadow
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:viewContainer.bounds];
    viewContainer.layer.shadowOffset = CGSizeMake(-15, 15);
    viewContainer.layer.shadowOpacity = 0.5;
    viewContainer.layer.shadowRadius = 15;
    viewContainer.layer.masksToBounds = NO;
    viewContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    viewContainer.layer.shadowPath = shadowPath.CGPath;
    
    //rounded corner
    viewContainer.layer.borderWidth = 1;
    viewContainer.layer.borderColor = [UIColor colorWithRed:0.5412 green:0.5529 blue:0.5804 alpha:1.0].CGColor;
    viewContainer.layer.cornerRadius = 5;
//    viewContainer.clipsToBounds = YES;
    
    btnCancel.layer.cornerRadius = btnCancel.frame.size.height / 2;
    btnCancel.clipsToBounds = YES;
    btnCancel.layer.borderColor = [UIColor colorWithRed:0.5412 green:0.5529 blue:0.5804 alpha:1.0].CGColor;
    btnCancel.layer.borderWidth = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)didPressOk:(iWadButton *)sender {
    if ([_delegate respondsToSelector:@selector(alertView:didAccept:)]) {
        [_delegate alertView:self didAccept:YES];
    }
    
}

- (IBAction)didPressCancel:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(alertView:didAccept:)]) {
        [_delegate alertView:self didAccept:NO];
    }
}

-(void)setMessage:(NSString *)message {
    lblMessage.text = message;
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
