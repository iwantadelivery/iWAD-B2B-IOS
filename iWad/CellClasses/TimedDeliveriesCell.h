//
//  TimedDeliveriesCell.h
//  iWAD
//
//  Created by Himal Madhushan on 1/22/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundedImageView.h"
#import "LocationPopupViewController.h"

@class TimedDeliveriesCell;
@protocol TimedCellDelegate <NSObject>
@optional
-(void)TimedDeliveriesCell:(TimedDeliveriesCell *)cell view:(UIView *)view address:(NSString *)address type:(LocationType)type;;
@end

@interface TimedDeliveriesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet RoundedImageView *imgViewUserPic;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewVehicle;
@property (weak, nonatomic) IBOutlet UILabel *lblNoOfPeople;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblFrom;
@property (weak, nonatomic) IBOutlet UILabel *lblTo;
@property (weak, nonatomic) IBOutlet UILabel *lblCost;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblPhone;
@property (strong, nonatomic) IBOutlet UILabel *lblClientName;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderID;

@property (weak, nonatomic) IBOutlet UILabel *lblOrderDate;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderTime;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewStatus0;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewStatus1;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewStatus2;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewStatus3;

@property (weak, nonatomic) IBOutlet UILabel *lblEnRoute;
@property (weak, nonatomic) IBOutlet UILabel *lblAllocated;
@property (weak, nonatomic) IBOutlet UILabel *lblPicked;
@property (weak, nonatomic) IBOutlet UILabel *lblDelivered;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewLine1;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewLine2;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewLine3;

@property (weak, nonatomic) IBOutlet UIView *viewFrom;
@property (weak, nonatomic) IBOutlet UIView *viewTo;
@property (weak, nonatomic) IBOutlet UIView *viewNote;

@property (nonatomic, assign) IBOutlet UIViewController *viewController;
@property (nonatomic, strong) Deliveries *delivery;

@property (nonatomic, assign) id <TimedCellDelegate> delegate;
@end
