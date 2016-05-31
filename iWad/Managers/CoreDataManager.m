//
//  CoreDataManager.m
//  iWAD
//
//  Created by Himal Madhushan on 1/22/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "CoreDataManager.h"
#import "NSDate+Category.h"
#import "Driver.h"

@implementation CoreDataManager

+(CoreDataManager *)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Save Core Data

+(BOOL)saveToCoreData {
    
    NSError * error;
    if (![[self managedObjectContext] save:&error]) {
        return NO;
    } else {
        return YES;
    }
}

+(NSManagedObjectContext *)managedObjectContext{
    return [[AppDelegate sharedInstance] managedObjectContext];
}

#pragma mark - Driver

+(Driver *)newDriver {
    Driver *object = (Driver *)[NSEntityDescription insertNewObjectForEntityForName:@"Driver"
                                                             inManagedObjectContext:[self managedObjectContext]];
    return object;
}


#pragma mark - Deliveries

+(Deliveries *)newDelivery {
    Deliveries *object = (Deliveries *)[NSEntityDescription insertNewObjectForEntityForName:@"Deliveries"
                                                                     inManagedObjectContext:[self managedObjectContext]];
    return object;
}

+(BOOL)insertDeliveryFromResponse:(NSDictionary *)response {
    [self removeAllDeliveries];
    BOOL success = 0;
    
    if ([[response valueForKey:@"success"] isEqualToString:@"true"]) {
        
        NSArray * deliveries = [response valueForKey:@"deliveries"];
        
        for (NSDictionary * resp in deliveries) {
            
            if (![self deliverForID:[resp valueForKey:@"id"] statusID:@""]) {
                [self insertOrUpdateDeliveryFromResponse:resp];
            }
        }
    }
    
    return success;
}



/**
 *  updating for push
 *
 */
