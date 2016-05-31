//
//  IWadPromoCode.m
//  iWAD
//
//  Created by Himal Madhushan on 1/18/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "IWadPromoCode.h"

@implementation IWadPromoCode

+(IWadPromoCode *)promoCode {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
