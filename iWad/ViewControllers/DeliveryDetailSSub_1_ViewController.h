//
//  ViewDeliveryDetailsViewController.h
//  iWAD
//
//  Created by Himal Madhushan on 2/1/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliveryDetailSSub_1_ViewController : UITableViewController

@property (nonatomic, strong) Deliveries * delivery;

-(void)updateUIForDeliverID:(NSString *)deliID;

@end
