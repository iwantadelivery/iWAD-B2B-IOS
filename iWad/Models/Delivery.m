//
//  Delivery.m
//  iWad
//
//  Created by Saman Kumara on 12/17/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "Delivery.h"

@implementation Delivery

+(id)currentDelivery {
    static Delivery *currentDelivery = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentDelivery = [[self alloc] init];
    });
    return currentDelivery;
}
@end
