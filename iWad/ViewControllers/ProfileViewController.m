//
//  ProfileViewController.m
//  iWad
//
//  Created by Saman Kumara on 12/18/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "ProfileViewController.h"
#import "PersonalInfoViewController.h"
#import "ChangePassowrdViewController.h"

@interface ProfileViewController () <UserProfileDelegate> {
    PersonalInfoViewController *personalCV;
    ChangePassowrdViewController *changePasswordVC;
    UIColor *normalBackgroundColor, *selectedBackgroundColor;
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *personalInfoView;
@property (weak, nonatomic) IBOutlet UIView *changePasswordView;
@property (nonatomic, strong) UIView        *yellowLineView;


@end

@implementation ProfileViewController

@synthesize delegate = _delegate;

#pragma mark - View

- (void)viewDidLoad {
    self.yellowLineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.personalInfoView.frame.size.height - 4, 4, 100)];
    self.yellowLineView.backgroundColor = IWAD_TEXT_COLOR;
    normalBackgroundColor = UIColorFromRGB(0x2D2F39);
    selectedBackgroundColor = UIColorFromRGB(0x101014);
    
    self.title = @"MY PROFILE";
    
    personalCV = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalInfoViewController"];
    personalCV.delegate = self;
    changePasswordVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChangePassowrdViewController"];
    
    [self addChildViewController:changePasswordVC];
    [self addChildViewController:personalCV];
    [self.contentView insertSubview:personalCV.view atIndex:0];
    
    [self resetCurrentView:self.changePasswordView];
    [self highlightView:self.personalInfoView];
    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [personalCV.view setFrame:self.contentView.frame];
    [changePasswordVC.view setFrame:self.contentView.frame];
}

#pragma mark - Button Actions

- (IBAction)tapTabButton:(UIButton *)sender {
    if (sender.tag ==0) {
        [changePasswordVC.view removeFromSuperview];
        [self.contentView addSubview:personalCV.view];
        [self resetCurrentView:self.changePasswordView];
        [self highlightView:self.personalInfoView];

    }else {
        [personalCV.view removeFromSuperview];
        [self.contentView addSubview:changePasswordVC.view];
        [self resetCurrentView:self.personalInfoView];
        [self highlightView:self.changePasswordView];

    }
}

-(void)resetCurrentView:(UIView *)contentView {
    for (id view in contentView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *imgView = (UIImageView *) view;
            [imgView setHighlighted:NO];
        }else if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *) view;
            [label setTextColor:[UIColor whiteColor]];
        }
    }
    [self.yellowLineView removeFromSuperview];
}

-(void)highlightView:(UIView *) superView {
    for (id view in superView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *imgView = (UIImageView *) view;
            [imgView setHighlighted:YES];
        }else if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *) view;
            [label setTextColor:IWAD_TEXT_COLOR];
        }
    }
    self.yellowLineView.frame = CGRectMake(0, self.personalInfoView.frame.size.height - 4, 150, 4);
    [superView addSubview:self.yellowLineView];
}


-(void)userDidPickImage:(UIImage *)userImage {
    if ([_delegate respondsToSelector:@selector(userDidPickImage:)]) {
        [_delegate userDidPickImage:userImage];
    }
}

@end
