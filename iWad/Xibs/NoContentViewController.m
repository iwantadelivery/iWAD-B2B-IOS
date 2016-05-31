//
//  NoContentViewController.m
//  iWAD
//
//  Created by Himal Madhushan on 2/16/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "NoContentViewController.h"

@interface NoContentViewController ()

@end

@implementation NoContentViewController
@synthesize delegate = _delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)deliveryButtonTapped:(UIButton *)sender {
    if (sender.tag == 0) {
        if ([_delegate respondsToSelector:@selector(noContentView:buttonTappedWithType:)]) {
            [_delegate noContentView:self buttonTappedWithType:DeliveryTypeNow];
        }
    } else if (sender.tag == 1) {
        if ([_delegate respondsToSelector:@selector(noContentView:buttonTappedWithType:)]) {
            [_delegate noContentView:self buttonTappedWithType:DeliveryTypeLater];
        }
    }
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
