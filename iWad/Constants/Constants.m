//
//  Constants.m
//  iWad
//
//  Created by Saman Kumara on 12/15/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "Constants.h"

//NSString * const BASE_URL = @"http://192.168.10.46:3000/api/v1/b2b";      /// static IP
//NSString * const BASE_URL = @"http://iwaduat.app-tivate.com/api/v1/b2b";  // UAT
//NSString * const BASE_URL = @"http://iwad.app-tivate.com/api/v1/b2b";       // Live
NSString * const BASE_URL = @"http://iwadbackoffice.com/api/v1/b2b";       // Live App Store

//NSString * const BASE_IMAGE_URL = @"http://iwaduat.app-tivate.com";       // UAT
//NSString * const BASE_IMAGE_URL = @"http://192.168.10.46:3000";       // Static
//NSString * const BASE_IMAGE_URL = @"http://iwad.app-tivate.com";            // Live
NSString * const BASE_IMAGE_URL = @"http://iwadbackoffice.com";            // Live App Store

//NSString * const BASE_SIGNATURE_IMAGE_URL = @"http://iwaduat.app-tivate.com/assets/deliveries/signature/";  //UAT
//NSString * const BASE_SIGNATURE_IMAGE_URL = @"http://iwad.app-tivate.com/assets/deliveries/signature/";  //LIVE
NSString * const BASE_SIGNATURE_IMAGE_URL = @"http://iwadbackoffice.com/assets/deliveries/signature/";  //LIVE App Store

NSString * const userLoginURL = @"/users/login";
NSString * const userRegisterURL = @"/users";
NSString * const promoCodesURL = @"/promocodes";
NSString * const createNewDeliveryURL = @"/deliveries";
NSString * const allDeliveriesURL = @"/deliveries";
NSString * const updateUserURL = @"/users/";
NSString * const driversURL = @"/drivers";
NSString * const changePasswordURL = @"/users/change_password";
NSString * const userLogoutURL = @"/users/logout";
NSString * const vehiclesURL = @"/vehicle_types";

float const COST_PER_MILE_VAN = 17;
float const COST_PER_MILE_CAR = 17;
float const COST_PER_MILE_BIKE = 17;

NSString  * const VEHICLE_TYPE_CAR = @"Car";
NSString  * const VEHICLE_TYPE_VAN = @"Van";
NSString  * const VEHICLE_TYPE_BIKE = @"Bike";

NSString  * const VEHICLE_DIMENSION_BIKE = @"No larger than A3";
NSString  * const VEHICLE_DIMENSION_CAR = @"32 A4 Boxes";
NSString  * const VEHICLE_DIMENSION_VAN = @"130 A4 Boxes";

NSString  * const VEHICLE_PAYLOAD_BIKE = @"Less than 5Kgs";
NSString  * const VEHICLE_PAYLOAD_CAR = @"Max 400 Kgs";
NSString  * const VEHICLE_PAYLOAD_VAN = @"Max 500 Kgs";

NSString  * const IWAD_DATE_FORMAT = @"yyyy-MM-dd";
NSString  * const IWAD_ERROR_INVALID_EMAIL = @"Invalid email";
NSString  * const IWAD_ERROR_PASSWORD_DOESNOT_MATCH = @"";
NSString  * const IWAD_ERROR_PASSWORD_LENGTH_WRONG = @"";
NSString  * const IWAD_ERROR_EMPTY_FIELD = @"";
NSString  * const IWAD_ERROR_ENTER_DATE_TIME_LATER_DELIVERIES = @"Please select a date and time for later deliveries";
NSString  * const IWAD_ERROR_ENTER_EMAIL = @"Please enter your email address";
NSString  * const IWAD_ERROR_ENTER_NAME = @"Please enter client's name";
NSString  * const IWAD_ERROR_ENTER_DATE_TIME = @"Please select date and time";
NSString  * const IWAD_ERROR_TITLE_SORRY = @"Sorry!";
NSString  * const IWAD_ERROR_TITLE_ERROR = @"Error!";
NSString  * const IWAD_ERROR_NO_INTERNET = @"No working internet connection is found.\nPlease check your internet connection!";
NSString  * const IWAD_ERROR_MSG_GENERAL = @"Please fill the required field(s)";
NSString  * const IWAD_ERROR_NOT_APPLICABLE = @"N/A";

NSString  * const IWAD_ERROR_CANT_SEND_MAILS = @"Can't send mails. Please configure mail settings";
NSString  * const IWAD_ERROR_ALERT_OK_TITLE = @"OK";
NSString  * const IWAD_ERROR_NOT_VALID_PHONE = @"Please enter a valid phone number";
NSString  * const IWAD_ERROR_PASSWORD_NOT_MATCH = @"Passwords do not match";

NSString  * const DELIVERY_STATUS_WAITING_FOR_ACCEPT = @"WaitingForAccept";
NSString  * const DELIVERY_STATUS_ROUTE_TO_PICKUP = @"EnRouteToDeliver";
NSString  * const DELIVERY_STATUS_ROUTE_TO_DELIVER = @"EnRouteToPickUp";
NSString  * const DELIVERY_STATUS_PICKEDUP = @"PickedUp";
NSString  * const DELIVERY_STATUS_DELIVERED = @"Delivered";

NSString  * const SAVE_AUTO_LOGOUT_TIME = @"SAVE_AUTO_LOGOUT_TIME";

NSString  * const DELIVERY_AWAITING_FOR_DRIVER = @"Allocating Driver";
NSString  * const DELIVERY_DRIVER_ALLOCATED = @"Driver Allocated";
NSString  * const DELIVERY_PLACED = @"Delivery Placed";
NSString  * const DELIVERY_EnROUTE_TO_DELIVER = @"En Route To Deliver";


#pragma mark - Stripe

//CA Stripe account
//NSString  * const IWAD_TEST_StripePublishableKey = @"pk_test_jHMLil2Q39DS81HsbxNUbRk6";
//NSString  * const IWAD_LIVE_StripePublishableKey = @"pk_live_OtDSTnVXRKV6QgCMb8U3bTg9";

//Stripe given by Suleman
NSString  * const IWAD_TEST_StripePublishableKey = @"pk_test_xfx3C2Zk2BI0MzVLTXubiZFs";
NSString  * const IWAD_LIVE_StripePublishableKey = @"pk_live_Ks57GyXAgOTSkd56RDBj3XAb";

@implementation Constants



@end
