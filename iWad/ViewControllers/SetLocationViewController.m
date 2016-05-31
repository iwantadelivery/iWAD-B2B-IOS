//
//  SetLocationViewController.m
//  iWad
//
//  Created by Saman Kumara on 12/17/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "SetLocationViewController.h"
#import "LocationUtil.h"
#import "NSString+Category.h"
#import "IWadAnnotation.h"

@interface SetLocationViewController ()<UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate> {
    AnnotationType selfAnnotType;
    NSMutableArray * annotationsArray;
    CLLocationManager * locationManager;
    CLLocation * curLocation;
    dispatch_queue_t directionsQueue;
    LocationType locationType;
    __weak IBOutlet UIButton * btnCurrentLocation;
    
}
@property (weak, nonatomic) IBOutlet UITextField *startLocationTxt;
@property (weak, nonatomic) IBOutlet UITextField *endLocationTxt;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation SetLocationViewController

@synthesize delivaryDelegate = _delivaryDelegate, delivery;



#pragma mark - View

-(void)viewWillAppear:(BOOL)animated {
    [[BaseUtilClass sharedInstance] askLocationAuthorization:locationManager];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CHANGE PICKUP/DELIVERY LOCATION";
    directionsQueue = dispatch_queue_create("directionsQueue", NULL);
    
    annotationsArray = [NSMutableArray new];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    curLocation = [[CLLocation alloc] init];
    
    self.mapView.showsBuildings         = YES;
    self.mapView.userInteractionEnabled = YES;
    self.mapView.zoomEnabled            = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    if ([BaseUtilClass isConnectedToInternetInVC:self]) {
        [self currentLocation:btnCurrentLocation];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    
}


#pragma mark - Button Actions

-(IBAction)tapDone:(id)sender {
    
    if ([BaseUtilClass isConnectedToInternetInVC:self]) {
        [self resetMap];
        
        __block CLPlacemark *topResult;
        
        [LocationUtil searchLocationForAddress:self.startLocationTxt.text completionHandler:^(NSArray *placemarks, NSError *error) {
            if (placemarks && placemarks.count > 0) {
                topResult = [placemarks objectAtIndex:0];
                MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                
                NSLog(@"CC : %@",placemark.countryCode);
                NSLog(@"Coun : %@",placemark.country);
                
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(topResult.location.coordinate.latitude, topResult.location.coordinate.longitude);
                
                delivery.startCoord = coord;
                
                IWadAnnotation * fromAnnotation = [[IWadAnnotation alloc] init];
                fromAnnotation.title = @"From";
                fromAnnotation.subtitle = self.startLocationTxt.text;
                fromAnnotation.coordinate = coord;
                fromAnnotation.annotationType = AnnotationTypeFrom;
                selfAnnotType = AnnotationTypeFrom;
                [annotationsArray addObject:fromAnnotation];
            }
            
            [self.mapView showAnnotations:annotationsArray animated:YES];
        }];
        
        [LocationUtil searchLocationForAddress:self.endLocationTxt.text completionHandler:^(NSArray *placemarks, NSError *error) {
            if (placemarks && placemarks.count > 0) {
                topResult = [placemarks objectAtIndex:0];
                MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                
                
                NSLog(@"CC : %@",placemark.countryCode);
                NSLog(@"Coun : %@",placemark.country);
                
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(topResult.location.coordinate.latitude, topResult.location.coordinate.longitude);
                
                delivery.destinationCoord = coord;
                
                IWadAnnotation * toAnnotation = [[IWadAnnotation alloc] init];
                toAnnotation.title = @"To";
                toAnnotation.subtitle = self.endLocationTxt.text;
                toAnnotation.coordinate = coord;
                toAnnotation.annotationType = AnnotationTypeTo;
                selfAnnotType = AnnotationTypeTo;
                
                [annotationsArray addObject:toAnnotation];
            }
            
            [self.mapView showAnnotations:annotationsArray animated:YES];
        }];
        [self setDeliveryStartLocation:self.startLocationTxt.text destination:self.endLocationTxt.text];
    }
}


-(IBAction)goBack:(id)sender {
    [self setDeliveryStartLocation:self.startLocationTxt.text destination:self.endLocationTxt.text];
    if ([_delivaryDelegate respondsToSelector:@selector(userDidEnterLocationsFrom:to:delivery:)]) {
        [_delivaryDelegate userDidEnterLocationsFrom:self.startLocationTxt.text to:self.endLocationTxt.text delivery:self.delivery];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)currentLocation:(UIButton *)sender {
    sender.selected = YES;
    [self searchWithCurrentLocation];
    [self.endLocationTxt becomeFirstResponder];
}


#pragma mark - Methods

-(void)setDeliveryStartLocation:(NSString *)startLocation destination:(NSString *)destination {
    delivery.startAddress       = startLocation;
    delivery.destinationAddress = destination;
}

-(void)searchWithCurrentLocation {
    
    if (annotationsArray.count >= 2) {
        [self resetMap];
    }
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:locationManager.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        
        NSMutableArray *addressArr = [NSMutableArray new];
        
        if (placemark.name != nil) {
            if (![placemark.name isEqualToString:placemark.thoroughfare]) {
                [addressArr addObject:placemark.name];
                [addressArr addObject:placemark.thoroughfare];
            } else {
                [addressArr addObject:placemark.thoroughfare];
            }
        }
        
        if (placemark.postalCode != nil) {
            [addressArr addObject:placemark.postalCode];
        } if (placemark.subLocality != nil) {
            [addressArr addObject:placemark.subLocality];
        } if (placemark.locality != nil) {
            [addressArr addObject:placemark.locality];
        }
//        if (placemark.administrativeArea != nil) {
//            [addressArr addObject:placemark.administrativeArea];
//        }
        if (placemark.country != nil) {
            [addressArr addObject:placemark.country];
        }
        
        IWadAnnotation * fromAnnotation = [[IWadAnnotation alloc] init];
        fromAnnotation.title = @"From";
        fromAnnotation.subtitle = [addressArr componentsJoinedByString:@", "];
        fromAnnotation.coordinate = locationManager.location.coordinate;
        fromAnnotation.annotationType = AnnotationTypeFrom;
        delivery.startCoord = locationManager.location.coordinate;
        
//        selfAnnotType = AnnotationTypeFrom;
        [annotationsArray addObject:fromAnnotation];
        
        self.startLocationTxt.text = [addressArr componentsJoinedByString:@", "];
    }];
    
//    [self setDeliveryStartLocation:self.startLocationTxt.text destination:self.endLocationTxt.text];
}

