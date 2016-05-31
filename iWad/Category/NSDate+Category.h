//
//  NSDate+Category.h
//  iWad
//
//  Created by Saman Kumara on 12/14/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDate(Category)

-(NSString *)stringFromFormat:(NSString *) format;

-(NSDate *)dateWithString:(NSString *)dateString;

@end
