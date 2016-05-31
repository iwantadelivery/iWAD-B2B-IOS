//
//  NewDeliveryStep3ViewController.m
//  iWad
//
//  Created by Saman Kumara on 12/16/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "NewDeliveryStep3ViewController.h"
#import "IWadLabel.h"
#import "NewDeliveryNewPaymentViewController.h"
#import "SetLocationViewController.h"
#import "IWadPromoCode.h"
#import "AddNoteViewController.h"
#import "AddDoorNumberViewController.h"

@interface NewDeliveryStep3ViewController () <DelivaryLocationDelegate, SyncManagerDelegate, UITextFieldDelegate, DatePickerDelegate, DeliveryNoteDelegate, DoorNumberDelegate> {
    
    __weak IBOutlet UILabel *lblDate;
    __weak IBOutlet UILabel *lblTime;
    __weak IBOutlet UILabel *lblCost;
    __weak IBOutlet UIView * viewDateTime;
    __weak IBOutlet UIButton *btnAddDoorNumber;
    __weak IBOutlet IWadTextField *txtPromoCode;
    __weak IBOutlet IWadTextField *txtDeliveryContact;
    __weak IBOutlet IWadTextField *txtDeliveryNumber;
    
    IBOutlet UILabel *lblDriverName;
    IBOutlet UIImageView *imgViewYellowLine;
    IBOutlet UIImageView *imgViewNote;
    __weak IBOutlet UIImageView * imgViewVehicle;
    __weak IBOutlet UIImageView * imgViewDoorNumber;
    __weak IBOutlet UIImageView * imgViewDoorNumberFrom;
    IBOutlet UILabel *lblDoorNumberFrom;
    IBOutlet UILabel *lblDoorNumberTo;
    
    SyncManager * sm;
    dispatch_queue_t directionsQueue;
    NSMutableArray * promoArray;
    
}
@property (weak, nonatomic) IBOutlet IWadTextField *nameTxt;
@property (weak, nonatomic) IBOutlet IWadTextField *emailTxt;
@property (weak, nonatomic) IBOutlet IWadLabel *fromLbl;
@property (weak, nonatomic) IBOutlet IWadLabel *toLbl;
@property (weak, nonatomic) IBOutlet UILabel *vehicleTypeLbl;
@property (weak, nonatomic) IBOutlet UILabel *dimensionLbl;
@property (weak, nonatomic) IBOutlet UILabel *payLoadLbl;
@property (weak, nonatomic) IBOutlet UILabel *peopleCountLbl;

@end

@implementation NewDeliveryStep3ViewController

@synthesize delivery, showDateTime;

#pragma mark - View

-(void)viewWillAppear:(BOOL)animated {
    
    if (!showDateTime) {
        viewDateTime.hidden = YES;
    } else {
        viewDateTime.hidden = NO;
    }
    
    txtPromoCode.enabled = YES;
    IWadVehicle *vehicle = delivery.vehicle;
    if ([vehicle.vehicleType isEqualToString:VEHICLE_TYPE_VAN]) {
        imgViewVehicle.image = [UIImage imageNamed:@"deliveriesNewDeliveryVanInactiveIcon"];
        
    } else if ([vehicle.vehicleType isEqualToString:VEHICLE_TYPE_CAR]) {
        imgViewVehicle.image = [UIImage imageNamed:@"deliveriesNewDeliveryCarInactiveIcon"];
        
    } else if ([vehicle.vehicleType isEqualToString:VEHICLE_TYPE_BIKE]) {
        imgViewVehicle.image = [UIImage imageNamed:@"deliveriesNewDeliveryBikeInactiveIcon"];
    }
    
    if (delivery.driver) {
        IWadDriver *driver = delivery.driver;
        lblDriverName.text = driver.name;
        imgViewYellowLine.hidden = NO;
    } else {
        lblDriverName.text = @"";
        imgViewYellowLine.hidden = YES;
    }
    
    self.nameTxt.text = delivery.name;
    self.emailTxt.text = delivery.email;
    self.fromLbl.text = delivery.startAddress;
    self.toLbl.text = delivery.destinationAddress;
    self.vehicleTypeLbl.text = vehicle.vehicleType;
    self.dimensionLbl.text = vehicle.vehicleDimension;
    self.payLoadLbl.text = vehicle.vehiclePayload;
    self.peopleCountLbl.text = [NSString stringWithFormat:@"%ld", (long)delivery.noOfPeople];
    txtPromoCode.text = delivery.promoCode;
    lblDate.text = delivery.delivaryDate;
    lblTime.text = delivery.delivaryTime;
    
    [lblCost adjustsFontSizeToFitWidth];
    lblCost.text = [NSString stringWithFormat:@"%.2f",delivery.cost];
    
    [self checkNoteAvailability];
    [self checkDoorNumberAvailability];
    
    promoArray = [NSMutableArray new];
    if ([BaseUtilClass isConnectedToInternetInVC:self]) {
        sm = [[SyncManager alloc] initWithDelegate:self];
        [sm fetchPromoCodes];
    }
    
    if (delivery.deliveryNumber) {
        txtDeliveryNumber.text = delivery.deliveryNumber;
    }
    if (delivery.deliveryContact) {
        txtDeliveryContact.text = delivery.deliveryContact;
    }
    
    
    [self setManualCost:17.0];
    
//    self.promoCodeLbl.placeholder = @"Fetching promo codes...";
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NEW DELIVERY";
    [self registerForKeyboardNotifications];
    directionsQueue = dispatch_queue_create("directionsQueue", NULL);
}