+(void)updateDeliveryForID:(NSString *)deliveryID response:(NSDictionary *)response {
    if ([[response valueForKey:@"success"] isEqualToString:@"true"]) {
        NSDictionary * resp = [response valueForKey:@"delivery"];
//        [self insertOrUpdateDeliveryFromResponse:resp];
        
        if ([self deliverForID:deliveryID]) {
            
            Deliveries *delivery = [self deliverForID:deliveryID];
            
            if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"cost"]]) {
                delivery.cost = [NSNumber numberWithFloat:[[resp valueForKey:@"cost"] floatValue]];
            }
            if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"from_location"]]) {
                delivery.fromAddress = [resp valueForKey:@"from_location"];
            }
            if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"to_location"]]) {
                delivery.toAddress = [resp valueForKey:@"to_location"];
            }
            if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"from_lat"]]) {
                delivery.fromLatitude = [NSNumber numberWithFloat:[[resp valueForKey:@"from_lat"] floatValue]];
            }
            if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"from_lon"]]) {
                delivery.fromLongitude = [NSNumber numberWithFloat:[[resp valueForKey:@"from_lon"] floatValue]];
            }
            
            if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"to_lat"]]) {
                delivery.toLatitude = [NSNumber numberWithFloat:[[resp valueForKey:@"to_lat"] floatValue]];
            }
            if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"to_lon"]]) {
                delivery.toLongitude = [NSNumber numberWithFloat:[[resp valueForKey:@"to_lon"] floatValue]];
            }
            if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"name"]]) {
                delivery.name = [resp valueForKey:@"name"];
            }
            if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"id"]]) {
                delivery.deliveryID = [NSNumber numberWithInt:[[resp valueForKey:@"id"] intValue]];
            }
            if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"email"]]) {
                delivery.email = [resp valueForKey:@"email"];
            }
            NSDictionary *deliveryVehicle = [resp valueForKey:@"delivery_vehicle"];
            if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[deliveryVehicle valueForKey:@"vehicle_type_id"]]) {
                delivery.vehicleID = [NSNumber numberWithInt:[[resp valueForKey:@"vehicle_type_id"] intValue]];
            }
            if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"manual"]]) {
                delivery.isManuel = [NSNumber numberWithBool:[[resp valueForKey:@"manual"] intValue]];
            }
            
            
            if (![[resp valueForKey:@"signature_file_name"] isKindOfClass:[NSNull class]]) {
                delivery.signatureFileName = [resp valueForKey:@"signature_file_name"];
            }
            
            if ([[resp valueForKey:@"note"] isKindOfClass:[NSNull class]] || [[resp valueForKey:@"note"] isEqualToString:@"<null>"]) {
                delivery.note = @"";
            } else {
                delivery.note = [resp valueForKey:@"note"];
            }
            
            if ([[resp valueForKey:@"from_door_number"] isKindOfClass:[NSNull class]] || [[resp valueForKey:@"from_door_number"] isEqualToString:@"<null>"]) {
                delivery.doorNumberFrom = @"";
            } else {
                delivery.doorNumberFrom = [resp valueForKey:@"from_door_number"];
            }
            if ([[resp valueForKey:@"to_door_number"] isKindOfClass:[NSNull class]] || [[resp valueForKey:@"to_door_number"] isEqualToString:@"<null>"]) {
                delivery.doorNumberTo = @"";
            } else {
                delivery.doorNumberTo = [resp valueForKey:@"to_door_number"];
            }
            
            if ([[NSString stringWithFormat:@"%@",[resp valueForKey:@"delivery_date"]] isKindOfClass:[NSNull class]] || [[NSString stringWithFormat:@"%@",[resp valueForKey:@"delivery_date"]] isEqualToString:@"<null>"]) {
                delivery.deliveryTime = kNO_TIME;
                delivery.deliveryDate = kNO_DATE;
            } else {
                delivery.deliveryDate = [self formatDeliveryDate:[NSString stringWithFormat:@"%@",[resp valueForKey:@"delivery_date"]]];
                delivery.deliveryTime = [self formatDeliveryTime:[NSString stringWithFormat:@"%@",[resp valueForKey:@"delivery_date"]]];
            }
            
            if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"no_of_people"]]) {
                delivery.peopleCount = [NSNumber numberWithFloat:[[resp valueForKey:@"no_of_people"] intValue]];
            }
            if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"created_at"]]) {
                delivery.createdDate = [resp valueForKey:@"created_at"];
            }
            
            NSDictionary * deliveryStatus = [resp valueForKey:@"delivery_status"];
            
            delivery.status = [NSNumber numberWithInt:[[deliveryStatus valueForKey:@"id"] intValue]];
            
            NSDictionary *driverDic = [resp valueForKey:@"driver"];
            if (driverDic) {
                Driver *driver = [self newDriver];
                if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"first_name"]]) {
                    driver.fName = [driverDic valueForKey:@"first_name"];
                }
                if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"middle_name"]]) {
                    driver.lName = [driverDic valueForKey:@"middle_name"];
                }
                if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"surname"]]) {
                    driver.surName = [driverDic valueForKey:@"surname"];
                }
                
                driver.driverID = [NSNumber numberWithInt:[[driverDic valueForKey:@"id"] intValue]];
                if (![[driverDic valueForKey:@"lat"] isKindOfClass:[NSNull class]]) {
                    driver.latitude = [NSString stringWithFormat:@"%@",[driverDic valueForKey:@"lat"]];
                    driver.longitude = [NSString stringWithFormat:@"%@",[driverDic valueForKey:@"lon"]];
                }
                NSString * URL = [NSString stringWithFormat:@"%@%@",BASE_IMAGE_URL,[driverDic valueForKey:@"avatar_url"]];
                driver.photoURL = URL;
                
                delivery.driverRS = driver;
                [self saveToCoreData];
            }
            else {
                [self saveToCoreData];
            }
        }
        
    }
}

