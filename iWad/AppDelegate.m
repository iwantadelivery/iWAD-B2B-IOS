//
//  AppDelegate.m
//  iWad
//
//  Created by Saman Kumara on 12/11/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LocationUtil.h"
#import "BaseUtilClass.h"
#import "NewDeliveryNewPaymentViewController.h"
#import "MenuViewController.h"
#import "LoginViewController.h"
#import "IWADNavigationViewController.h"
#import "DeliveryDetailSSub_1_ViewController.h"
#import "UIImage+ImageEffects.h"

@interface AppDelegate () <CLLocationManagerDelegate> {
    SyncManager * syncManager;
}

@property (nonatomic, strong) void (^completion) (NSArray *locations, NSError *error);

@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize pushToken, currentVC, iwadDelegate = _iwadDelegate;

+(AppDelegate *)sharedInstance {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    Reachability *reachaility = [Reachability reachabilityForInternetConnection];
//    [reachaility startNotifier];
    
    [NSThread sleepForTimeInterval:2];
    
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"backBtn"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"backBtn"]];
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert
                                                                                         | UIUserNotificationTypeBadge
                                                                                         | UIUserNotificationTypeSound) categories:nil];
    [application registerUserNotificationSettings:settings];
    
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        [self application:application didReceiveRemoteNotification:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
        [self application:application didReceiveRemoteNotification:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey] fetchCompletionHandler:^(UIBackgroundFetchResult result) {
            
        }];
    }
    
    NSLog(@"unique : %@",[[UIDevice currentDevice] identifierForVendor]);
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    syncManager = [[SyncManager alloc] initWithDelegate:nil];
    
    [Stripe setDefaultPublishableKey:IWAD_TEST_StripePublishableKey];
    
    BOOL logged = [[NSUserDefaults standardUserDefaults] boolForKey:kUSER_LOGGED];
    if (logged == YES) {
        [self login:YES];
    } else {
        [self login:NO];
    }
    
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    if (authorizationStatus != kCLAuthorizationStatusAuthorizedAlways || authorizationStatus != kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    if ([[BaseUtilClass sharedInstance] userIsLogged]) {
        NSDate *today                       = [NSDate date];
        NSTimeInterval secondsInEightHours  = 20*60;
        NSDate *autoLogOutDate              = [today dateByAddingTimeInterval:secondsInEightHours];
        NSString *strAuto                   = [NSString stringWithFormat:@"%@",[autoLogOutDate stringFromFormat:DateTimeFormat]];
        [[BaseUtilClass sharedInstance] setAutologoutTimer:strAuto];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [syncManager fetchAllDeliveriesInView:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - Push

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        NSLog(@"didRegisterUserNotificationSettings");
        [application registerForRemoteNotifications];
    }
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    pushToken = [NSString stringWithFormat:@"%@",deviceToken];
    if (deviceToken != nil) {
        pushToken = [pushToken stringByReplacingOccurrencesOfString:@" " withString:@""];
        pushToken = [pushToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
        pushToken = [pushToken stringByReplacingOccurrencesOfString:@">" withString:@""];
    }
    NSLog(@"push token : %@",pushToken);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"user info (must) : %@",userInfo);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
    
    NSLog(@"user info : %@",userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
    
//    [syncManager fetchAllDeliveriesInView:nil];
    [syncManager updateDeliveryForPushInfo:userInfo];
    [BaseUtilClass showCustomPushOnView:self.window.rootViewController.view userInfo:userInfo];
    
//    if ([_iwadDelegate respondsToSelector:@selector(changedDeliverStatus:)]) {
//        [_iwadDelegate changedDeliverStatus:userInfo];
//    }
}

-(UIImage *)blurImage:(UIView *)view {
    /**
     *  creating image form snapshot
     */
    UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width, view.frame.size.height));
    [view drawViewHierarchyInRect:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    /**
     *  Apply blur effect
     */
//    blurImage = [image applyDarkEffect];
    
    return [image applyDarkEffect];;
}

#pragma mark - Other Methods

-(void)login:(BOOL)status{
    if (status == YES) {
        MainViewController *mainVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mainViewController"];
        [self.window setRootViewController:mainVC];
    }else {
        LoginViewController *svc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"loginVC"];
        IWADNavigationViewController *navController = [[IWADNavigationViewController alloc] initWithRootViewController:svc];
        self.window.rootViewController = navController;
    }
}


#pragma mark - Location Manager

-(void)getCurrentLocationWithCompletionHandler:(void (^) (NSArray *locations, NSError *erroor)) completiion {
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways || authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }else {
        [self.locationManager requestAlwaysAuthorization];
    }
    self.completion = completiion;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    NSLog(@"Location manager error: %@", error.localizedDescription);
    if (self.completion) {
        self.completion(nil, error);
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
//    NSLog(@"Location manager error: %@", @"no error");
    if ([locations count] > 0) {
        
        CLLocation *latestLocation = [locations lastObject];
        if (fabs([latestLocation.timestamp timeIntervalSinceDate:[NSDate date]]) > 120) {
            return;
        }
        if (self.completion) {
            self.completion(locations, nil);
        }
        manager.delegate    = nil;
        [manager stopUpdatingLocation];
        
    }
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
//    NSLog(@"Location manager error : %@", @"no ddddd");
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [manager startUpdatingLocation];
    }
}


#pragma mark - CoreData

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iWadDeliveryModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"iWadDeliveryModel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