-(void)viewWillDisappear:(BOOL)animated {
    [self dismissKeyboards];
}


#pragma mark - Button Actions

-(IBAction)pickDate:(id)sender {
    
}

-(IBAction)pickTime:(id)sender {
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"goNext"]) {
        NewDeliveryNewPaymentViewController * deliveryVC = [segue destinationViewController];
        deliveryVC.delivery = self.delivery;
        
    } else if ([segue.identifier isEqualToString:@"setLocation"]) {
        SetLocationViewController *setLocationVC = [segue destinationViewController];
        setLocationVC.delivery = self.delivery;
        setLocationVC.delivaryDelegate = self;
        
    } else if ([segue.identifier isEqualToString:@"pickDate"]) {
        DatePickerViewController *dvc = [segue destinationViewController];
        dvc.pickerType = DatePickerTypeDate;
        dvc.delegate = self;
        [BaseUtilClass setPopOverArrowColorForViewController:dvc];
        
    } else if ([segue.identifier isEqualToString:@"pickTime"]) {
        DatePickerViewController *dvc = [segue destinationViewController];
        dvc.pickerType = DatePickerTypeTime;
        dvc.delegate = self;
        [BaseUtilClass setPopOverArrowColorForViewController:dvc];
        
    } else if ([segue.identifier isEqualToString:@"addNote"]) {
        AddNoteViewController *avc = [segue destinationViewController];
        avc.delegate = self;
        avc.delivery = delivery;
        [BaseUtilClass setPopOverArrowColorForViewController:avc];
        
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


#pragma mark - Date Picker Delegate
-(void)datePicker:(UIDatePicker *)datepicker didPickDate:(NSDate *)date type:(DatePickerType)type {
    
    if (type == DatePickerTypeTime) {
        lblTime.text = [date stringFromFormat:@"HH:mm aa"];
        delivery.delivaryTime = lblTime.text;
    }
    
    if (type == DatePickerTypeDate) {
        lblDate.text = [date stringFromFormat:@"dd/MM/yyyy"];
        delivery.delivaryDate = [date stringFromFormat:@"dd-MM-yyy"];
    }
    
}


#pragma mark - Delivery Note & Door Number Delegate

-(void)deliveryNoteAdded:(NSString *)note {
    [self checkNoteAvailability];
}

-(void)deliveryDoorNumberAdded:(NSString *)doorNumber {
    [self checkDoorNumberAvailability];
}

- (void)checkNoteAvailability {
    if ([delivery.note isEmpty] || delivery.note == nil) {
        imgViewNote.highlighted = NO;
    } else {
        imgViewNote.highlighted = YES;
    }
}

- (void)checkDoorNumberAvailability {
    if (![delivery.doorNumberTo isEmpty] && delivery.doorNumberTo != nil) {
        imgViewDoorNumber.highlighted = YES;
    } else {
        imgViewDoorNumber.highlighted = NO;
    }
    
    if (![delivery.doorNumberFrom isEmpty] && delivery.doorNumberFrom != nil) {
        imgViewDoorNumberFrom.highlighted = YES;
    } else {
        imgViewDoorNumberFrom.highlighted = NO;
    }
}


#pragma mark - Text Field Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == txtPromoCode) {
        
        for (IWadPromoCode * promoCode in promoArray) {
            if ([promoCode.code isEqualToString:txtPromoCode.text]) {
                float promoPrice = 100;
                delivery.cost = delivery.cost - promoPrice;
                lblCost.text = [NSString stringWithFormat:@"%.2f",delivery.cost];
                delivery.promoCode = promoCode.code;
                delivery.promoCodeID = [NSString stringWithFormat:@"%i",promoCode.ID];
            }
        }
        [textField resignFirstResponder];
    } else if (textField == self.nameTxt) {
        [self.emailTxt becomeFirstResponder];
    } else if (textField == self.emailTxt) {
        [self.emailTxt resignFirstResponder];
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
            self.view.transform = CGAffineTransformMakeTranslation(0, -270);
        }];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == txtPromoCode) {
        [UIView animateWithDuration:0.4 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -340);
        }];
    }
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == txtDeliveryNumber) {
        delivery.deliveryNumber = txtDeliveryNumber.text;
        [UIView animateWithDuration:0.2 animations:^{
            self.view.transform = CGAffineTransformIdentity;
        }];
    }
    if (textField == txtDeliveryContact) {
        delivery.deliveryContact = txtDeliveryContact.text;
        [UIView animateWithDuration:0.2 animations:^{
            self.view.transform = CGAffineTransformIdentity;
        }];
    }
}

