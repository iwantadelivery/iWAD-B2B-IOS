//
//  NewDeliveryNewPaymentTableViewController.h
//  iWad
//
//  Created by Himal Madhushan on 1/12/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, PaymentCellType) {
    PaymentCellTypeCredit,
    PaymentCellTypePrepaid
};

@interface NewDeliveryNewPaymentViewController : UITableViewController

@property(nonatomic , strong) Delivery *delivery;

@end
