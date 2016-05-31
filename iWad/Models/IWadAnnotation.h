//
//  IWadAnnotation.h
//  iWAD
//
//  Created by Himal Madhushan on 1/14/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MKAnnotation.h>

typedef NS_ENUM(NSInteger, AnnotationType) {
    AnnotationTypeFrom = 0,
    AnnotationTypeTo = 1,
    AnnotationTypeNone,
    AnnotationTypeDriver
};

@interface IWadAnnotation : NSObject <MKAnnotation>

@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtitle;
@property(nonatomic, assign) AnnotationType annotationType;
@property(nonatomic, assign) int status;

@property (nonatomic, strong) IWadDriver *driver;

@end
