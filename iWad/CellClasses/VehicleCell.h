//
//  VehicleCell.h
//  iWAD
//
//  Created by Himal Madhushan on 4/19/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VehicleCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblVehicleName;
@property (strong, nonatomic) IBOutlet UILabel *lblPayload;
@property (strong, nonatomic) IBOutlet UILabel *lblDimension;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewTick;
@end
