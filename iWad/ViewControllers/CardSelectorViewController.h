//
//  CardSelectorViewController.h
//  iWAD
//
//  Created by Himal Madhushan on 1/18/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CardSelectorDelegate <NSObject>

@optional

-(void)cardSelectorDidPickStrpieCardType:(STPCardBrand)strpieCardType;

@end

@interface CardSelectorViewController : UIViewController

@property (nonatomic, weak) id <CardSelectorDelegate> delegate;

@end
