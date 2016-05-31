//
//  NSString+Category.h
//  iWad
//
//  Created by Saman Kumara on 12/14/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString(Category)

- (BOOL)isValidEmail;
- (NSString *) stringByTrimming;
- (BOOL)isEmpty;

/**
 *  Checks whether the phone number is valid. characters count from 9 to 15 maximum.
 *
 *  @return Valid status YES/NO
 */
- (BOOL)isValidPhoneNumber;

/**
 *  Checks whether the CVC number is a valid number.
 *
 *  @return Valid status YES/NO
 */
- (BOOL)isValidCVCNumber;
@end
