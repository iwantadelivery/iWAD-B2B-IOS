//
//  NewDeliveryViewController.m
//  iWad
//
//  Created by Saman Kumara on 12/16/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "NewDeliveryStep1ViewController.h"
#import "Delivery.h"
#import "NewDeliveryStep2ViewController.h"
#import "SetLocationViewController.h"
#import "IWadLabel.h"
#import "NSDate+Category.h"
#import "SelectDriverViewController.h"
#import "IWADNavigationViewController.h"
#import "AddNoteViewController.h"
#import "AddDoorNumberViewController.h"

@interface NewDeliveryStep1ViewController () <DelivaryLocationDelegate, DatePickerDelegate, UITextFieldDelegate, UIScrollViewDelegate, SelectDriverDelegate, DeliveryNoteDelegate, DoorNumberDelegate> {
    
    __weak IBOutlet UILabel *lblDate;
    __weak IBOutlet UILabel *lblDriverName;
    __weak IBOutlet UIImageView *imgViewDriverLine;
    __weak IBOutlet UIImageView *imgViewNote;
    __weak IBOutlet UIImageView *imgViewDoorNumber;
    __weak IBOutlet UIImageView *imgViewDoorNumberFrom;
    __weak IBOutlet UILabel *lblTime;
    __weak IBOutlet UITextField *txtName;
    __weak IBOutlet UITextField *txtEmail;
    __weak IBOutlet UITextField *txtDeliveryContact;
    __weak IBOutlet UITextField *txtDeliveryNumber;
    __weak IBOutlet IWadLabel *lblFrom;
    __weak IBOutlet IWadLabel *lblTo;
    __weak IBOutlet UILabel *lblCost;
    __weak IBOutlet UILabel *lblAddDoorNumber;
    __weak IBOutlet UILabel *lblAddDoorNumberFrom;
    __weak IBOutlet UIView *viewDateTime;
    __weak IBOutlet UIButton *btnAuto;
    __weak IBOutlet UIButton *btnManuel;
    __weak IBOutlet UILabel *lblNote;
    __weak IBOutlet UILabel *lblEditNote;
    CLLocationManager *locationManager;
    dispatch_queue_t directionsQueue;
}

@end

@implementation NewDeliveryStep1ViewController

@synthesize showDateTime, deliveryLater, delivery;

-(void)viewWillAppear:(BOOL)animated {
    
    if (deliveryLater) {
        viewDateTime.hidden = NO;
    } else {
        viewDateTime.hidden = YES;
    }
    
    [self resetDriverButtons];
    if (delivery.driver) {
        IWadDriver *driver = delivery.driver;
        lblDriverName.text = driver.name;
        imgViewDriverLine.hidden = NO;
        btnAuto.selected = NO;
        btnManuel.selected = YES;
    } else {
        lblDriverName.text = nil;
        imgViewDriverLine.hidden = YES;
        btnAuto.selected = YES;
        btnManuel.selected = NO;
    }
    
    lblFrom.text = delivery.startAddress;
    lblTo.text = delivery.destinationAddress;
    if ([delivery.note isEmpty] || delivery.note == nil) {
        imgViewNote.highlighted = NO;
        lblEditNote.hidden = YES;
    } else {
        imgViewNote.highlighted = YES;
        lblEditNote.hidden = NO;
    }
    
    
    if (![delivery.doorNumberTo isEmpty] && delivery.doorNumberTo != nil) {
        imgViewDoorNumber.highlighted = YES;
        lblAddDoorNumber.text = @"EDIT DOOR NUMBER - TO";
    } else {
        imgViewDoorNumber.highlighted = NO;
        lblAddDoorNumber.text = @"ADD DOOR NUMBER - TO";
    }
    
    
    if (![delivery.doorNumberFrom isEmpty] && delivery.doorNumberFrom != nil) {
        imgViewDoorNumberFrom.highlighted = YES;
        lblAddDoorNumberFrom.text = @"EDIT DOOR NUMBER - FROM";
    } else {
        imgViewDoorNumberFrom.highlighted = NO;
        lblAddDoorNumberFrom.text = @"ADD DOOR NUMBER - FROM";
    }
    
    if (delivery.deliveryNumber) {
        txtDeliveryNumber.text = delivery.deliveryNumber;
    }
    if (delivery.deliveryContact) {
        txtDeliveryContact.text = delivery.deliveryContact;
    }
    
//    txtName.text = delivery.name;
//    txtEmail.text = delivery.email;
    
    self.title = @"NEW DELIVERY";
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    if (!delivery) {
        delivery = [[Delivery alloc] init];
    }
    directionsQueue = dispatch_queue_create("directionsQueue", NULL);
    locationManager = [AppDelegate sharedInstance].locationManager;
    [[BaseUtilClass sharedInstance] askLocationAuthorization:locationManager];
    
//    [self preloadCurrentLocation];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self dismissKeyboards];
}

