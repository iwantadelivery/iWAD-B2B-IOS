//
//  NSDate+Category.m
//  iWad
//
//  Created by Saman Kumara on 12/14/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "NSDate+Category.h"

@implementation NSDate(Category)

-(NSString *)stringFromFormat:(NSString *) format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:self];
}

-(NSDate *)dateWithString:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    return [dateFormatter dateFromString:dateStr];
}

@end
