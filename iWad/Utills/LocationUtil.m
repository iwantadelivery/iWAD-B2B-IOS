//
//  LocationUtil.m
//  iWad
//
//  Created by Saman Kumara on 12/17/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//
#import "LocationUtil.h"

@implementation LocationUtil

+(void)getGeocodeAddressString:(NSString *) string completionHandler:(void (^) (NSArray *array)) completiion{
    CLGeocoder      *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:string completionHandler:^(NSArray* placemarks, NSError* error){
        completiion(placemarks);
     }];
}

+(void)getCurrentLocationWithCompletionHandler:(void (^) (NSArray *locations, NSError *erroor)) completiion{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication]delegate];
    [appDelegate getCurrentLocationWithCompletionHandler:completiion];
    
    [[AppDelegate sharedInstance] getCurrentLocationWithCompletionHandler:completiion];
}

+(void)searchLocationForAddress:(NSString *)address completionHandler:(void (^)(NSArray * placemarks, NSError * error))completion {
    
    CLGeocoder *geocoderPop = [[CLGeocoder alloc] init];
    [geocoderPop geocodeAddressString:address
                    completionHandler:^(NSArray* placemarks, NSError* error){
                        completion(placemarks,error);
                    }
     ];
    
}

@end

