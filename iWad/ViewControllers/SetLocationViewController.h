//
//  SetLocationViewController.h
//  iWad
//
//  Created by Saman Kumara on 12/17/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "BaseViewController.h"
#import "Delivery.h"

typedef NS_ENUM (NSInteger, LocationType) {
    LocationTypeFrom,
    LocationTypeTo
};

@protocol DelivaryLocationDelegate <NSObject>

@optional

-(void)userDidEnterLocationsFrom:(NSString *)from to:(NSString * )to delivery:(Delivery *)delivary;

@end

@interface SetLocationViewController : UIViewController

@property (nonatomic , strong) Delivery *delivery;
@property (nonatomic, weak) id <DelivaryLocationDelegate> delivaryDelegate;

@end
