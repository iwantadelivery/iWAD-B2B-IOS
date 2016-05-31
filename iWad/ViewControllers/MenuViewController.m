//
//  MenuViewController.m
//  iWad
//
//  Created by Saman Kumara on 12/14/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "MenuViewController.h"
#import "DeliveriesViewController.h"
#import "DriversViewController.h"
#import "HelpViewController.h"
#import "MainViewController.h"
#import "ProfileViewController.h"
#import "IWADNavigationViewController.h"
#import "RoundedImageView.h"
#import "NewDeliveryNewPaymentViewController.h"
#import "IWadAlertViewController.h"

@interface MenuViewController () <ProfileViewDelegate, SyncManagerDelegate, AlertDelegate> {
    UIColor *normalBackgroundColor, *selectedBackgroundColor;
    __weak IBOutlet UIButton * btnDelivers;
    __weak IBOutlet UILabel * lblUserName;
    __weak IBOutlet RoundedImageView *imgViewUserPic;
    IWadAlertViewController *alertVC;
    DeliveriesViewController * deliveriesVC;
    
}
@property (weak, nonatomic) IBOutlet UIView *deliveriesView;
@property (weak, nonatomic) IBOutlet UIView *driversView;
@property (weak, nonatomic) IBOutlet UIView *helpViews;
@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UIView *paymentView;

@property (nonatomic, strong) UIView        *currentView;
@property (nonatomic, strong) UIView        *yellowLineView;

@end

@implementation MenuViewController

-(void)viewWillAppear:(BOOL)animated {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        lblUserName.text = [CoreDataManager user].userName;
        lblUserName.alpha = 0;
        imgViewUserPic.alpha = 0;
        if (![CoreDataManager user].userImage) {
            SyncManager *sm = [[SyncManager alloc] initWithDelegate:self];
            [sm fetchUserDetailsInView:[BaseUtilClass superView]];
            imgViewUserPic.image = [UIImage imageNamed:@"userProfDefaultPic"];
        } else {
            imgViewUserPic.image = [UIImage imageWithData:[CoreDataManager user].userImage];
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            lblUserName.alpha = 1;
            imgViewUserPic.alpha = 1;
        }];
        
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    normalBackgroundColor = [UIColor colorWithRed:0.176 green:0.184 blue:0.224 alpha:1.000]; //UIColorFromRGB(0x2D2F39);
    selectedBackgroundColor = [UIColor colorWithRed:0.0635 green:0.0656 blue:0.0788 alpha:1.0]; //UIColorFromRGB(0x101014);
    self.yellowLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 4, 100)];
    self.yellowLineView.backgroundColor = [UIColor colorWithRed:0.9569 green:0.5686 blue:0.1176 alpha:1.0];
    
    [self tapMenuItem:btnDelivers];
    
//    imgViewUserPic.image = [self loadUserProfImage];
}

