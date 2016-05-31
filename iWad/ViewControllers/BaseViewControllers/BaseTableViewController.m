//
//  BaseTableViewController.m
//  iWad
//
//  Created by Saman Kumara on 12/16/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController () {
    UILabel * label;
}

@end

@implementation BaseTableViewController

@synthesize labelTitle;

- (void)viewDidLoad {
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [super viewDidLoad];
    self.navigationItem.title = @"";
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    label.textColor = [UIColor whiteColor];
    label.text = [self setTitleToLabel:self.labelTitle];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
}

-(void)setBackgroudImage{
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [backgroundImageView setImage:[UIImage imageNamed:@"splashBg"]];
    [self.view insertSubview:backgroundImageView atIndex:0];
}

-(NSString *)setTitleToLabel:(NSString *)title {
    return title;
}

@end
