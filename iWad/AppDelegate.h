//
//  AppDelegate.h
//  iWad
//
//  Created by Saman Kumara on 12/11/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Stripe.h"

@protocol IWADDelegate <NSObject>
@optional
-(void)changedDeliverStatus:(NSDictionary *)userInfo;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+(AppDelegate *)sharedInstance;

@property (nonatomic, strong) CLLocationManager *locationManager;

-(void)login:(BOOL)status;
-(void)getCurrentLocationWithCompletionHandler:(void (^) (NSArray *locations, NSError *erroor)) completiion;

@property (nonatomic, strong) NSString *pushToken;
@property (nonatomic, strong) UIViewController *currentVC;
@property (nonatomic, strong) id <IWADDelegate> iwadDelegate;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@end

