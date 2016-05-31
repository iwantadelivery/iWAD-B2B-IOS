//
//  DriversViewController.m
//  iWad
//
//  Created by Saman Kumara on 12/15/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "DriversViewController.h"
#import <MapKit/MapKit.h>
#import "IWadDriver.h"
#import "IWadAnnotation.h"
#import "IWadDriverAnnotationView.h"
@interface DriversViewController () <UITextFieldDelegate, MKMapViewDelegate, SyncManagerDelegate, UIGestureRecognizerDelegate> {
    __weak IBOutlet MKMapView *mapViewDrivers;
    __weak IBOutlet UITextField * txtLocation;
    __weak IBOutlet UIButton * btnCurrentLocation;
    
    NSMutableArray * driversArray, * driverAnnotArray;
    IWadDriverAnnotationView *calloutView;
}

@end

@implementation DriversViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"VIEW DRIVERS";
    driversArray = [[NSMutableArray alloc] init];
    driverAnnotArray = [[NSMutableArray alloc] init];
    mapViewDrivers.showsUserLocation = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    
    tapGesture.delegate = self;
    [mapViewDrivers addGestureRecognizer:tapGesture];
}

-(void)viewWillAppear:(BOOL)animated {
    if ([BaseUtilClass isConnectedToInternetInVC:self]) {
        SyncManager * sm = [[SyncManager alloc] initWithDelegate:self];
        [sm fetchAvailableDriversInView:[BaseUtilClass superView]];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [driverAnnotArray removeAllObjects];
}

#pragma mark - Button Actions

-(IBAction)showCurrentLocation:(UIButton *)sender {
    CLLocation * location = mapViewDrivers.userLocation.location;
    float spanX = 0.05;
    float spanY = 0.05;
    MKCoordinateRegion region;
    region.center.latitude = location.coordinate.latitude;
    region.center.longitude = location.coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [mapViewDrivers setRegion:region animated:YES];
}

#pragma mark - Map View Delegates
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MKAnnotationView *annotationView = (MKAnnotationView*) [mapView dequeueReusableAnnotationViewWithIdentifier:@"annotView"];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"annotView"];
    }
    
    CLLocationCoordinate2D me = mapView.userLocation.coordinate;
    CLLocationCoordinate2D annoCo = annotation.coordinate;
    if (annoCo.latitude == me.latitude) {
        MKAnnotationView *annotationViewMe = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"annotViewMe"];
        annotationViewMe.image = [UIImage imageNamed:@"viewDriversMyPin"];
        return annotationViewMe;
    }
    else {
        IWadAnnotation *annot = (IWadAnnotation *)annotation;
        NSLog(@"status - %d",annot.status);
        int status = annot.status;
        if (status == 1) {
            annotationView.image = [UIImage imageNamed:@"vanNotOnDelivery"];
        } else
            annotationView.image = [UIImage imageNamed:@"vanOnDelivery"];
    }
    mapViewDrivers.userLocation.title = @"Me";
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    [mapView deselectAnnotation:view.annotation animated:YES];
    if (![view.reuseIdentifier isEqualToString:@"annotViewMe"]) {
        IWadAnnotation *annotation = view.annotation;
        if (annotation.annotationType == AnnotationTypeDriver) {
            for (UIView *annotView in view.subviews) {
                if ([annotView isKindOfClass:[IWadDriverAnnotationView class]]) {
                    [annotView removeFromSuperview];
                }
            }
            
            IWadDriver *driver = annotation.driver;
            calloutView = (IWadDriverAnnotationView *)[[[NSBundle mainBundle]loadNibNamed:@"IWadDriverAnnotationView" owner:self options:nil] objectAtIndex:0];
            [calloutView setDriverDetails:driver imgURL:nil];
            CGRect sourceRect = calloutView.frame;
            sourceRect.origin.x = [mapView convertCoordinate:view.annotation.coordinate toPointToView:mapView].x - view.frame.origin.x - (calloutView.frame.size.width /2);
            sourceRect.origin.y -= 55;
            calloutView.frame = sourceRect;
            [view addSubview:calloutView];
            
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0, 0);
            CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(0, +55);
            calloutView.transform = CGAffineTransformConcat(scaleTransform, translateTransform);
            calloutView.alpha = 0;
            
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                calloutView.transform = CGAffineTransformIdentity;
                calloutView.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

#pragma mark UItextField delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == txtLocation) {
        NSString * formString = txtLocation.text;
        if (formString.description != nil && formString != nil && [formString length] > 0 && ![formString isKindOfClass:[NSNull class]] && ![formString isEqualToString:@""]) {
            [txtLocation resignFirstResponder];
            [self searchLocation];
        } else {
            [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:@"Please enter at least one address to search for a location" actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
        }
    }
    return YES;
}


