//
//  BaseUtilClass.h
//  iWAD
//
//  Created by Himal Madhushan on 1/14/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@import Security;
#import "Reachability.h"
#import "IWadAlertViewController.h"

@interface BaseUtilClass : NSObject

/**
 *  Creates object from this class once in the life time of the app
 *
 *  @return self
 */
+(BaseUtilClass *)sharedInstance;

/**
 *  Will show an alert controller
 *
 *  @param viewController Showing view controller
 *  @param title          Title
 *  @param message        Body message
 *  @param actionTitle    Action title
 *
 *  @return Alert controller
 */
+(UIAlertController *)showAlertViewInViewController:(UIViewController *)viewController
                                              title:(NSString *)title
                                            message:(NSString *)message
                                        actionTitle:(NSString *)actionTitle;

/**
 *  Will check that internet is avaiable;
 *
 *  @param viewController Parent view controller
 *
 *  @return If available, return YES. else return NO.
 */
+(BOOL)isConnectedToInternetInVC:(UIViewController *)viewController;

/**
 *  Will show an alert saying "No Internet!" - UIAlertView
 *
 *  @param viewController Parent view controller
 */
//+(void)showNoInternetAlert:(UIViewController *)viewController;

/**
 *  Setting the PopOver arrow color.
 *
 *  @param viewController currently showing view controller
 */
+(void)setPopOverArrowColorForViewController:(UIViewController *)viewController;

+(void)saveUniqueDeviceIDInKeychain;

+(NSString *)uniqueDeviceID;

/**
 *  Super view of all.
 *
 *  @return The super view
 */
+(UIView *)superView;

/**
 *  Will ask user to authorize the app to get current location
 *
 *  @param locationManager Location manager
 */
- (void)askLocationAuthorization:(CLLocationManager *)locationManager;

/**
 *  Will show a customized view same as the Apple push notification
 *
 *  @param view The key view to show on
 *  @param info Push info
 */
+(void)showCustomPushOnView:(UIView *)view userInfo:(NSDictionary *)info;

+(void)removeAlertView:(IWadAlertViewController *)alertVC;

/**
 *  Saves user's logged time.
 *
 *  @param time Time string
 */
- (void)setAutologoutTimer:(NSString *)time;

/**
 *  Checks whether the user is logged in or not.
 *
 *  @return login status
 */
- (BOOL)userIsLogged;

- (BOOL)responseValueIsNotNull:(id)responseVal;

- (NSString *)formatDateToUKFormat:(NSString *)date;
@end
