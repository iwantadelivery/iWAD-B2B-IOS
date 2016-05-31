//
//  NewDeliveryViewController.h
//  iWad
//
//  Created by Saman Kumara on 12/16/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "BaseTableViewController.h"

@interface NewDeliveryStep1ViewController : UITableViewController

@property (nonatomic, assign) BOOL showDateTime;
@property (nonatomic, assign) BOOL deliveryLater;
@property (nonatomic, strong) Delivery * delivery;
@end
