//
//  SelectVehicleViewController.h
//  iWAD
//
//  Created by Himal Madhushan on 4/19/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VehicleType) {
    VehicleTypeVan,
    VehicleTypeCar,
    VehicleTypeBike
};

@protocol VehicleSelectDelegate <NSObject>

@optional

-(void)vehicleSelected:(Delivery *)deliver vehicleType:(VehicleType)type;

@end

@interface SelectVehicleViewController : UIViewController
@property (nonatomic, assign) VehicleType vehicleType;
@property (nonatomic, weak) id <VehicleSelectDelegate> delegate;
@property (nonatomic, strong) Delivery *delivery;
@property (nonatomic, strong) IWadVehicle *selectedVehicle;
@end