+(NSString *)formatDeliveryDate:(NSString *)deliveryDate {
    NSArray * dateArr =[deliveryDate componentsSeparatedByString:@"T"];
    NSString * date = [dateArr objectAtIndex:0];
    date = [[BaseUtilClass sharedInstance] formatDateToUKFormat:date];
    date = [date stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    return date;
}

+(NSString *)formatDeliveryTime:(NSString *)deliveryDate {
    NSArray * dateArr =[deliveryDate componentsSeparatedByString:@"T"];
    NSString * time = [dateArr objectAtIndex:1];
    NSArray *timeArr = [time componentsSeparatedByString:@":"];
    time = [NSString stringWithFormat:@"%@:%@",[timeArr objectAtIndex:0],[timeArr objectAtIndex:1]];
    
    return time;
}

+(void)removeAllDeliveries {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Deliveries"
                                   inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:nil];
    
    NSArray *episodes = [[self managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    
    for (NSManagedObject *episode in episodes) {
        [[self managedObjectContext] deleteObject:episode];
    }
    if (![self saveToCoreData]) {
        NSLog(@"Can't remove and save all deliveries");
    }
    
}


+ (void)insertOrUpdateDeliveryFromResponse:(NSDictionary *)resp {
    
    Deliveries * delivery = [self newDelivery];
    
    if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"cost"]]) {
        delivery.cost = [NSNumber numberWithFloat:[[resp valueForKey:@"cost"] floatValue]];
    }
    if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"from_location"]]) {
        delivery.fromAddress = [resp valueForKey:@"from_location"];
    }
    if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"to_location"]]) {
        delivery.toAddress = [resp valueForKey:@"to_location"];
    }
    if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"from_lat"]]) {
        delivery.fromLatitude = [NSNumber numberWithFloat:[[resp valueForKey:@"from_lat"] floatValue]];
    }
    if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"from_lon"]]) {
        delivery.fromLongitude = [NSNumber numberWithFloat:[[resp valueForKey:@"from_lon"] floatValue]];
    }
    
    if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"to_lat"]]) {
        delivery.toLatitude = [NSNumber numberWithFloat:[[resp valueForKey:@"to_lat"] floatValue]];
    }
    if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"to_lon"]]) {
        delivery.toLongitude = [NSNumber numberWithFloat:[[resp valueForKey:@"to_lon"] floatValue]];
    }
    if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"name"]]) {
        delivery.name = [resp valueForKey:@"name"];
    }
    if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"id"]]) {
        delivery.deliveryID = [NSNumber numberWithInt:[[resp valueForKey:@"id"] intValue]];
    }
    if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"email"]]) {
        delivery.email = [resp valueForKey:@"email"];
    }
    NSDictionary *deliveryVehicle = [resp valueForKey:@"delivery_vehicle"];
    if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[deliveryVehicle valueForKey:@"vehicle_type_id"]]) {
        delivery.vehicleID = [NSNumber numberWithInt:[[deliveryVehicle valueForKey:@"vehicle_type_id"] intValue]];
    }
    if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"manual"]]) {
        delivery.isManuel = [NSNumber numberWithBool:[[resp valueForKey:@"manual"] intValue]];
    }
    
    if (![[resp valueForKey:@"signature_file_name"] isKindOfClass:[NSNull class]]) {
        delivery.signatureFileName = [resp valueForKey:@"signature_file_name"];
    }
    
    if ([[resp valueForKey:@"note"] isKindOfClass:[NSNull class]] || [[resp valueForKey:@"note"] isEqualToString:@"<null>"]) {
        delivery.note = @"";
    } else {
        delivery.note = [resp valueForKey:@"note"];
    }
    
    if ([[resp valueForKey:@"from_door_number"] isKindOfClass:[NSNull class]] || [[resp valueForKey:@"from_door_number"] isEqualToString:@"<null>"]) {
        delivery.doorNumberFrom = @"";
    } else {
        delivery.doorNumberFrom = [resp valueForKey:@"from_door_number"];
    }
    if ([[resp valueForKey:@"to_door_number"] isKindOfClass:[NSNull class]] || [[resp valueForKey:@"to_door_number"] isEqualToString:@"<null>"]) {
        delivery.doorNumberTo = @"";
    } else {
        delivery.doorNumberTo = [resp valueForKey:@"to_door_number"];
    }
    
    if ([[NSString stringWithFormat:@"%@",[resp valueForKey:@"delivery_date"]] isKindOfClass:[NSNull class]] || [[NSString stringWithFormat:@"%@",[resp valueForKey:@"delivery_date"]] isEqualToString:@"<null>"]) {
        delivery.deliveryTime = kNO_TIME;
        delivery.deliveryDate = kNO_DATE;
    } else {
        delivery.deliveryDate = [self formatDeliveryDate:[NSString stringWithFormat:@"%@",[resp valueForKey:@"delivery_date"]]];
        delivery.deliveryTime = [self formatDeliveryTime:[NSString stringWithFormat:@"%@",[resp valueForKey:@"delivery_date"]]];
    }
    
    if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"no_of_people"]]) {
        delivery.peopleCount = [NSNumber numberWithFloat:[[resp valueForKey:@"no_of_people"] intValue]];
    }
    if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"created_at"]]) {
        delivery.createdDate = [resp valueForKey:@"created_at"];
    }
    
    if (![[resp valueForKey:@"delivery_contact"] isKindOfClass:[NSNull class]]) {
        delivery.deliveryContact = [resp valueForKey:@"delivery_contact"];
    }
    if (![[resp valueForKey:@"delivery_number"] isKindOfClass:[NSNull class]]) {
        delivery.deliveryNumber = [resp valueForKey:@"delivery_number"];
    }
    
    NSDictionary * deliveryStatus = [resp valueForKey:@"delivery_status"];
    
    delivery.status = [NSNumber numberWithInt:[[deliveryStatus valueForKey:@"id"] intValue]];
    
    NSDictionary *driverDic = [resp valueForKey:@"driver"];
    if (driverDic) {
        Driver *driver = [self newDriver];
        if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"first_name"]]) {
            driver.fName = [driverDic valueForKey:@"first_name"];
        }
        if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"middle_name"]]) {
            driver.lName = [driverDic valueForKey:@"middle_name"];
        }
        if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[resp valueForKey:@"surname"]]) {
            driver.surName = [driverDic valueForKey:@"surname"];
        }
        
        driver.driverID = [NSNumber numberWithInt:[[driverDic valueForKey:@"id"] intValue]];
        if (![[driverDic valueForKey:@"lat"] isKindOfClass:[NSNull class]]) {
            driver.latitude = [NSString stringWithFormat:@"%@",[driverDic valueForKey:@"lat"]];
            driver.longitude = [NSString stringWithFormat:@"%@",[driverDic valueForKey:@"lon"]];
        }
        NSString * URL = [NSString stringWithFormat:@"%@%@",BASE_IMAGE_URL,[driverDic valueForKey:@"avatar_url"]];
        driver.photoURL = URL;
        
        delivery.driverRS = driver;
        [self saveToCoreData];
    }
    else {
        [self saveToCoreData];
    }
}


