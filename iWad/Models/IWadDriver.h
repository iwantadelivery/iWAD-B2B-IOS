//
//  IWadDriver.h
//  iWAD
//
//  Created by Himal Madhushan on 1/19/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IWadDriver : NSObject

/**
 *  Driver ID
 */
@property (nonatomic, strong) NSString *driverID;

/**
 *  Driver name
 */
@property (nonatomic, strong) NSString *name;

/**
 *  Driver mobile number
 */
@property (nonatomic, strong) NSString *mobile;

/**
 *  Driver email
 */
@property (nonatomic, strong) NSString *email;

/**
 *  Driver profile photo URL
 */
@property (nonatomic, strong) NSString *imageURL;

@property (nonatomic, strong) NSString *eta;

@property (nonatomic, strong) NSString *distance;

/**
 *  Coordinates. Longitude, Latitude.
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinates;

@end