-(IBAction)tapMenuItem:(UIButton *)sender {
    
    [self resetCurrentView];
    
    if (sender.tag == 0) {
        
        [self highlightView:self.deliveriesView];
        deliveriesVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DeliveriesVC"];
        [(IWADNavigationViewController *)self.revealViewController.rightViewController setViewControllers:@[deliveriesVC] animated:NO];
        
    }else if (sender.tag == 1) {
        
        [self highlightView:self.driversView];
        [(IWADNavigationViewController *)self.revealViewController.rightViewController setViewControllers:@[[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DriversViewController"]] animated:NO];

    }else if (sender.tag == 2) {
        
        [self highlightView:self.helpViews];
        [(IWADNavigationViewController *)self.revealViewController.rightViewController setViewControllers:@[[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HelpViewController"]] animated:NO];
        
    }else if (sender.tag == 3) {
        
        [self highlightView:self.profileView];
        ProfileViewController * pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        pvc.delegate = self;
        [(UINavigationController *)self.revealViewController.rightViewController setViewControllers:@[pvc] animated:NO];
        
    } else if (sender.tag == 4) {
        
        [self highlightView:self.paymentView];
        [(IWADNavigationViewController *)self.revealViewController.rightViewController setViewControllers:@[[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaymentMethodsViewController"]] animated:NO];
        
    }
    else if (sender.tag == 5) {
//        [self showConfirmationAlert];
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure you want to logout?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SyncManager *sm = [[SyncManager alloc] initWithDelegate:self];
            [sm logoutUserInView:[BaseUtilClass superView]];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertCon addAction:okAction];
        [alertCon addAction:cancelAction];
        [self presentViewController:alertCon animated:YES completion:^{
            
        }];
    }

    self.currentView = sender.superview;
}

-(void)resetCurrentView {
    for (id view in self.currentView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *imgView = (UIImageView *) view;
            [imgView setHighlighted:NO];
        }else if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *) view;
            [label setTextColor:[UIColor colorWithRed:0.5451 green:0.5529 blue:0.5804 alpha:1.0]];
        }
    }
    self.currentView.backgroundColor = normalBackgroundColor;
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
    self.yellowLineView.frame = CGRectMake(0, 0, 4, superView.frame.size.height);
    [superView addSubview:self.yellowLineView];
    superView.backgroundColor = selectedBackgroundColor;
}


-(void)showConfirmationAlert {
    alertVC = [[IWadAlertViewController alloc] initWithNibName:@"IWadAlertViewController" bundle:nil];
    CGRect waitFrame = alertVC.view.frame;
    waitFrame = [BaseUtilClass superView].frame;
    waitFrame.origin.x -= 129;
//    waitFrame.origin.y -= 64;
    alertVC.view.frame = waitFrame;
    alertVC.delegate = self;
    [self addChildViewController:alertVC];
    [[BaseUtilClass superView] addSubview:alertVC.view];
//    [[BaseUtilClass superView] insertSubview:alertVC.view aboveSubview:deliveriesVC.view];
    
    [alertVC setMessage:@"Are you sure you want to logout?"];
    
    alertVC.view.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        alertVC.view.alpha = 1;
    }];
}


#pragma mark - Alert Delegate

-(void)alertView:(IWadAlertViewController *)alertView didAccept:(BOOL)accept {
    if (accept) {
        
    }
    [UIView animateWithDuration:0.3 animations:^{
        alertVC.view.alpha = 0;
    } completion:^(BOOL finished) {
        [alertVC willMoveToParentViewController:nil];
        [alertVC.view removeFromSuperview];
        [alertVC removeFromParentViewController];
    }];
}

#pragma mark - ProfileViewDelegate

-(void)userDidPickImage:(UIImage *)userImage {
    imgViewUserPic.image = userImage;
    lblUserName.text = [CoreDataManager user].userName;
}


#pragma mark - SyncManagerDelegate

-(void)syncManagerResponseSuccessWithResponse:(NSDictionary *)response withTag:(NSInteger)tag {
    if (tag == 105) {
        NSDictionary *user = [response valueForKey:@"user"];
        NSString * imageURL = [user valueForKey:@"avatar_url"];
        imageURL = [NSString stringWithFormat:@"%@%@",BASE_IMAGE_URL,imageURL];
        NSArray *arr = [imageURL componentsSeparatedByString:@"?"];
        imageURL = [arr objectAtIndex:0];
        [imgViewUserPic loadWithURLString:imageURL complete:^(UIImage *image) {
            if (!image) {
                imgViewUserPic.image = [UIImage imageNamed:@"userProfDefaultPic"];
            } else {
                User *us = [CoreDataManager user];
                us.userImage = UIImageJPEGRepresentation(image, 1);
                [CoreDataManager saveToCoreData];
                imgViewUserPic.image = image;
            }
        }];
    } else if (tag == 108) {
        if ([[response valueForKey:@"success"] isEqualToString:@"true"]) {
            [CoreDataManager logoutUser];
        }
    }
}

@end
