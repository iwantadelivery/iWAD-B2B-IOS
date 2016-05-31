//
//  BaseViewController.m
//  iWad
//
//  Created by Saman Kumara on 12/11/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () {
    UILabel *label;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [super viewDidLoad];
    [self setBackgroudImage];
    self.navigationItem.title = @"";
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, 0, 200, 40)];
    label.textColor = [UIColor whiteColor];
//    label.text = [self getTitlle];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
}

-(void)setBackgroudImage{
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [backgroundImageView setImage:[UIImage imageNamed:@"splashBg"]];
    [self.view insertSubview:backgroundImageView atIndex:0];
}

-(NSString *)getTitlle {
    return @"";
}

-(void)setLabelTit:(NSString *)labelTit{
    label.text = labelTit;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
