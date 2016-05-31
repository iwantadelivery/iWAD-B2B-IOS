//
//  AddNoteViewController.h
//  iWAD
//
//  Created by Himal Madhushan on 2/26/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeliveryNoteDelegate <NSObject>
@optional
- (void)deliveryNoteAdded:(nullable NSString *)note;
@end

@interface AddNoteViewController : UIViewController
@property (nonatomic, strong, nullable) Delivery *delivery;
@property (nonnull, assign) id <DeliveryNoteDelegate> delegate;
@end