#pragma mark - Delivary Location Delegate

-(void)userDidEnterLocationsFrom:(NSString *)from to:(NSString *)to delivery:(Delivery *)delivary{
    
    self.fromLbl.text = delivery.startAddress;
    self.toLbl.text = delivery.destinationAddress;
    
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
                        
                        float totalCost;
                        IWadVehicle *vehicle = delivery.vehicle;
                        if ([vehicle.vehicleType isEqualToString:VEHICLE_TYPE_VAN]) {
                            totalCost = delivery.distance * COST_PER_MILE_VAN;
                        } else if ([vehicle.vehicleType isEqualToString:VEHICLE_TYPE_CAR]) {
                            totalCost = delivery.distance * COST_PER_MILE_CAR;
                        } else if ([vehicle.vehicleType isEqualToString:VEHICLE_TYPE_BIKE]) {
                            totalCost = delivery.distance * COST_PER_MILE_BIKE;
                        }
                        
                        delivery.cost = totalCost;
                        lblCost.text = [NSString stringWithFormat:@"%.2f",totalCost];
                        
                        [self setManualCost:17.0];
                    }
                });
            } else {
                NSLog(@"ETA : no response"); // no response
            }
        });
    }
    
    
    
}

- (void)setManualCost:(double)cost {
    delivery.cost = cost;
    lblCost.text = [NSString stringWithFormat:@"%.2f",cost];
}


#pragma mark - Sync Manager Delegate

-(void)syncManagerResponseSuccessWithResponse:(NSDictionary *)response withTag:(NSInteger)tag {
    
    if (tag == 100) {
        txtPromoCode.enabled = YES;
        if ([[response valueForKey:@"success"] isEqualToString:@"true"]) {
            
            NSArray * arr = [response valueForKey:@"promocodes"];
            
            for (NSDictionary * resp in arr) {
                
                IWadPromoCode * code = [[IWadPromoCode alloc] init];
                code.code = [resp objectForKey:@"code"];
                code.codeDescription = [resp objectForKey:@"description"];
                code.startDate = [resp objectForKey:@"start_date"];
                code.ID = [[resp objectForKey:@"id"] intValue];
                code.expiryDate = [resp objectForKey:@"end_date"];
                code.price = 100;
                
                [promoArray addObject:code];
            }
        }
        
        
        
    } else if (tag == 200) {
        NSLog(@"tag 200");
    }
}


#pragma mark - Keyboard

- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardAppeared:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardAppeared:(NSNotification*)aNotification {
    //    [UIView animateWithDuration:0.4 animations:^{
    //        self.view.transform = CGAffineTransformMakeTranslation(0, -50);
    //    }];
}

-(void)keyboardDidHide:(NSNotification*)aNotification {
    [UIView animateWithDuration:0.2 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}

-(void)dismissKeyboards {
    [self.nameTxt resignFirstResponder];
    [self.emailTxt resignFirstResponder];
    [txtPromoCode resignFirstResponder];
}

@end
