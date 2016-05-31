//
//  IWadVehicle.h
//  iWAD
//
//  Created by Himal Madhushan on 4/20/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IWadVehicle : NSObject

/**
 *  Name of the vehicle
 */
@property (nonatomic, strong) NSString * vehicleName;

/**
 *  Vehicle type
 */
@property (nonatomic, strong) NSString * vehicleType;

/**
 *  Vehicle size
 */
@property (nonatomic, strong) NSString * vehicleDimension;

/**
 *  Vehicle payload weight
 */
@property (nonatomic, strong) NSString * vehiclePayload;

/**
 *  Vehicle type will be decided by vehicle ID
 */
@property (nonatomic, assign) NSInteger vehicleID;

@end
