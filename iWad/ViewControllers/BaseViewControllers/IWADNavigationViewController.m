//
//  IWADNavigationViewController.m
//  iWAD
//
//  Created by Himal Madhushan on 1/14/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "IWADNavigationViewController.h"

@interface IWADNavigationViewController ()

@end

@implementation IWADNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"";
    
    NSDictionary *titleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"Antenna-Bold" size:14],NSFontAttributeName,
                                nil];
    
    NSDictionary *batItemAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIColor clearColor],NSForegroundColorAttributeName,
                                     nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:batItemAttributes
                                                forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:batItemAttributes
                                                forState:UIControlStateHighlighted];
    [[UIBarButtonItem appearance] setTitleTextAttributes:batItemAttributes
                                                forState:UIControlStateSelected];
    
    [[UINavigationBar appearance] setTitleTextAttributes:titleAttributes];
    
    self.navigationBar.barTintColor = [UIColor colorWithRed:0.176 green:0.184 blue:0.224 alpha:1.000];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
