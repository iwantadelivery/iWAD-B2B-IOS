//
//  ViewDeliveryDetailsViewController.m
//  iWAD
//
//  Created by Himal Madhushan on 2/1/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "DeliveryDetailSSub_1_ViewController.h"
#import "Driver.h"
#import "LocationPopupViewController.h"
#import "ViewNoteViewController.h"

@interface DeliveryDetailSSub_1_ViewController () <IWADDelegate> {
    __weak IBOutlet UILabel *lblPayload;
    __weak IBOutlet UILabel *lblDimension;
    __weak IBOutlet UILabel *lblDriverName;
    __weak IBOutlet UILabel *lblClientName;
    __weak IBOutlet UILabel *lblFrom;
    __weak IBOutlet UILabel *lblTo;
    __weak IBOutlet UILabel *lblDeliveryContact;
    __weak IBOutlet UILabel *lblDeliveryNumber;
    __weak IBOutlet UILabel *lblDate;
    __weak IBOutlet UILabel *lblTime;
    __weak IBOutlet UILabel *lblCost;
    __weak IBOutlet UILabel *lblDistance;
    __weak IBOutlet UILabel *lblETA_TIme;
    __weak IBOutlet UILabel *lblETA;
    __weak IBOutlet UIImageView *imgViewDriverPic;
    __weak IBOutlet UIImageView *imgViewVehicle;
    __weak IBOutlet UIView *viewDateTime;
    __weak IBOutlet UIView *viewFrom;
    __weak IBOutlet UIView *viewTo;
    
    __weak IBOutlet UILabel *lblStatus;
    __weak IBOutlet UIImageView *imgViewStatus;
    
    CGRect myRect;
    dispatch_queue_t directionsQueue;
    NSTimer *timer;
}

@end

@implementation DeliveryDetailSSub_1_ViewController

@synthesize delivery;

#pragma mark - View

-(void)viewWillAppear:(BOOL)animated {
    Driver *driver = delivery.driverRS;
    if (driver.fName) {
        [self setDriverImageForURL:[NSString stringWithFormat:@"%@",driver.photoURL]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [AppDelegate sharedInstance].currentVC = self;
    directionsQueue = dispatch_queue_create("directionsQueue", NULL);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated {
    [self updateDeliveryDetails];
    if (![delivery.status isEqualToNumber:[NSNumber numberWithInt:5]]) {
        timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(updateDeliveryDetails) userInfo:nil repeats:YES];
        [timer fire];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [timer invalidate];
}

#pragma mark - Button Actions

- (IBAction)viewFromAddress:(id)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
    myRect = CGRectMake(cellRect.origin.x+viewFrom.frame.origin.x+137, cellRect.origin.y + viewFrom.frame.origin.y + 71, viewFrom.frame.size.width, viewFrom.frame.size.height);
    
    LocationPopupViewController *lvc = [[LocationPopupViewController alloc] initWithType:LocationTypeFrom address:delivery.fromAddress frame:myRect];
    [lvc showInView:[BaseUtilClass superView]];
}
- (IBAction)viewToAddress:(id)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
    myRect = CGRectMake(cellRect.origin.x+viewTo.frame.origin.x+137, cellRect.origin.y + viewTo.frame.origin.y + 71, viewTo.frame.size.width, viewTo.frame.size.height);
    
    LocationPopupViewController *lvc = [[LocationPopupViewController alloc] initWithType:LocationTypeTo address:delivery.toAddress frame:myRect];
    [lvc showInView:[BaseUtilClass superView]];
}


#pragma mark - Other Methods

-(void)setETAFromCoordinates:(CLLocationCoordinate2D)fromCoord toCoordinated:(CLLocationCoordinate2D)toCoord {
    dispatch_async(directionsQueue, ^{
        NSString *strUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&mode=%@", fromCoord.latitude, fromCoord.longitude, toCoord.latitude, toCoord.longitude, @"driving"];
        NSURL *url = [NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSData *jsonData = [NSData dataWithContentsOfURL:url];
        if(jsonData != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = nil;
                id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
                NSMutableArray *arrDistance = [result objectForKey:@"routes"];
                if ([arrDistance count] == 0) {
                    NSLog(@"ETA : no available ETA"); // no available ETA
                    lblETA_TIme.text = IWAD_ERROR_NOT_APPLICABLE;
                    lblDistance.text = IWAD_ERROR_NOT_APPLICABLE;
                } else {
                    NSMutableArray *arrLeg = [[arrDistance objectAtIndex:0] objectForKey:@"legs"];
                    NSMutableDictionary *dictleg = [arrLeg objectAtIndex:0];
                    NSString *eta = [NSString stringWithFormat:@"%@",[[dictleg objectForKey:@"duration"] objectForKey:@"text"]];
                    lblETA_TIme.text = eta;//.uppercaseString;
                    
//                    NSString *distance = [NSString stringWithFormat:@"%@",[[dictleg   objectForKey:@"distance"] objectForKey:@"text"]];
//                    lblDistance.text = distance;//.uppercaseString;
                    
                    NSString *distanceStr = [NSString stringWithFormat:@"%@",[[dictleg objectForKey:@"distance"] objectForKey:@"text"]];
                    NSArray *dis = [distanceStr componentsSeparatedByString:@"k"];
                    float distance = [[NSString stringWithFormat:@"%@",[dis objectAtIndex:0]] floatValue] * 0.621371;
                    lblDistance.text = [NSString stringWithFormat:@"%.2f Miles",distance];
                }
            });
        } else {
            NSLog(@"ETA : no response"); // no response
        }
    });
}

