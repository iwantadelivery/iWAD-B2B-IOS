//
//  IWadPromoCode.h
//  iWAD
//
//  Created by Himal Madhushan on 1/18/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IWadPromoCode : NSObject

/**
 *  Promotion code
 */
@property (nonatomic, strong) NSString * code;

/**
 *  Code descritopn
 */
@property (nonatomic, strong) NSString * codeDescription;

/**
 *  Code validation start date
 */
@property (nonatomic, strong) NSString * startDate;

/**
 *  Code expiry date
 */
@property (nonatomic, strong) NSString * expiryDate;

/**
 *  Code ID
 */
@property (nonatomic, assign) int ID;

/**
 *  Bonus price
 */
@property (nonatomic, assign) float price;


+(IWadPromoCode *)promoCode;

@end
