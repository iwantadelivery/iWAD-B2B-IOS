//
//  BaseUtilClass.m
//  iWAD
//
//  Created by Himal Madhushan on 1/14/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "BaseUtilClass.h"
#import "UIImage+ImageEffects.h"
#import "IWadAlertViewController.h"

@interface BaseUtilClass () {
    UIImage *blurImage;
}

@end

@implementation BaseUtilClass

+(BaseUtilClass *)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


+(UIAlertController *)showAlertViewInViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle {
    
    UIAlertController * alertCon = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(actionTitle, @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {;
                               }];
    
    [alertCon addAction:okAction];
    [viewController presentViewController:alertCon animated:YES completion:nil];
    
    return alertCon;
}

+(BOOL)isConnectedToInternetInVC:(UIViewController *)viewController {
    Reachability *reachaility = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reachaility currentReachabilityStatus];
    if (netStatus == NotReachable) {
        [self showNoInternetAlert:viewController];
        return NO;
    } else {
        return YES;
    }
}

+ (void)showNoInternetAlert:(UIViewController *)viewController {
    
    [self showAlertViewInViewController:viewController title:@"No Internet!" message:IWAD_ERROR_NO_INTERNET actionTitle:@"OK"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet!" message:IWAD_ERROR_NO_INTERNET delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [alert show];
}

+ (void)setPopOverArrowColorForViewController:(UIViewController *)viewController {
    UIPopoverPresentationController *popPC = viewController.popoverPresentationController;
    popPC.backgroundColor = IWAD_POPOVER_ARROW_COLOR;
//    popPC.permittedArrowDirections = UIPopoverArrowDirectionUp;
}

+ (void)saveUniqueDeviceIDInKeychain {
//    [SSKeychain setPassword:UUID forService:@"com.yourapp.yourcompany" account:@"user"];

}

+ (UIView *)superView {
    return [UIApplication sharedApplication].keyWindow.rootViewController.view;
}

+ (NSString *)uniqueDeviceID {
    return nil;
}

- (BOOL)responseValueIsNotNull:(id)responseVal {
    if (![responseVal isKindOfClass:[NSNull class]]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)formatDateToUKFormat:(NSString *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:IWAD_DATE_FORMAT];
    NSDate *formattedDate = [formatter dateFromString:date];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    return [formatter stringFromDate:formattedDate];
}

- (void)saveKeyChain {
    
    NSString *vendor = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice]identifierForVendor]];
    NSArray *formatted = [vendor componentsSeparatedByString:@">"];
    NSString *formattedString = [formatted objectAtIndex:1];
    NSString *secretString = [NSString stringWithFormat:@"com.b2b.%@_%@",formattedString,[CoreDataManager user].userID];
    
    NSData *secret = [secretString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *query = @{(id)kSecClass:(id)kSecClassGenericPassword,
                            (id)kSecAttrService:@"IWAD_B2B_IPAD",
                            (id)kSecAttrAccount:[CoreDataManager user].userID,
                            (id)kSecValueData:secret,
                            };
    
//    OSStatus status =
    SecItemAdd((CFDictionaryRef)query, NULL);
}

+ (void)showCustomPushOnView:(UIView *)view userInfo:(NSDictionary *)info {
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPush:gesture:)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionUp];
    
    for (UIView *subView in view.subviews) {
        if (subView.tag == 509) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                subView.alpha = 0;
                subView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [subView removeFromSuperview];
            }];
        }
    }
    
    NSDictionary *dictionary = [info valueForKey:@"aps"];
    NSString *message = [dictionary valueForKey:@"alert"];
    
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenFrame.size.width, 64)];
    contentView.backgroundColor = [UIColor colorWithRed:0.1922 green:0.2009 blue:0.2322 alpha:1.0];
    contentView.backgroundColor = [UIColor clearColor];
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithFrame:CGRectMake(0, -64, screenFrame.size.width, 64)];
    [effectView addGestureRecognizer:swipeGesture];
    [self dismissPush:effectView gesture:swipeGesture];
    effectView.tag = 509;
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    effectView.effect = blurEffect;
    effectView.alpha = 1;
    [effectView.contentView addSubview:contentView];
    [effectView addGestureRecognizer:swipeGesture];
    
    UIView *textContainer = [[UIView alloc] initWithFrame:CGRectZero];
