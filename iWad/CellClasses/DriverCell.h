//
//  DriverCell.h
//  iWAD
//
//  Created by Himal Madhushan on 2/11/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundedImageView.h"

@interface DriverCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblDriverName;
@property (strong, nonatomic) IBOutlet RoundedImageView *imgViewPhoto;
@property (strong, nonatomic) IBOutlet UILabel *lblPhoneNumber;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewTick;
@property (weak, nonatomic) IBOutlet UILabel *lblETA;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UIView *viewClock;

@end
