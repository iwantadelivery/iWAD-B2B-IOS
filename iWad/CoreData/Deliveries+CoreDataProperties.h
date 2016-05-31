//
//  Deliveries+CoreDataProperties.h
//  
//
//  Created by Himal Madhushan on 1/27/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Deliveries.h"

NS_ASSUME_NONNULL_BEGIN

@interface Deliveries (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *cost;
@property (nullable, nonatomic, retain) NSString *createdDate;
@property (nullable, nonatomic, retain) NSString *deliveryDate;
@property (nullable, nonatomic, retain) NSNumber *deliveryID;
@property (nullable, nonatomic, retain) NSString *deliveryTime;
@property (nullable, nonatomic, retain) NSString *dimension;
@property (nullable, nonatomic, retain) NSString *doorNumberFrom;
@property (nullable, nonatomic, retain) NSString *doorNumberTo;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *fromAddress;
@property (nullable, nonatomic, retain) NSNumber *fromLatitude;
@property (nullable, nonatomic, retain) NSNumber *fromLongitude;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *payload;
@property (nullable, nonatomic, retain) NSNumber *peopleCount;
@property (nullable, nonatomic, retain) NSString *promoCode;
@property (nullable, nonatomic, retain) NSNumber *promoID;
@property (nullable, nonatomic, retain) NSNumber *status;
@property (nullable, nonatomic, retain) NSString *toAddress;
@property (nullable, nonatomic, retain) NSNumber *toLatitude;
@property (nullable, nonatomic, retain) NSNumber *toLongitude;
@property (nullable, nonatomic, retain) NSNumber *vehicleID;
@property (nullable, nonatomic, retain) NSString *vehicleType;
@property (nullable, nonatomic, retain) NSString *driverName;
@property (nullable, nonatomic, retain) NSString *note;
@property (nullable, nonatomic, retain) NSNumber *isManuel;
@property (nullable, nonatomic, retain) NSString *signatureFileName;
@property (nullable, nonatomic, retain) NSString *deliveryNumber;
@property (nullable, nonatomic, retain) NSString *deliveryContact;
@property (nullable, nonatomic, retain) Driver *driverRS;

@end

NS_ASSUME_NONNULL_END