//    textContainer.backgroundColor = [UIColor redColor];
    [contentView addSubview:textContainer];
    CGRect textContainerFrame = textContainer.frame;
    
    UIImageView *imgViewAppIcon = [[UIImageView alloc] initWithFrame:CGRectMake(145, 12, 40, 40)];
    imgViewAppIcon.image = [UIImage imageNamed:@"inAppPushIcon"];
    [contentView addSubview:imgViewAppIcon];
    
    float lableWidth = [message boundingRectWithSize:CGSizeZero
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{ NSFontAttributeName:[UIFont fontWithName:@"Antenna" size:15]}
                                          context:nil].size.width;
    
    UILabel *lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(imgViewAppIcon.frame.origin.x + 65, contentView.frame.size.height/2 - 11, screenFrame.size.width - 120, 22)];
    lblMessage.text = message;
    lblMessage.font = [UIFont fontWithName:@"Antenna" size:15];
    lblMessage.textColor = [UIColor whiteColor];
    [contentView addSubview:lblMessage];
    
    textContainerFrame.size.width = lableWidth + 55;
    textContainerFrame.size.height = 64;
    textContainerFrame.origin.y = 0;
    textContainerFrame.origin.x = effectView.frame.size.width/2 - textContainerFrame.size.width/2;
    textContainer.frame = textContainerFrame;
    
    UIVisualEffectView *elapsedView = [[UIVisualEffectView alloc] initWithFrame:CGRectMake(contentView.frame.size.width/2 - 15, contentView.frame.size.height - 7, 30, 5)];
    elapsedView.layer.cornerRadius = elapsedView.frame.size.height/2;
    elapsedView.contentView.clipsToBounds = YES;
    elapsedView.clipsToBounds = YES;
    UIBlurEffect *elapsedBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    elapsedView.effect = elapsedBlurEffect;
    elapsedView.alpha = 1;
    [effectView addSubview:elapsedView];
    
    [view insertSubview:effectView atIndex:1000];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionShowHideTransitionViews animations:^{
        effectView.transform = CGAffineTransformMakeTranslation(0, +64);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:3 options:UIViewAnimationOptionCurveLinear animations:^{
            effectView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [effectView removeFromSuperview];
        }];
    }];
}

+ (void)dismissPush:(UIView *)view gesture:(UISwipeGestureRecognizer *)gesture {
    if (gesture.direction == UISwipeGestureRecognizerDirectionUp) {
        CGPoint point = [gesture locationInView:view];
        NSLog(@"x:%f , y:%f",point.x,point.y);
    }
}

+ (void)removeAlertView:(IWadAlertViewController *)alertVC {
    [alertVC willMoveToParentViewController:nil];
    [alertVC.view removeFromSuperview];
    [alertVC removeFromParentViewController];
}


#pragma mark - 

- (void)setAutologoutTimer:(NSString *)time {
    [[NSUserDefaults standardUserDefaults]setObject:time forKey:SAVE_AUTO_LOGOUT_TIME];
    [self userDefaultSynchronize];
}

- (void)userDefaultSynchronize {
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (BOOL)userIsLogged {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kUSER_LOGGED];
}

- (void)askLocationAuthorization:(CLLocationManager *)locationManager {
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    if (authorizationStatus != kCLAuthorizationStatusAuthorizedAlways || authorizationStatus != kCLAuthorizationStatusAuthorizedWhenInUse) {
        [locationManager requestAlwaysAuthorization];
    }
}
@end