-(void)updateDeliveryDetails {
    
    lblDeliveryContact.text = delivery.deliveryContact;
    lblDeliveryNumber.text = delivery.deliveryNumber;
    
    if ([delivery.deliveryDate isEqualToString:kNO_DATE]) {
        viewDateTime.hidden = YES;
    } else {
        lblDate.text = delivery.deliveryDate;
        lblTime.text = delivery.deliveryTime;
    }
    
    if ([delivery.vehicleID isEqualToNumber:[NSNumber numberWithInt:1]]) {
        imgViewVehicle.image = [UIImage imageNamed:@"deliveriesNewDeliveryCarInactiveIcon"];
        lblPayload.text = VEHICLE_PAYLOAD_CAR;
        lblDimension.text = VEHICLE_DIMENSION_CAR;
    } else if ([delivery.vehicleID isEqualToNumber:[NSNumber numberWithInt:2]]) {
        imgViewVehicle.image = [UIImage imageNamed:@"deliveriesNewDeliveryVanInactiveIcon"];
        lblPayload.text = VEHICLE_PAYLOAD_VAN;
        lblDimension.text = VEHICLE_DIMENSION_VAN;
    } else if ([delivery.vehicleID isEqualToNumber:[NSNumber numberWithInt:3]]) {
        imgViewVehicle.image = [UIImage imageNamed:@"deliveriesNewDeliveryBikeInactiveIcon"];
        lblPayload.text = VEHICLE_PAYLOAD_BIKE;
    }
    
    lblFrom.text = delivery.fromAddress;
    lblTo.text = delivery.toAddress;
    Driver *driver = delivery.driverRS;
    if (driver) {
        lblDriverName.text = [NSString stringWithFormat:@"(ID: %@) %@ %@",driver.driverID, driver.fName, driver.surName];
    }
    lblCost.text = [NSString stringWithFormat:@"%@",delivery.cost];
    if (delivery.name == nil) {
        lblClientName.text = @"";
    } else {
        lblClientName.text = delivery.name;
    }
    
    if ([delivery.status isEqualToNumber:[NSNumber numberWithInt:1]]) {
        if ([delivery.isManuel isEqualToNumber:[NSNumber numberWithInt:0]]) {
            imgViewStatus.image = [UIImage imageNamed:@"deliveriesDriverAllocatedInactiveIcon"];
            lblStatus.text = @"Allocating Driver";
            lblStatus.textColor = IWAD_TEXT_COLOR;
        } else {
            imgViewStatus.image = [UIImage imageNamed:@"deliveriesDriverAllocatedActiveIcon"];
            lblStatus.text = @"Driver Allocated";
            lblStatus.textColor = DELIVERIES_TXTCOLOR_GREEN;
            
        }
        lblETA.text = @"DISTANCE & ETA TO PICKUP POINT";
        [self setETAFromCoordinates:CLLocationCoordinate2DMake([driver.latitude floatValue], [driver.longitude floatValue])
                      toCoordinated:CLLocationCoordinate2DMake([delivery.fromLatitude floatValue], [delivery.fromLatitude floatValue])];
        
    } else if ([delivery.status isEqualToNumber:[NSNumber numberWithInt:2]]) {
        imgViewStatus.image = [UIImage imageNamed:@"deliveriesDriverAllocatedActiveIcon"];
        lblStatus.text = DELIVERY_DRIVER_ALLOCATED;
        lblStatus.textColor = DELIVERIES_TXTCOLOR_GREEN;
        lblETA.text = @"DISTANCE & ETA TO PICKUP POINT";
        [self setETAFromCoordinates:CLLocationCoordinate2DMake([driver.latitude floatValue], [driver.longitude floatValue])
                      toCoordinated:CLLocationCoordinate2DMake([delivery.fromLatitude floatValue], [delivery.fromLatitude floatValue])];
        
    } else if ([delivery.status isEqualToNumber:[NSNumber numberWithInt:3]]) {
        imgViewStatus.image = [UIImage imageNamed:@"deliveriesPickedUpActiveIcon"];
        lblStatus.text = @"Picked Up";
        lblStatus.textColor = DELIVERIES_TXTCOLOR_GREEN;
        lblETA.text = @"DISTANCE & ETA TO DELIVERY POINT";
        [self setETAFromCoordinates:CLLocationCoordinate2DMake([driver.latitude floatValue], [driver.longitude floatValue])
                      toCoordinated:CLLocationCoordinate2DMake([delivery.toLatitude floatValue], [delivery.toLongitude floatValue])];
        
    } else if ([delivery.status isEqualToNumber:[NSNumber numberWithInt:4]]) {
        imgViewStatus.image = [UIImage imageNamed:@"deliveriesEnRouteIconActive"];
        lblStatus.text = @"En Route To Deliver";
        lblStatus.textColor = DELIVERIES_TXTCOLOR_GREEN;
        lblETA.text = @"DISTANCE & ETA TO DELIVERY POINT";
        [self setETAFromCoordinates:CLLocationCoordinate2DMake([driver.latitude floatValue], [driver.longitude floatValue])
                      toCoordinated:CLLocationCoordinate2DMake([delivery.toLatitude floatValue], [delivery.toLongitude floatValue])];
        
    } else if ([delivery.status isEqualToNumber:[NSNumber numberWithInt:5]]) {
        imgViewStatus.image = [UIImage imageNamed:@"deliveriesDeliveredActiveIcon"];
        lblStatus.text = @"Delivered";
        lblStatus.textColor = DELIVERIES_TXTCOLOR_GREEN;
        lblETA.text = @"DISTANCE & ETA TO DELIVERY POINT";
        lblETA_TIme.text = IWAD_ERROR_NOT_APPLICABLE;
        lblDistance.text = IWAD_ERROR_NOT_APPLICABLE;
        
    }
}

-(void)setDriverImageForURL:(NSString *)imgURL {
    dispatch_queue_t driverImageQueue = dispatch_queue_create("driverImageQueue", NULL);
    dispatch_async(driverImageQueue, ^{
        NSError *error;
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL] options:NSDataReadingUncached error:&error];
        if (imgData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imgViewDriverPic.image = [UIImage imageWithData:imgData];
                imgViewDriverPic.alpha = 0;
                [UIView animateWithDuration:0.3 animations:^{
                    imgViewDriverPic.alpha = 1;
                }];
            });
        } else
            imgViewDriverPic.image = [UIImage imageNamed:@"userProfDefaultPic"];
        
    });
}


#pragma mark - IWAD Delegate
-(void)changedDeliverStatus:(NSDictionary *)userInfo {
//    NSDictionary *dictionary = [userInfo valueForKey:@"aps"];
//    NSString *message = [dictionary valueForKey:@"alert"];
    NSLog(@"on detail VC : %@",userInfo);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"viewNote"]) {
        ViewNoteViewController *vnvc = [segue destinationViewController];
        vnvc.delivery = delivery;
        [BaseUtilClass setPopOverArrowColorForViewController:vnvc];
    }
}


@end
