//
//  WaitingViewController.m
//  iWAD
//
//  Created by Himal Madhushan on 1/18/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "WaitingViewController.h"

@interface WaitingViewController () {
    __weak IBOutlet UILabel * label;
    __weak IBOutlet UIActivityIndicatorView *indicator;
}

@end

@implementation WaitingViewController

-(void)viewWillAppear:(BOOL)animated {
    [indicator startAnimating];
}

-(void)viewWillDisappear:(BOOL)animated {
//    [indicator stopAnimating];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setMessageOnLabel:(NSString *)message {
    label.text = message;
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
