//
//  Driver+CoreDataProperties.h
//  
//
//  Created by Himal Madhushan on 1/27/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Driver.h"

NS_ASSUME_NONNULL_BEGIN

@interface Driver (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *fName;
@property (nullable, nonatomic, retain) NSString *lName;
@property (nullable, nonatomic, retain) NSString *surName;
@property (nullable, nonatomic, retain) NSString *photoURL;
@property (nullable, nonatomic, retain) NSString *longitude;
@property (nullable, nonatomic, retain) NSString *latitude;
@property (nullable, nonatomic, retain) NSNumber *driverID;
@property (nullable, nonatomic, retain) Deliveries *deliversRS;

@end

NS_ASSUME_NONNULL_END
