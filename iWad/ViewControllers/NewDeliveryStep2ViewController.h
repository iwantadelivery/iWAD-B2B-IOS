//
//  NewDeliveryStep2ViewController.h
//  iWad
//
//  Created by Saman Kumara on 12/16/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "BaseTableViewController.h"
#import "Delivery.h"

@interface NewDeliveryStep2ViewController : UITableViewController
@property(nonatomic , strong) Delivery *delivery;
@property (nonatomic, assign) BOOL showDateTime;
@end