+(Deliveries *)deliverForID:(NSString *)deliverID statusID:(NSString *)statusID {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"deliveryID == %@ AND status == 5",deliverID ];
    Deliveries * deli = (Deliveries *) [self fetchObject:@"Deliveries" predicate:pred sort:nil];
    return deli;
}

+(Deliveries *)deliverForID:(NSString *)deliverID {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"deliveryID == %@",deliverID];
    Deliveries * deli = (Deliveries *) [self fetchObject:@"Deliveries" predicate:pred sort:nil];
    return deli;
}

#pragma mark - User

+(User *)insertUser {
    User *object = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                         inManagedObjectContext:[self managedObjectContext]];
    return object;
}

+(void)saveUserProfileDetails:(NSString *)name
                        email:(NSString *)email
                  phoneNumber:(NSString *)phoneNumber
                        token:(NSString *)token
                       userID:(NSString *)userID
                       gender:(NSString *)gender
                          dob:(NSString *)dob
                    pushToken:(NSString *)pushToken
                  countryCode:(NSString *)cc{
    
    [self removeUser];
    User *user = [self insertUser];
    user.userDOB = dob;
    user.userEmail = email;
    user.userGender = gender;
    user.userID = [NSNumber numberWithInt:[userID intValue]];
    user.userName = name;
    user.userPhone = phoneNumber;
    user.userToken = token;
    user.userPushToken = pushToken;
    user.countryCode = cc;
    [self saveToCoreData];
}

+(User *)user {
    User *user = (User *) [self fetchObject:@"User" predicate:nil sort:nil];
    return user;
}

+(void)removeUser {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"User"
                                   inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:nil];
    
    NSArray *episodes = [[self managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    
    for (NSManagedObject *episode in episodes) {
        [[self managedObjectContext] deleteObject:episode];
    }
    [self saveToCoreData];
}

+(void)logoutUser {
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kUSER_LOGGED];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[AppDelegate sharedInstance] login:NO];
    
    [self removeAllDeliveries];
    [self removeUser];
}


#pragma mark - Common Methods

+ (NSManagedObject*)fetchObject:(NSString*)name
                      predicate:(NSPredicate*)pred
                           sort:(NSArray*)sortDescriptors {
    
    return [[self fetchObjects:name predicate:pred sort:sortDescriptors isDistinct:NO]firstObject];
    
}

+ (NSArray*)fetchObjects:(NSString*)name
               predicate:(NSPredicate*)pred
                    sort:(NSArray*)sortDescriptors
              isDistinct:(BOOL)distinct  {
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:name
                                   inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:pred];
    
    [fetchRequest setFetchBatchSize:20];
    
    return [[self managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    
}
@end

