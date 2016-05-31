//
//  User+CoreDataProperties.h
//  
//
//  Created by Himal Madhushan on 2/3/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSString *userAddress;
@property (nullable, nonatomic, retain) NSNumber *userID;
@property (nullable, nonatomic, retain) NSString *userDOB;
@property (nullable, nonatomic, retain) NSData *userImage;
@property (nullable, nonatomic, retain) NSString *userToken;
@property (nullable, nonatomic, retain) NSString *userEmail;
@property (nullable, nonatomic, retain) NSString *userPhone;
@property (nullable, nonatomic, retain) NSString *userGender;
@property (nullable, nonatomic, retain) NSString *userPushToken;
@property (nullable, nonatomic, retain) NSString *countryCode;
@end

NS_ASSUME_NONNULL_END
