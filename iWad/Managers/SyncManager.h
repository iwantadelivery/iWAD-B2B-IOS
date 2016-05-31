//
//  WebServiceManager.h
//  iWad
//
//  Created by Himal Madhushan on 1/8/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - SyncManager Delegate

@protocol SyncManagerDelegate <NSObject>

@optional

/**
 *  Tell the SyncManager delegate that the web service response has been successfully recieved.
 *
 *  @param response recieved response
 *  @param tag      tag of the request
 */
-(void)syncManagerResponseSuccessWithResponse:(NSDictionary *)response withTag:(NSInteger)tag;
/**
 *  Tell the SyncManager delegate that unable to request the web service.
 *
 *  @param error error
 *  @param tag   tag of the request
 */
-(void)syncManagerResponseFailedWithError:(NSError *)error withTag:(NSInteger)tag;

@end



@interface SyncManager : NSObject

/**
 *  Initiates the WebServiceManager.h with the delegate "SyncManagerDelegate".
 */
-(instancetype)initWithDelegate:(id<SyncManagerDelegate>)delegate;

@property (nonatomic,weak) id <SyncManagerDelegate> syncDelegate;


#pragma mark - User
/**
 *  Will login user with email and password.
 *
 *  @param params User registered email and password
 *  @param view   Parent view
 */
-(void)loginUser:(NSDictionary *)params parentView:(UIView *)view ;

/**
 *  Sends information to change password of the user.
 *
 *  @param params Parameters
 *  @param view   Parent view
 */
-(void)changePassword:(NSDictionary *)params parentView:(UIView *)view;

/**
 *  Will register a new user.
 *
 *  @param params User's basic information
 *  @param view   Parent view
 */
- (void)registerUser:(NSDictionary *)params parentView:(UIView *)view;

/**
 *  Will update user profile on backend. Profile pic upload will be done here.
 *
 *  @param params user parameters dictionary
 */
- (void)updateUserProfile:(NSDictionary *)params files:(NSArray *)filesArr parentView:(UIView *)view;

/**
 *  Getting user details from the backend.
 */
- (void)fetchUserDetailsInView:(UIView *)view;

/**
 *  Will logout user from the server too. End session.
 *
 *  @param view parent view
 */
- (void)logoutUserInView:(UIView *)view;


#pragma mark - Delivery

/**
 *  Will create a new ndelivery on the backend.
 *
 *  @param params       delivery parameters and values
 *  @param paymentToken token received from Stripe
 */
- (void)createDelivery:(NSDictionary *)params token:(NSString *)paymentToken parentView:(UIView *)view;

/**
 *  Will fetch all the promo codes the user has from the backend.
 */
- (void)fetchPromoCodes;

/**
 *  Will fetch all deliveries the user has created.
 */
- (void)fetchAllDeliveriesInView:(UIView *)view;

/**
 *  Will fetch the active location of the driver of a delivery.
 *
 *  @param driverID Driver ID
 */
- (void)fetchDriverLocationOfDeliveryForDriverID:(NSString *)driverID;

/**
 *  Will update CoreData when push notification came in.
 *
 *  @param userInfo Push notification dictionary
 */
- (void)updateDeliveryForPushInfo:(NSDictionary *)userInfo;

/**
 *  Fetches all vehicle types.
 */
- (void)fetchVehicles;

#pragma mark - Drivers
/**
 *  Will fetch all drivers
 */
- (void)fetchAllDrivers;

/**
 *  Will fetch all drivers who are available for delivery allocation from the backend.
 *
 *  @param view Parent view
 */
- (void)fetchAvailableDriversInView:(UIView *)view;

@end