#pragma mark - UItextField delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.startLocationTxt) {
        self.mapView.showsUserLocation = NO;
        [self.endLocationTxt becomeFirstResponder];
        
    } else if (textField == self.endLocationTxt) {
        
        if (![self.startLocationTxt.text isEmpty]) {
            
            if (![self.endLocationTxt.text isEmpty]) {
//                [self tapDone:nil];
                [self.endLocationTxt resignFirstResponder];
                [self.mapView showAnnotations:annotationsArray animated:YES];
            } else {
                [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:@"Please enter destination." actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
                return NO;
            }
        } else {
            [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:@"Please enter start location address." actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
            return NO;
        }
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.startLocationTxt) {
        btnCurrentLocation.selected = NO;
        self.mapView.showsUserLocation = NO;
        [locationManager stopUpdatingLocation];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.startLocationTxt) {
        if (textField.text.length >= 4) {
            if ([BaseUtilClass isConnectedToInternetInVC:self]) {
                [self addressForPostalCode:self.startLocationTxt.text locationType:LocationTypeFrom];
            }
        }
    }
    
    if (textField == self.endLocationTxt) {
        if (textField.text.length >= 4) {
            if ([BaseUtilClass isConnectedToInternetInVC:self]) {
                [self addressForPostalCode:self.startLocationTxt.text locationType:LocationTypeFrom];
                [self addressForPostalCode:self.endLocationTxt.text locationType:LocationTypeTo];
            }
        }
    }
}

-(BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField == self.startLocationTxt) {
//        if ([self.endLocationTxt.text isEmpty]) {
            [self resetMap];
//        }
    }
    if (textField == self.endLocationTxt) {
        if ([self.startLocationTxt.text isEmpty]) {
            [self resetMap];
        } else {
            [annotationsArray removeObjectAtIndex:1];
            [self.mapView removeAnnotations:self.mapView.annotations];
            [self.mapView removeOverlays:self.mapView.overlays];
        }
    }
    return YES;
}

