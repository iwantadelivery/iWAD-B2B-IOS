//
//  DeliveryDetailMainViewController.m
//  iWAD
//
//  Created by Himal Madhushan on 2/1/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "DeliveryDetailMainViewController.h"
#import "DeliveryDetailSSub_1_ViewController.h"
#import "IWadAnnotation.h"
#import "Driver.h"
#import "IWadDriverAnnotationView.h"
#import "DriverCalloutViewController.h"
#import "DeliveryDetailSSub_2_ViewController.h"

@interface DeliveryDetailMainViewController () <MKMapViewDelegate, SyncManagerDelegate, UIGestureRecognizerDelegate> {
    __weak IBOutlet UIView *containerView;
    __weak IBOutlet UIView *containerViewSignature;
    __weak IBOutlet MKMapView *mapViewDetail;
    NSMutableArray * annotationsArray, *driverAnnotationArr;
    AnnotationType selfAnnotType;
    SyncManager *syncManager;
    NSTimer *timer;
    IWadDriverAnnotationView *calloutView;
}

@end

@implementation DeliveryDetailMainViewController

@synthesize delivery;

-(void)viewWillAppear:(BOOL)animated {
    [self createAnnotations];
    self.title = [NSString stringWithFormat:@"ORDER ID : %@",delivery.deliveryID];
    timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(updateDriverLocation) userInfo:nil repeats:YES];
    [timer fire];
    syncManager = [[SyncManager alloc] initWithDelegate:self];
    [self updateDriverLocation];
    
    if ([delivery.status isEqualToNumber:[NSNumber numberWithInt:5]]) {
        containerViewSignature.hidden = NO;
    } else {
        containerViewSignature.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    annotationsArray = [NSMutableArray new];
    driverAnnotationArr = [NSMutableArray new];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    tapGesture.delegate = self;
    [mapViewDetail addGestureRecognizer:tapGesture];
}

-(void)viewWillDisappear:(BOOL)animated {
    [timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetails"]) {
        DeliveryDetailSSub_1_ViewController *embed = segue.destinationViewController;
        embed.delivery = delivery;
    }
    if ([[segue identifier] isEqualToString:@"showDetails2"]) {
        DeliveryDetailSSub_2_ViewController *embed = segue.destinationViewController;
        embed.delivery = delivery;
    }
}


#pragma mark - Map Routes
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 5.0;
    return renderer;
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation {
    IWadAnnotation *annot = (IWadAnnotation *)annotation;
    MKPinAnnotationView *pin = (MKPinAnnotationView *) [mapViewDetail dequeueReusableAnnotationViewWithIdentifier: @"pin"];
    if (pin == nil)
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier: @"asdf"];
    else
        pin.annotation = annotation;
    
    if (annot.annotationType == AnnotationTypeFrom) {
        pin.pinColor = MKPinAnnotationColorGreen;
    } else if (annot.annotationType == AnnotationTypeTo) {
        pin.pinColor = MKPinAnnotationColorRed;
    } else if (annot.annotationType == AnnotationTypeDriver) {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"driverAnnot"];
        annotationView.image = [UIImage imageNamed:@"vanNotOnDelivery"];
        return annotationView;
    }
    CLLocationCoordinate2D me       = mapViewDetail.userLocation.coordinate;
    CLLocationCoordinate2D annoCo   = annotation.coordinate;
    if (annoCo.latitude == me.latitude) {
        pin.pinColor = MKPinAnnotationColorPurple;
    }
    pin.userInteractionEnabled  = YES;
    pin.canShowCallout          = YES;
    pin.animatesDrop            = YES;
    return pin;
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    if (annotationsArray.count > 1) {
        [self drawRoad];
    }
}


-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
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


