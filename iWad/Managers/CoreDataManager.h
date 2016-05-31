//
//  CoreDataManager.h
//  iWAD
//
//  Created by Himal Madhushan on 1/22/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deliveries.h"
#import "User.h"

@interface CoreDataManager : NSObject

+(CoreDataManager *)sharedInstance;

/**
 *  Getting the Managed Object Context from AppDelegate.
 *
 *  @return NSManagedObjectContext
 */
+(NSManagedObjectContext *)managedObjectContext;

/**
 *  Will save content to CoreData
 *
 *  @return success YES/NO
 */
+ (BOOL)saveToCoreData;

#pragma mark - Deliveries

/**
 *  Will insert delivery data from web service. Web service written in SyncManager.
 *
 *  @param resp response object
 *
 *  @return success YES/NO
 */
+(BOOL)insertDeliveryFromResponse:(NSDictionary *)response;

/**
 *  Updates an specific deliver object.
 *
 *  @param payload PushNotification Payload
 */
//+(void)updateDeliveryStatus:(NSDictionary *)payload;

/**
 *  Will update CoreData specific delivery object when the push is recieved.
 *
 *  @param deliveryID   Delivery ID
 *  @param response     Delivery response
 */
+(void)updateDeliveryForID:(NSString *)deliveryID response:(NSDictionary *)response;

+(Deliveries *)deliverForID:(NSString *)deliverID;

#pragma mark - Promo Code

#pragma mark - User

/**
 *  Will save user details in CoreData - User
 *
 *  @param name        user name
 *  @param email       user email
 *  @param phoneNumber user phone number
 *  @param token       user token
 *  @param userID      user ID
 *  @param gender      user gender
 *  @param dob         user birthday
 *  @param pushToken   device pushNotification token
 *  @param countryCode country code
 */
+(void)saveUserProfileDetails:(NSString *)name
                        email:(NSString *)email
                  phoneNumber:(NSString *)phoneNumber
                        token:(NSString *)token
                       userID:(NSString *)userID
                       gender:(NSString *)gender
                          dob:(NSString *)dob
                    pushToken:(NSString *)pushToken
                  countryCode:(NSString *)cc;

/**
 *  The current User object.
 *
 *  @return user object
 */
+(User *)user;

/**
 *  Will remove all everything on CoreData
 */
+(void)logoutUser;
@end