#pragma mark - Button Actions

- (IBAction)goNext:(id)sender {
    
}

-(IBAction)selectDriver:(UIButton *)sender {
    [self resetDriverButtons];
    sender.selected = YES;
    if (sender == btnAuto) {
        delivery.driver = nil;
        lblDriverName.text = nil;
        imgViewDriverLine.hidden = YES;
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender {
    
    if ([segue.identifier isEqualToString:@"setLocation"]) {
        
        SetLocationViewController *setLocationVC = [segue destinationViewController];
        setLocationVC.delivaryDelegate = self;
        setLocationVC.delivery = delivery;
        
    } else if ([segue.identifier isEqualToString:@"pickDate"]) {
        
        DatePickerViewController *dvc = [segue destinationViewController];
        dvc.pickerType = DatePickerTypeDate;
        dvc.delegate = self;
        dvc.isDeliveryDate = YES;
        [BaseUtilClass setPopOverArrowColorForViewController:dvc];
        
    } else if ([segue.identifier isEqualToString:@"pickTime"]) {
        
        DatePickerViewController *dvc = [segue destinationViewController];
        dvc.pickerType = DatePickerTypeTime;
        dvc.delegate = self;
        [BaseUtilClass setPopOverArrowColorForViewController:dvc];
        
    } else if ([segue.identifier isEqualToString:@"goNext"]) {
        NewDeliveryStep2ViewController * step2 = [segue destinationViewController];
        delivery.deliveryContact = txtDeliveryContact.text;
        delivery.deliveryNumber = txtDeliveryNumber.text;
        step2.delivery = delivery;
        step2.showDateTime = showDateTime;
    } else if ([segue.identifier isEqualToString:@"selectDriver"]) {
        SelectDriverViewController *svc = [segue destinationViewController];
        svc.delivery = delivery;
        if (delivery.driver) {
            svc.selectedDriver = delivery.driver;
        }
        svc.delegate = self;
    } else if ([segue.identifier isEqualToString:@"addNote"]) {
        AddNoteViewController *avc = [segue destinationViewController];
        avc.delivery = delivery;
        avc.delegate = self;
        UIPopoverPresentationController *popPC = avc.popoverPresentationController;
        popPC.backgroundColor = IWAD_POPOVER_ARROW_COLOR;
        CGRect sourceRect = sender.frame;
        sourceRect.origin.x = sender.frame.size.width - 165;
        sourceRect.origin.y -= 15;
        avc.popoverPresentationController.sourceRect = sourceRect;

    } else if ([segue.identifier isEqualToString:@"addDoorNumberFrom"]) {
        AddDoorNumberViewController *avc = [segue destinationViewController];
        avc.delivery = delivery;
        avc.delegate = self;
        avc.doorNumberType = DoorNumberTypeFrom;
        UIPopoverPresentationController *popPC = avc.popoverPresentationController;
        popPC.backgroundColor = IWAD_POPOVER_ARROW_COLOR;
        
    } else if ([segue.identifier isEqualToString:@"addDoorNumberTo"]) {
        AddDoorNumberViewController *avc = [segue destinationViewController];
        avc.delivery = delivery;
        avc.delegate = self;
        avc.doorNumberType = DoorNumberTypeTo;
        UIPopoverPresentationController *popPC = avc.popoverPresentationController;
        popPC.backgroundColor = IWAD_POPOVER_ARROW_COLOR;
        
    }
    
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([identifier isEqualToString:@"goNext"]) {
        NSString * email = txtEmail.text;
        NSString * name = txtName.text;
        if ([email isEmpty]) {
            email = @"";
        }
        if (![email isValidPhoneNumber]) {
            [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:IWAD_ERROR_NOT_VALID_PHONE actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
            return NO;
        }
        if ([txtDeliveryNumber.text isEmpty] || [txtDeliveryContact.text isEmpty]) {
            [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:IWAD_ERROR_MSG_GENERAL actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
            return NO;
        }
        if (/*[email isEmpty] || */[name isEmpty]) {
            [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:IWAD_ERROR_MSG_GENERAL actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
            return NO;
        } else {
//            if (email.length > 0 && ![email isValidEmail]) {
//                [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:IWAD_ERROR_INVALID_EMAIL actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
//                return NO;
//            } else {
                if (delivery.startAddress == nil || delivery.destinationAddress == nil || [lblFrom.text isEmpty] || [lblTo.text isEmpty]) {
                    [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:@"Please choose delivery start location and destination." actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
                    return NO;
                } else {
                    if (!deliveryLater) {
                        delivery.delivaryDate = @"";
                        delivery.delivaryTime = @"";
                        delivery.email = email;
                        delivery.name = txtName.text;
                        return YES;
                    } else {
                        if (delivery.delivaryDate == nil || delivery.delivaryTime == nil) {
                            [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:IWAD_ERROR_ENTER_DATE_TIME actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
                            return NO;
                        } else {
                            delivery.delivaryDate = lblDate.text;
                            delivery.delivaryTime = lblTime.text;
                            delivery.email = email;
                            delivery.name = txtName.text;
                            return YES;
                        }
                    }
//                }
            }
        }
        
    } else {
        return YES;
    }
}


#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == txtName) {
        [txtEmail becomeFirstResponder];
        
    } else if (textField == txtEmail) {
        [txtDeliveryContact becomeFirstResponder];
        
    } else if (textField == txtDeliveryContact) {
        [txtDeliveryNumber becomeFirstResponder];
        
    } else if (textField == txtDeliveryNumber) {
        [txtDeliveryNumber resignFirstResponder];
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == txtDeliveryContact || textField == txtDeliveryNumber) {
        [UIView animateWithDuration:0.4 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -150);
        }];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == txtDeliveryContact || textField == txtDeliveryNumber) {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.transform = CGAffineTransformIdentity;
        }];
    }
}

#pragma mark - Scroll View Delegate


#pragma mark - Date Picker Delegate
-(void)datePicker:(UIDatePicker *)datepicker didPickDate:(NSDate *)date type:(DatePickerType)type {
    
    if (type == DatePickerTypeTime) {
        lblTime.text = [date stringFromFormat:@"HH:mm"];
        delivery.delivaryTime = lblTime.text;
    }
    
    if (type == DatePickerTypeDate) {
        lblDate.text = [date stringFromFormat:@"dd/MM/yyyy"];
        delivery.delivaryDate = [date stringFromFormat:@"dd-MM-yyyy"];
    }
    
}


#pragma mark - Delivery Note & Door Number Delegate

-(void)deliveryNoteAdded:(NSString *)note {
    if (![delivery.note isEmpty]) {
        imgViewNote.highlighted = YES;
        lblEditNote.hidden = NO;
    } else {
        imgViewNote.highlighted = NO;
        lblEditNote.hidden = YES;
    }
    
    lblNote.text = delivery.note;
}

-(void)deliveryDoorNumberAdded:(NSString *)doorNumber {
    
    if (![delivery.doorNumberTo isEmpty] && delivery.doorNumberTo != nil) {
        imgViewDoorNumber.highlighted = YES;
        lblAddDoorNumber.text = @"EDIT DOOR NUMBER - TO";
    } else {
        imgViewDoorNumber.highlighted = NO;
        lblAddDoorNumber.text = @"ADD DOOR NUMBER - TO";
    }
    
    if (![delivery.doorNumberFrom isEmpty] && delivery.doorNumberFrom != nil) {
        imgViewDoorNumberFrom.highlighted = YES;
        lblAddDoorNumberFrom.text = @"EDIT DOOR NUMBER - FROM";
    } else {
        imgViewDoorNumberFrom.highlighted = NO;
        lblAddDoorNumberFrom.text = @"ADD DOOR NUMBER - FROM";
    }
}


#pragma mark - Delivary Location Delegate
-(void)userDidEnterLocationsFrom:(NSString *)from to:(NSString *)to delivery:(Delivery *)delivary{
    lblFrom.text = from;
    lblTo.text = to;
    
    /**
     *  will go inside if the location coordinates are 0. this could happen when user just come back to this screeen from "set location" screen.
     */
    if (![delivary.startAddress isEmpty] && ![delivary.destinationAddress isEmpty]) {
        
        dispatch_async(directionsQueue, ^{
            NSString *strUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&mode=driving",delivary.startAddress,delivary.destinationAddress];
            NSURL *url = [NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSData *jsonData = [NSData dataWithContentsOfURL:url];
            if(jsonData != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError *error = nil;
                    id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
                    NSMutableArray *arrDistance = [result objectForKey:@"routes"];
                    if ([arrDistance count] == 0) {
                        NSLog(@"ETA : no available ETA"); // no available ETA
                    } else {
                        NSMutableArray *arrLeg = [[arrDistance objectAtIndex:0]objectForKey:@"legs"];
                        NSMutableDictionary *dictleg = [arrLeg objectAtIndex:0];
//                        NSString *eta = [NSString stringWithFormat:@"%@",[[dictleg   objectForKey:@"duration"] objectForKey:@"text"]];
                        
                        
                        NSString *distanceStr = [NSString stringWithFormat:@"%@",[[dictleg   objectForKey:@"distance"] objectForKey:@"text"]];
                        NSArray *dis = [distanceStr componentsSeparatedByString:@"k"];
                        float distance = [[NSString stringWithFormat:@"%@",[dis objectAtIndex:0]] floatValue] * 0.621371;
                        delivary.distance = distance;
                        NSLog(@"ETA dista: %f",distance);
                    }
                });
            } else {
                NSLog(@"ETA : no response"); // no response
            }
        });
        
    }
    
}