#pragma mark - Other Methods

-(void)searchLocation {
    [mapViewDrivers removeAnnotations:mapViewDrivers.annotations];
    __block CLPlacemark *topResult;
    CLGeocoder *geocoderPop = [[CLGeocoder alloc] init];
    [geocoderPop geocodeAddressString:txtLocation.text
                    completionHandler:^(NSArray* placemarks, NSError* error){
                        if (placemarks && placemarks.count > 0) {
                            topResult = [placemarks objectAtIndex:0];
                            MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                            
                            NSLog(@"CC : %@",placemark.countryCode);
                            NSLog(@"Coun : %@",placemark.country);
                            
                            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(topResult.location.coordinate.latitude, topResult.location.coordinate.longitude);
                            
                            float spanX = 0.05;
                            float spanY = 0.05;
                            MKCoordinateRegion region;
                            region.center.latitude = coord.latitude;
                            region.center.longitude = coord.longitude;
                            region.span.latitudeDelta = spanX;
                            region.span.longitudeDelta = spanY;
                            [mapViewDrivers setRegion:region animated:YES];
                            
                        }
                        
                    }
     ];
}

-(void)handleGesture:(UIGestureRecognizer*)gestureRecognizer {
    [UIView animateWithDuration:0.4 animations:^{
        calloutView.alpha = 0;
    } completion:^(BOOL finished) {
        [calloutView removeFromSuperview];
    }];
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    for (UIView *vi in gestureRecognizer.view.subviews) {
        if ([vi isKindOfClass:[IWadDriverAnnotationView class]])
            return NO;
        else
            return YES;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == calloutView)
        return NO;
    else
        return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press {
    if (press.responder.inputView == calloutView)
        return NO;
    else
        return YES;
}


#pragma mark - Sync Manager Delegate

-(void)syncManagerResponseSuccessWithResponse:(NSDictionary *)response withTag:(NSInteger)tag {
    
    if ([[response valueForKey:@"success"] isEqualToString:@"true"]) {
        NSArray * drivers = [response valueForKey:@"drivers"];
        for (NSDictionary * resp in drivers) {
            
            NSDictionary *dri = [resp valueForKey:@"driver"];
            NSString *name = [NSString stringWithFormat:@"%@ %@",[dri valueForKey:@"first_name"],[dri valueForKey:@"surname"]];
            
            IWadDriver * driver = [[IWadDriver alloc] init];
            driver.driverID = [resp valueForKey:@"driver_id"];
            driver.name = name;
            driver.coordinates = CLLocationCoordinate2DMake([[resp valueForKey:@"lat"] floatValue], [[resp valueForKey:@"lon"] floatValue]);
//            driver.imageURL = [NSString stringWithFormat:@"%@%@",BASE_IMAGE_URL, [resp valueForKey:@"avatar_url"]];
            
            
//            [driversArray addObject:driver];
            
//            NSString *status;
            
//            NSString *updatedDate = [resp valueForKey:@"updated_at"];
//            NSArray * dateArr =[updatedDate componentsSeparatedByString:@"T"];
//            NSString * date = [dateArr objectAtIndex:0];
//            updatedDate = [date stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            
//            NSString * time = [dateArr objectAtIndex:1];
//            NSArray *timeArr = [time componentsSeparatedByString:@"."];
//            time = [NSString stringWithFormat:@"%@:%@",[timeArr objectAtIndex:0],[timeArr objectAtIndex:1]];
            
            IWadAnnotation * annotation = [[IWadAnnotation alloc] init];
            annotation.annotationType = AnnotationTypeDriver;
            annotation.coordinate = driver.coordinates;
//            annotation.title = [NSString stringWithFormat:@"%@",driver.name];
            annotation.status = [[resp valueForKey:@"driver_status_id"] intValue];
//            if (annotation.status == 1) {
//                status = @"Available";
//            } else if (annotation.status == 2) {
//                status = @"On Hold";
//            } else if (annotation.status == 3) {
//                status = @"On a Delivery";
//            }
//            annotation.subtitle = [NSString stringWithFormat:@"Driver ID: %@\tStatus: %@",driver.driverID, status];
            annotation.driver = driver;
            [driverAnnotArray addObject:annotation];
        }
    }
    
    [mapViewDrivers showAnnotations:driverAnnotArray animated:YES];
}

@end
