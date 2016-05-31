//
//  NSString+Category.m
//  iWad
//
//  Created by Saman Kumara on 12/14/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "NSString+Category.h"

#define ACCEPTABLE_PHONE_NO_CHARECTERS @"+ 0123456789-()"
#define ACCEPTABLE_CVC_NO_CHARECTERS @"0123456789"

@implementation NSString(Category)

- (BOOL)isValidEmail{
    NSString *result = [self copy];
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:result];
}

- (NSString *) stringByTrimming{
    NSMutableString *mStr = [self mutableCopy];
    CFStringTrimWhitespace((__bridge_retained CFMutableStringRef)mStr);
    return [mStr copy];
}

- (BOOL)isEmpty{
    if (self.stringByTrimming.length > 0) {
        return NO;
    } else {
        return YES;
    }
//    return (self.stringByTrimming.length > 0) ? NO : YES;
}

- (BOOL)isValidPhoneNumber {
    if (self.stringByTrimming.length <= 15) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_PHONE_NO_CHARECTERS] invertedSet];
        NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [self isEqualToString:filtered];
    } else {
        return NO;
    }
}

- (BOOL)isValidCVCNumber {
    if (self.stringByTrimming.length <= 3) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CVC_NO_CHARECTERS] invertedSet];
        NSString *filtered = [[self componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [self isEqualToString:filtered];
    } else {
        return NO;
    }
}

@end
