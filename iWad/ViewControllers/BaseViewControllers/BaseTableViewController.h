//
//  BaseTableViewController.h
//  iWad
//
//  Created by Saman Kumara on 12/16/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface BaseTableViewController : UITableViewController

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSString * labelTitle;

-(NSString *)setTitleToLabel:(NSString *)title;

@end