-(void)createAnnotations {
    [mapViewDetail removeAnnotations:mapViewDetail.annotations];
    [annotationsArray removeAllObjects];
    CLLocationCoordinate2D sourceCoodinate = CLLocationCoordinate2DMake([delivery.fromLatitude floatValue], [delivery.fromLongitude floatValue]);
    CLLocationCoordinate2D destinationCoodinate = CLLocationCoordinate2DMake([delivery.toLatitude floatValue], [delivery.toLongitude floatValue]);
    
    IWadAnnotation * toAnnotation = [[IWadAnnotation alloc] init];
    toAnnotation.title = @"To";
    toAnnotation.subtitle = delivery.toAddress;
    toAnnotation.coordinate = destinationCoodinate;
    toAnnotation.annotationType = AnnotationTypeTo;
    selfAnnotType = AnnotationTypeTo;
    [annotationsArray addObject:toAnnotation];
    
    IWadAnnotation * fromAnnotation = [[IWadAnnotation alloc] init];
    fromAnnotation.title = @"From";
    fromAnnotation.subtitle = delivery.fromAddress;
    fromAnnotation.coordinate = sourceCoodinate;
    fromAnnotation.annotationType = AnnotationTypeFrom;
    selfAnnotType = AnnotationTypeTo;
    [annotationsArray addObject:fromAnnotation];
    
    [mapViewDetail showAnnotations:annotationsArray animated:YES];
}

-(void)drawRoad {
    CLLocationCoordinate2D sourceCoodinate;
    CLLocationCoordinate2D destinationCoodinate;
    sourceCoodinate = CLLocationCoordinate2DMake([delivery.fromLatitude floatValue], [delivery.fromLongitude floatValue]);
    destinationCoodinate = CLLocationCoordinate2DMake([delivery.toLatitude floatValue], [delivery.toLongitude floatValue]);
    
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
        if (error) {
//            [BaseUtilClass showAlertViewInViewController:self title:@"Sorry!" message:@"Directions are not available." actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
        }
        if (!error) {
            for (MKRoute *route in [response routes]) {
                [mapViewDetail addOverlay:[route polyline] level:MKOverlayLevelAboveRoads];
            }
        }
    }];
}


#pragma mark - Other Methods

-(void)updateDriverLocation {
    if ([BaseUtilClass isConnectedToInternetInVC:self]) {
        Driver *driver = delivery.driverRS;
        NSString *driverIDStr = [NSString stringWithFormat:@"%@",driver.driverID];
        [syncManager fetchDriverLocationOfDeliveryForDriverID:driverIDStr];
    } else {
        [timer invalidate];
    }
}

-(void)handleGesture:(UIGestureRecognizer*)gestureRecognizer {
    if ([gestureRecognizer.view isKindOfClass:[IWadDriverAnnotationView class]]) {
        return;
    }
    NSLog(@"%@",gestureRecognizer.view);
    [UIView animateWithDuration:0.4 animations:^{
        calloutView.alpha = 0;
    } completion:^(BOOL finished) {
       [calloutView removeFromSuperview];
    }];
}

#pragma mark - SyncManagerDelegate

-(void)syncManagerResponseSuccessWithResponse:(NSDictionary *)response withTag:(NSInteger)tag {
    
    [mapViewDetail removeAnnotations:driverAnnotationArr];
    [driverAnnotationArr removeAllObjects];
    
    if ([[response valueForKey:@"success"] isEqualToString:@"true"]) {
        NSDictionary *driverDic = [response valueForKey:@"driver"];
        CLLocationCoordinate2D driverCoodinate;
        
        IWadDriver *driver = [[IWadDriver alloc] init];
        driver.name = [NSString stringWithFormat:@"%@ %@",[driverDic valueForKey:@"first_name"], [driverDic valueForKey:@"surname"]];
        driver.driverID = [driverDic valueForKey:@"driver_id"];
        if (![[driverDic valueForKey:@"lat"] isKindOfClass:[NSNull class]]) {
            driver.coordinates = CLLocationCoordinate2DMake([[driverDic valueForKey:@"lat"] floatValue], [[driverDic valueForKey:@"lon"] floatValue]);
        }
        driver.mobile = [driverDic valueForKey:@"mobile"];
        
        IWadAnnotation * driverAnnotation = [[IWadAnnotation alloc] init];
        driverAnnotation.driver = driver;
        driverAnnotation.annotationType = AnnotationTypeDriver;
        if (![[driverDic valueForKey:@"lat"] isKindOfClass:[NSNull class]]) {
            driverCoodinate = CLLocationCoordinate2DMake([[driverDic valueForKey:@"lat"] floatValue], [[driverDic valueForKey:@"lon"] floatValue]);
            driverAnnotation.coordinate = driverCoodinate;
            [driverAnnotationArr addObject:driverAnnotation];
        } else {
//            [BaseUtilClass showAlertViewInViewController:self title:@"Sorry!" message:@"Driver is currently unavailable." actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
        }
        [mapViewDetail addAnnotations:driverAnnotationArr];
    }
   
    
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.view == calloutView)
        return NO;
    else
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
@end