#pragma mark - SelectDriverDelegate

-(void)driverSelected:(IWadDriver *)driver {
    [self resetDriverButtons];
    if (driver) {
        lblDriverName.text = driver.name;
        delivery.driver = driver;
        imgViewDriverLine.hidden = NO;
        btnAuto.selected = NO;
        btnManuel.selected = YES;
    } else {
        lblDriverName.text = nil;
        imgViewDriverLine.hidden = YES;
        btnAuto.selected = YES;
        btnManuel.selected = NO;
    }
    
}


-(void)preloadCurrentLocation {
    CLLocationCoordinate2D coordi = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
    delivery.startCoord = coordi;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:locationManager.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        if ([placemark.thoroughfare isKindOfClass:[NSNull class]] || [placemark.thoroughfare isEqualToString:@"(null)"]) {
            lblFrom.text = @"";
        } else {
            lblFrom.text =[NSString stringWithFormat:@"%@, %@, %@, %@",placemark.postalCode, placemark.thoroughfare,placemark.locality, placemark.country];
        }
    }];
}

-(void)resetDriverButtons {
    btnManuel.selected = NO;
    btnAuto.selected = NO;
}

-(void)dismissKeyboards {
    [txtName resignFirstResponder];
    [txtEmail resignFirstResponder];
    [txtDeliveryNumber resignFirstResponder];
    [txtDeliveryContact resignFirstResponder];
}

@end
