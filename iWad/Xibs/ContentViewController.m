//
//  ContentViewController.m
//  iWad
//
//  Created by Saman Kumara on 12/17/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()
@property (nonatomic,retain) IBOutlet UILabel *label;
@end

@implementation ContentViewController


- (void)viewDidLoad {
    self.preferredContentSize = CGSizeMake(300, 80);
    
    CGRect frame = self.view.bounds;
    frame.origin.x = 20;
    frame.size.width = self.view.bounds.size.width - 40;
    self.label.frame = frame;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.1922 green:0.2 blue:0.2314 alpha:1.0];
    [super viewDidLoad];
    
//    self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
//    self.view.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
//    self.view.layer.shadowRadius = 3.0f;
//    self.view.layer.shadowOpacity = 1.0f;
    
}

-(void)loadingWithText:(NSString *)text {
    self.label.text = text;
}

@end
