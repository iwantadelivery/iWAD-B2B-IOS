//
//  LocationUtil.h
//  iWad
//
//  Created by Saman Kumara on 12/17/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationUtil : NSObject
@property (strong, nonatomic) CLLocationManager *locationManager;
+(void)getGeocodeAddressString:(NSString *) string completionHandler:(void (^) (NSArray *array)) completiion;
+(void)getCurrentLocationWithCompletionHandler:(void (^) (NSArray *locations, NSError *erroor)) completiion;

/**
 *  Searches for a given address.
 *
 *  @param address    Address
 *  @param completion placemarks array and error
 */
+(void)searchLocationForAddress:(NSString *)address completionHandler:(void (^)(NSArray * placemarks, NSError * error))completion;
@end
