//
//  Delivery.h
//  iWad
//
//  Created by Saman Kumara on 12/17/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "IWadDriver.h"
#import "IWadVehicle.h"

typedef NS_ENUM(NSInteger, DeliveryType){
    DeliveryTypeNow,
    DeliveryTypeLater
};

typedef NS_ENUM(NSInteger, DriverType){
    DriverTypeAuto,
    DriverTypeManual
};

@interface Delivery : NSObject


@property (nonatomic, strong) CLPlacemark * startPlaceMark, * endPlaceMark;

/**
 *  Starting address
 */
@property (nonatomic, strong) NSString * startAddress;

/**
 *  Destination address
 */
@property (nonatomic, strong) NSString * destinationAddress;

/**
 *  Distance between startAddress and destinationAddress
 */
@property (nonatomic, assign) float distance;

/**
 *  Destination building door number from location in Miles
 */
@property (nonatomic, strong) NSString * doorNumberFrom;

/**
 *  Destination building door number to location
 */
@property (nonatomic, strong) NSString * doorNumberTo;

/**
 *  Name
 */
@property (nonatomic, strong) NSString * name;

/**
 *  Email address
 */
@property (nonatomic, strong) NSString * email;

@property (nonatomic, strong) NSString * deliveryContact;

@property (nonatomic, strong) NSString * deliveryNumber;

/**
 *  Due Date
 */
@property (nonatomic, strong) NSString * delivaryDate;

/**
 *  Due time
 */
@property (nonatomic, strong) NSString * delivaryTime;

/**
 *  Either DeliveryTypeNow = now or DeliveryTypeLater = later
 */
@property (nonatomic, assign) DeliveryType deliveryType;

/**
 *  Either DriverType = Auto or Manual
 */
@property (nonatomic, assign) DriverType driverType;

/**
 *  Driver object.
 */
@property (nonatomic, strong) IWadDriver *driver;

@property (nonatomic, strong) IWadVehicle *vehicle;

/**
 *  Delivery note
 */
@property (nonatomic, strong) NSString * note;

/**
 *  Promotion code
 */
@property (nonatomic, strong) NSString * promoCode;

/**
 *  Promo code ID
 */
@property (nonatomic, strong) NSString * promoCodeID;

/**
 *  Start location coordinates
 */
@property (nonatomic, assign) CLLocationCoordinate2D startCoord;

/**
 *  End location coordinates
 */
@property (nonatomic, assign) CLLocationCoordinate2D destinationCoord;

/**
 *  Number of people required for the job
 */
@property (nonatomic, assign) NSInteger noOfPeople;

/**
 *  Delivery ID
 */
@property (nonatomic, assign) NSInteger ID;

/**
 *  Delivary cost
 */
@property (nonatomic, assign) float cost;

+ (id)currentDelivery;


@end
