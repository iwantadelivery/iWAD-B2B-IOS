//
//  Constants.h
//  iWad
//
//  Created by Saman Kumara on 12/15/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AlertViewType) {
    AlertViewTypeDefault,
    AlertViewTypeConfirmation
};

#pragma mark - Colors
#define IWAD_TEXT_COLOR [UIColor colorWithRed:239.9/256.0 green:126.2/256.0 blue:24.7/256.0 alpha:1.0]
#define IWAD_POPOVER_ARROW_COLOR [UIColor colorWithRed:0.1765 green:0.1843 blue:0.2235 alpha:1.0];
#define DELIVERIES_TXTCOLOR_GREY [UIColor colorWithRed:146.4/256.0 green:144.0/256.0 blue:152.0/256.0 alpha:1.0]
#define DELIVERIES_TXTCOLOR_GREEN [UIColor colorWithRed:16.1/256.0 green:191.7/256.0 blue:69.3/256.0 alpha:1.0]
#define BORDER_COLOR [UIColor colorWithRed:0.5412 green:0.5529 blue:0.5804 alpha:1.0]

#pragma mark - URL
extern NSString * const BASE_URL;
extern NSString * const BASE_IMAGE_URL;
extern NSString * const BASE_SIGNATURE_IMAGE_URL;

extern NSString * const userLoginURL;
extern NSString * const userRegisterURL;
extern NSString * const promoCodesURL;
extern NSString * const createNewDeliveryURL;
extern NSString * const allDeliveriesURL;
extern NSString * const updateUserURL;
extern NSString * const driversURL;
extern NSString * const changePasswordURL;
extern NSString * const userLogoutURL;
extern NSString * const vehiclesURL;

#pragma mark - Variables
extern float const COST_PER_MILE_VAN;
extern float const COST_PER_MILE_CAR;
extern float const COST_PER_MILE_BIKE;

#pragma mark - Vehicle
extern NSString  * const VEHICLE_TYPE_CAR;
extern NSString  * const VEHICLE_TYPE_VAN;
extern NSString  * const VEHICLE_TYPE_BIKE;

extern NSString  * const VEHICLE_DIMENSION_BIKE;
extern NSString  * const VEHICLE_DIMENSION_CAR;
extern NSString  * const VEHICLE_DIMENSION_VAN;

extern NSString  * const VEHICLE_PAYLOAD_BIKE;
extern NSString  * const VEHICLE_PAYLOAD_CAR;
extern NSString  * const VEHICLE_PAYLOAD_VAN;

extern NSString  * const IWAD_DATE_FORMAT;
extern NSString  * const IWAD_ERROR_INVALID_EMAIL;
extern NSString  * const IWAD_ERROR_PASSWORD_DOESNOT_MATCH;
extern NSString  * const IWAD_ERROR_PASSWORD_LENGTH_WRONG;
extern NSString  * const IWAD_ERROR_EMPTY_FIELD;
extern NSString  * const IWAD_ERROR_ENTER_DATE_TIME_LATER_DELIVERIES;
extern NSString  * const IWAD_ERROR_TITLE_SORRY;
extern NSString  * const IWAD_ERROR_TITLE_ERROR;
extern NSString  * const IWAD_ERROR_ENTER_EMAIL;
extern NSString  * const IWAD_ERROR_ENTER_NAME;
extern NSString  * const IWAD_ERROR_ENTER_DATE_TIME;
extern NSString  * const IWAD_ERROR_NO_INTERNET;
extern NSString  * const IWAD_ERROR_MSG_GENERAL;
extern NSString  * const IWAD_ERROR_CANT_SEND_MAILS;
extern NSString  * const IWAD_ERROR_ALERT_OK_TITLE;
extern NSString  * const IWAD_ERROR_NOT_VALID_PHONE;
extern NSString  * const IWAD_ERROR_PASSWORD_NOT_MATCH;
extern NSString  * const IWAD_ERROR_NOT_APPLICABLE;

extern NSString  * const DELIVERY_STATUS_WAITING_FOR_ACCEPT;
extern NSString  * const DELIVERY_STATUS_ROUTE_TO_PICKUP;
extern NSString  * const DELIVERY_STATUS_ROUTE_TO_DELIVER;
extern NSString  * const DELIVERY_STATUS_PICKEDUP;
extern NSString  * const DELIVERY_STATUS_DELIVERED;
extern NSString  * const DELIVERY_DRIVER_ALLOCATED;

extern NSString  * const DELIVERY_AWAITING_FOR_DRIVER;
extern NSString  * const DELIVERY_PLACED;
extern NSString  * const DELIVERY_EnROUTE_TO_DELIVER;

extern NSString  * const SAVE_AUTO_LOGOUT_TIME;

extern NSString  * const IWAD_TEST_StripePublishableKey;
extern NSString  * const IWAD_LIVE_StripePublishableKey;


#pragma mark - Defines
#define kUSER_EMAIL @"UserEmail"
#define kUSER_PASSWORD @"UserPassword"
#define kUSER_LOGGED @"UserLogged"
#define kUSER_PHONE @"PhoneNumber"
#define kUSER_NAME @"Name"
#define kUSER_TOKEN @"Token"
#define kUSER_DOB @"DOB"
#define kUSER_GENDER @"Gender"
#define kUSER_ID @"userID"
#define kUSER_PROF_PIC @"ProfilePic"

#define kNO_TIME @"NoTime"
#define kNO_DATE @"NoDate"
#define kNO_NOTE @"NoNote"

#define DateTimeFormat @"yyyy-MM-dd hh:mm:ss"

#define kCURRENT_LOCATION @"Your current location"

#define IWAD_HELP_CALL_LINE @"tel://08001700141"
#define IWAD_HELP_MAIL @"support@iwantadelivery.co.uk"

@interface Constants : NSObject

@end