- (void)addressForPostalCode:(NSString *)postalcode locationType:(LocationType)type {
    __block NSString *address;
    if (annotationsArray.count >= 2) {
        [self resetMap];
    }
    dispatch_async(directionsQueue, ^{
        
        NSString *strUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=&components=postal_code:%@&sensor=false",postalcode];
        NSURL *url = [NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSData *jsonData = [NSData dataWithContentsOfURL:url];
        if(jsonData != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = nil;
                id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
                
                if (!result) {
                    NSLog(@"no address");
                } else {
                    NSArray *results = [result objectForKey:@"results"];
                    if (results.count > 0) {
                        NSDictionary *dict = [results objectAtIndex:0];
                        NSDictionary *geometry = [dict valueForKey:@"geometry"];
                        address = [dict valueForKey:@"formatted_address"];
                        float lat = [[[geometry valueForKey:@"location"] valueForKey:@"lat"] floatValue];
                        float lon = [[[geometry valueForKey:@"location"] valueForKey:@"lng"] floatValue];
                        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(lat, lon);
                        
                        NSLog(@"address: %@",address);
                        
                        if (type == LocationTypeFrom) {
                            delivery.startCoord = coord;
                            
                            IWadAnnotation * fromAnnotation = [[IWadAnnotation alloc] init];
                            fromAnnotation.title = @"From";
                            fromAnnotation.subtitle = address;
                            fromAnnotation.coordinate = coord;
                            fromAnnotation.annotationType = AnnotationTypeFrom;
//                            selfAnnotType = AnnotationTypeFrom;
                            [annotationsArray addObject:fromAnnotation];
                            
                            self.startLocationTxt.text = address;
                            
                        } else if (type == LocationTypeTo) {
                            delivery.destinationCoord = coord;
                            
                            IWadAnnotation * toAnnotation = [[IWadAnnotation alloc] init];
                            toAnnotation.title = @"To";
                            toAnnotation.subtitle = address;
                            toAnnotation.coordinate = coord;
                            toAnnotation.annotationType = AnnotationTypeTo;
//                            selfAnnotType = AnnotationTypeTo;
                            [annotationsArray addObject:toAnnotation];
                            
                            self.endLocationTxt.text = address;
                            
                        }
                        
                        [self.mapView showAnnotations:annotationsArray animated:YES];
                        [self setDeliveryStartLocation:self.startLocationTxt.text destination:self.endLocationTxt.text];
                        
                    } else {
                        __block CLPlacemark *topResult;
                        [LocationUtil searchLocationForAddress:postalcode completionHandler:^(NSArray *placemarks, NSError *error) {
                            if (placemarks && placemarks.count > 0) {
                                topResult = [placemarks objectAtIndex:0];
                                
                                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(topResult.location.coordinate.latitude, topResult.location.coordinate.longitude);
                                
                                IWadAnnotation * annotation = [[IWadAnnotation alloc] init];
                                annotation.subtitle = postalcode;
                                annotation.coordinate = coord;
                                if (type == LocationTypeFrom) {
                                    annotation.title = @"From";
                                    annotation.annotationType = AnnotationTypeFrom;
                                    selfAnnotType = AnnotationTypeFrom;
                                    delivery.startCoord = coord;
                                    
                                } else if (type == LocationTypeTo) {
                                    annotation.title = @"To";
                                    annotation.annotationType = AnnotationTypeTo;
                                    selfAnnotType = AnnotationTypeTo;
                                    delivery.destinationCoord = coord;
                                    
                                }
                                [annotationsArray addObject:annotation];
                            }
                            
                            [self.mapView showAnnotations:annotationsArray animated:YES];
                        }];
                        [self setDeliveryStartLocation:self.startLocationTxt.text destination:self.endLocationTxt.text];
                    }
                    
                }
            });
        } else {
            NSLog(@"address : no response"); // no response
        }
    });
}


#pragma mark - Map delegate
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor =  IWAD_TEXT_COLOR;
    renderer.lineWidth = 4.0;
    return renderer;
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation {
    MKPinAnnotationView *pin = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
    if (pin == nil)
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"asdf"];
    else
        pin.annotation = annotation;
    
    for (IWadAnnotation * annot in annotationsArray) {
        selfAnnotType = annot.annotationType;
        if (selfAnnotType == AnnotationTypeFrom) {
            pin.pinColor = MKPinAnnotationColorGreen;
        } else if (selfAnnotType == AnnotationTypeTo) {
            pin.pinColor = MKPinAnnotationColorRed;
        }
    }
    pin.userInteractionEnabled  = YES;
    pin.canShowCallout          = YES;
    pin.animatesDrop            = YES;
    return pin;
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    if (annotationsArray.count == 2) {
        [self drawRoad];
    }
}


#pragma mark - Map Routes

-(void)drawRoad {
    if (annotationsArray.count > 0) {
        
        CLLocationCoordinate2D sourceCoodinate;
        CLLocationCoordinate2D destinationCoodinate;
        sourceCoodinate = delivery.startCoord;
        destinationCoodinate = delivery.destinationCoord;
        
        MKPlacemark * sourcePlaceMark   = [[MKPlacemark alloc] initWithCoordinate:sourceCoodinate addressDictionary:nil];
        MKMapItem * sourceMapItem       = [[MKMapItem alloc] initWithPlacemark:sourcePlaceMark];
        MKPlacemark * destinationPlaceMark  = [[MKPlacemark alloc] initWithCoordinate:destinationCoodinate addressDictionary:nil];
        MKMapItem * destinationMapItem      = [[MKMapItem alloc] initWithPlacemark:destinationPlaceMark];
        
        MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
        [request setSource:sourceMapItem];
        [request setDestination:destinationMapItem];
        [request setTransportType:MKDirectionsTransportTypeAny]; // This can be limited to automobile and walking directions.
        [request setRequestsAlternateRoutes:NO]; // Gives you several route options.
        MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
            if (!error) {
                for (MKRoute *route in [response routes]) {
                    [self.mapView addOverlay:[route polyline] level:MKOverlayLevelAboveRoads];
                }
            }
        }];
    }
}


#pragma mark - Other Methods

- (void)resetMap {
    [annotationsArray removeAllObjects];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
}

@end
