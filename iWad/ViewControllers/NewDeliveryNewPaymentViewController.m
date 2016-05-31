//
//  NewDeliveryNewPaymentTableViewController.m
//  iWad
//
//  Created by Himal Madhushan on 1/12/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "NewDeliveryNewPaymentViewController.h"
#import "CardIO.h"
#import "DatePickerViewController.h"
#import "WaitingViewController.h"
#import "CardSelectorViewController.h"
#import "IWadAlertViewController.h"

@interface NewDeliveryNewPaymentViewController () <CardIOPaymentViewControllerDelegate, DatePickerDelegate, SyncManagerDelegate, CardSelectorDelegate, AlertDelegate> {
    
    __weak IBOutlet UITextField *txtCardNumber;
    __weak IBOutlet UITextField *txtName;
    __weak IBOutlet UITextField *txtCVCNo;
    __weak IBOutlet UITextField *txtExpiryDate;
    __weak IBOutlet UIImageView * imgViewCard;
    __weak IBOutlet UILabel *lblRemainingDeliveries;
    __weak IBOutlet UIImageView *imgViewScannedCard;
    __weak IBOutlet UIButton * btnAddCard;
    __weak IBOutlet UIButton * btnPrepaid;
    __weak IBOutlet UIButton * btnProcess;
    __weak IBOutlet UIButton *btnScanCard;
    
    UIView * yellowView;
    IWadAlertViewController *alertVC;
    STPCardParams * card;
    STPCardBrand cardType;
    PaymentCellType cellType;
    NSString * promoCodeID;
    SyncManager * syncManager;
    NSInteger prepaidCount;
}

@end

@implementation NewDeliveryNewPaymentViewController

@synthesize delivery;

-(void)viewWillAppear:(BOOL)animated {
    [self tabTapped:btnAddCard];
    self.title = @"SELECT PAYMENT METHOD";
    
    syncManager = [[SyncManager alloc] initWithDelegate:self];
    [syncManager fetchUserDetailsInView:[BaseUtilClass superView]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    card = [[STPCardParams alloc] init];
    [self registerForKeyboardNotifications];
    lblRemainingDeliveries.adjustsFontSizeToFitWidth = YES;
    imgViewScannedCard.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    if (alertVC) {
        [self removeAlertView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Actions

-(IBAction)tabTapped:(UIButton *)sender {
    [self removeYellowLine];
    [self addYellowLineForButton:sender];
    [self resetButtons];
    sender.selected = YES;
    if (sender.tag == 0) {
        cellType = PaymentCellTypeCredit;
        
    } else if (sender.tag == 1) {
        cellType = PaymentCellTypePrepaid;
    }
    
    [self.tableView reloadData];
}

-(void)removeYellowLine {
    [yellowView removeFromSuperview];
}

-(void)addYellowLineForButton:(UIButton *)button {
    yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, button.frame.size.height - 5, button.frame.size.width, 5)];
    yellowView.backgroundColor = IWAD_TEXT_COLOR;
    [button addSubview:yellowView];
}

-(void)resetButtons {
    btnAddCard.selected = NO;
    btnPrepaid.selected = NO;
}

- (IBAction)scanCard:(UIButton *)sender {
    NSDictionary *batItemAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                       IWAD_TEXT_COLOR,NSForegroundColorAttributeName,
                                       nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:batItemAttributes
                                                forState:UIControlStateNormal];
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    [self presentViewController:scanViewController animated:YES completion:nil];
}

- (IBAction)processPayment:(UIButton *)sender {
    /**
     *  Will go inside if the internet is available
     */
    if ([BaseUtilClass isConnectedToInternetInVC:self]) {
        if (cellType == PaymentCellTypeCredit) {
            
            if (delivery.name == nil || delivery.email == nil || delivery.startAddress == nil || delivery.destinationAddress == nil || delivery.delivaryDate == nil ) {
                [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:@"Missing detials to complete the delivery. Please go back and check what is missing." actionTitle:@"OK"];
                return;
            }
            
            /**
             *  checking card number null state and validation
             */
            if ([txtCardNumber.text isEmpty]) {
                [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:@"Missing details. Please enter your card number." actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
                return;
            } else {
                STPCardValidationState cardNoValidStatus = [STPCardValidator validationStateForNumber:card.number validatingCardBrand:YES];
                if (cardNoValidStatus == STPCardValidationStateInvalid) {
                    [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:@"Invalid card number. Enter correct card number." actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
                    return;
                }
            }
            
            /**
             *  checking CVC number null state and validation
             */
            if ([txtCVCNo.text isEmpty]) {
                [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:@"Missing details. Please enter your CVC number." actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
                return;
            } else {
                STPCardValidationState cvcValidStatus = [STPCardValidator validationStateForCVC:card.cvc cardBrand:STPCardBrandUnknown];
                if (cvcValidStatus == STPCardValidationStateInvalid) {
                    [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:@"Invalid security code. Enter correct CVC number." actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
                    return;
                }
            }
            
            
            if ([txtExpiryDate.text isEmpty]) {
                [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:@"Missing details. Please set expiration month and year." actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
                return;
            } else {
                NSString * year = [NSString stringWithFormat:@"%lu",(unsigned long)card.expYear];
                NSString * month = [NSString stringWithFormat:@"%lu",(unsigned long)card.expYear];
                STPCardValidationState expiryValidStatus = [STPCardValidator validationStateForExpirationYear:year inMonth:month];
                if (expiryValidStatus == STPCardValidationStateInvalid) {
                    
                    [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:@"Invalid expiry date. Enter correct expiry date." actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
                    return;
                }
            }
            
            if ([txtName.text isEmpty]) {
                [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:@"Missing details. Please enter card holder's name." actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
                return;
            }
            
            
            
            card.name = txtName.text;
            card.number = txtCardNumber.text;
            card.cvc = txtCVCNo.text;
            
            btnProcess.enabled = NO;
            [self showConfirmationAlert];
            
        } else if (cellType == PaymentCellTypePrepaid ) {
            btnProcess.enabled = NO;
            [self showConfirmationAlert];
        }
        
    }
}

-(void)showConfirmationAlert {
    alertVC = [[IWadAlertViewController alloc] initWithNibName:@"IWadAlertViewController" bundle:nil];
    alertVC.delegate = self;
    [self.navigationController addChildViewController:alertVC];
    [self.navigationController.view addSubview:alertVC.view];
}


#pragma mark - AlertDelegate

-(void)alertView:(IWadAlertViewController *)alertView didAccept:(BOOL)accept {
    
    if (accept) {
        if (!delivery.promoCodeID) {
            promoCodeID = @"0";
        }
        
        if (cellType == PaymentCellTypeCredit) {
            
            [[STPAPIClient sharedClient] createTokenWithCard:card completion:^(STPToken * _Nullable token, NSError * _Nullable error) {
                NSLog(@"token : %@ , error : %@",token.tokenId,error.userInfo);
                if (!error) {
                    [self sendTokenToServer:token];
                    btnProcess.enabled = YES;
                } else {
                    [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:[NSString stringWithFormat:@"%@",error.localizedDescription] actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
                }
                
            }];
            
        } else {
            [self sendTokenToServer:nil];
        }
        
    }
    btnProcess.enabled = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        alertVC.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeAlertView];
    }];
    
    
    
}

-(void)removeAlertView {
    [alertVC willMoveToParentViewController:nil];
    [alertVC.view removeFromSuperview];
    [alertVC removeFromParentViewController];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *creditCell     = [tableView dequeueReusableCellWithIdentifier:@"credit"];
    UITableViewCell *prepaidCell    = [tableView dequeueReusableCellWithIdentifier:@"prepaid"];
    UITableViewCell *cell           = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSInteger height;
    
    if ([cell.reuseIdentifier isEqualToString:@"tab"]) {
        height = 60;
        return height;
    }
    
    if (cellType == PaymentCellTypeCredit) {
        if ([cell.reuseIdentifier isEqualToString:@"prepaid"]) {
            prepaidCell.hidden = YES;
            return 0;
        } else {
            height = 443;
            return height;
        }
    } else if (cellType == PaymentCellTypePrepaid) {
        if ([cell.reuseIdentifier isEqualToString:@"credit"]) {
            creditCell.hidden = YES;
            return 0;
        } else {
            height = 443;
            return height;
        }
    } else {
        height = 0;
        return height;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - CardIO / Scanner Delegate
- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    NSLog(@"User canceled payment info");
    [self setNavigationBarTintClear];
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    // The full card number is available as info.cardNumber, but don't log that!
    [self setNavigationBarTintClear];
    NSLog(@"Received card info. Number: %@, expiry: %02lu/%lu, cvv: %@.", info.cardNumber, (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear, info.cvv);
    if ([self checkAllCardDetailsEntered]) {
        [self animateScanCardSection];
    }
    // Use the card info...
    txtName.text = info.cardholderName;
    txtCardNumber.text = info.cardNumber;
    txtCVCNo.text = info.cvv;
    txtExpiryDate.text = [NSString stringWithFormat:@"%li/%li",(unsigned long)info.expiryMonth,(unsigned long)info.expiryYear];
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
    
    
}


#pragma mark - Text Field Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == txtCardNumber) {
        [txtName becomeFirstResponder];
    } else if (textField == txtName) {
        [txtCVCNo becomeFirstResponder];
    } else if (textField == txtCVCNo) {
        [txtCVCNo resignFirstResponder];
        [self processPayment:btnProcess];
    }
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == txtName || textField == txtCardNumber) {
        [UIView animateWithDuration:0.4 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -170);
        }];
    } else if (textField == txtCVCNo) {
        [UIView animateWithDuration:0.4 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, -280);
        }];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == txtName || textField == txtCVCNo || textField == txtCardNumber || textField == txtExpiryDate) {
        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
//        if (newText.length == 0) {
//            [self resetAnimateScanCardSection];
//
//        } else {
            if (textField == txtCardNumber) {
                NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
                if (newText.length < 16) {
                    [self resetAnimateScanCardSection];
                    return YES;
                    
                } else {
                    
                    if (newText.length >= 16) {
                        [txtName becomeFirstResponder];
                        return NO;
                        
                    }
                }
            }
        
//        }
    }
    
    if (textField == txtCVCNo) {
        NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (newText.length < 3) {
            [self resetAnimateScanCardSection];
            return YES;
            
        } else {
            if (newText.length >= 3) {
                if (![txtExpiryDate.text isEmpty]) {
                    [self animateScanCardSection];
                    return NO;
                }
                
            }
        }
        
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (textField == txtName || textField == txtCVCNo || textField == txtCardNumber || textField == txtExpiryDate) {
        NSString *newText = textField.text;
        
        if (newText.length == 0) {
            [self resetAnimateScanCardSection];
            
        } else {
            if (textField == txtCardNumber) {
                if (newText.length < 16) {
                    [self resetAnimateScanCardSection];
                    
                } else {
                    if (textField == txtCVCNo) {
                        if (newText.length < 3) {
                            [self resetAnimateScanCardSection];
                            
                        }
                    }
                }
            }
            [self animateScanCardSection];
        }
    }
    return YES;
}


#pragma mark - IWAD Date Picker Delegate

-(void)datePicker:(UIDatePicker *)datepicker didPickDate:(NSDate *)date type:(DatePickerType)type{
    NSLog(@"%@",date);
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    
    [dateFormatter setDateFormat:@"MM"];
    NSString * day = [dateFormatter stringFromDate:date];
    
    [dateFormatter setDateFormat:@"yy"];
    NSString * year = [dateFormatter stringFromDate:date];
    
    txtExpiryDate.text = [day stringByAppendingFormat:@"/%@",year];
    
    card.expMonth = day.intValue;
    card.expYear = year.intValue;
    
    if ([self checkAllCardDetailsEntered]) {
        [self animateScanCardSection];
    }
}


#pragma mark - Sync Manager Delegate

-(void)syncManagerResponseSuccessWithResponse:(NSDictionary *)response withTag:(NSInteger)tag {
    
    if (tag == 200) {
        NSLog(@"tag 200");
        if ([[response valueForKey:@"status"] isEqualToString:@"500"]) {
//            NSArray * messageArray = [response objectForKey:@"error"];
//            NSString * message = [NSString string];
//            message = [messageArray componentsJoinedByString:@" ,"];
            [BaseUtilClass showAlertViewInViewController:self title:@"Error!" message:[response objectForKey:@"error"] actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
            return;
        } else if ([[response valueForKey:@"success"] isEqualToString:@"true"]) {
            [self.navigationController popToRootViewControllerAnimated:NO];
            [BaseUtilClass showAlertViewInViewController:self title:@"Success!" message:@"Your delivery request has been placed successfully." actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
        }
        
    } else if (tag == 105) {
        NSDictionary *user = [response valueForKey:@"user"];
        prepaidCount = [[user valueForKey:@"prepaid_credit_count"] intValue];
        if (prepaidCount == 0) {
//            btnPrepaid.enabled = NO;
            [self tabTapped:btnAddCard];
        } else {
//            btnAddCard.enabled = NO;
            [self tabTapped:btnPrepaid];
            lblRemainingDeliveries.text = [NSString stringWithFormat:@"%li",(long)prepaidCount];
        }
    }
    btnProcess.enabled = YES;
    
}


#pragma mark - CardSelectorDelegate

-(void)cardSelectorDidPickStrpieCardType:(STPCardBrand)strpieCardType {
    cardType = strpieCardType;
    
    switch (strpieCardType) {
        case STPCardBrandVisa: {
            imgViewCard.image = [UIImage imageNamed:@"visa"];
            break;
        }
        case STPCardBrandAmex: {
            imgViewCard.image = [UIImage imageNamed:@"amex"];
            break;
        }
        case STPCardBrandMasterCard: {
            imgViewCard.image = [UIImage imageNamed:@"master"];
            break;
        }
        case STPCardBrandDiscover: {
            imgViewCard.image = [UIImage imageNamed:@"discover"];
            break;
        }
        case STPCardBrandJCB: {
            imgViewCard.image = [UIImage imageNamed:@"jcb"];
            break;
        }
        case STPCardBrandDinersClub: {
            imgViewCard.image = [UIImage imageNamed:@"diners"];
            break;
        }
        case STPCardBrandUnknown: {
            break;
        }
    }
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"datePickerSegue"]) {
        DatePickerViewController * dp = [segue destinationViewController];
        dp.delegate = self;
        [BaseUtilClass setPopOverArrowColorForViewController:dp];
        
    } else if ([segue.identifier  isEqual: @"cardSelector"]) {
        CardSelectorViewController * dp = [segue destinationViewController];
        dp.delegate = self;
        [BaseUtilClass setPopOverArrowColorForViewController:dp];
    }
}


#pragma mark - Keyboard

- (void)registerForKeyboardNotifications{
    
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
    [UIView animateWithDuration:0.3 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}


#pragma mark - Other Methods

-(void)sendTokenToServer:(STPToken *)token {
    
    NSString *driverID;
    if (delivery.driver) {
        IWadDriver *driver = delivery.driver;
        driverID = driver.driverID;
    } else {
        driverID = @"0";
    }
    if (!delivery.note) {
        delivery.note = @" ";
    }
    if (!delivery.doorNumberFrom) {
        delivery.doorNumberFrom = @" ";
    }
    if (!delivery.doorNumberTo) {
        delivery.doorNumberTo = @" ";
    }
    if (!delivery.deliveryContact) {
        delivery.deliveryContact = @" ";
    }
    if (!delivery.deliveryNumber) {
        delivery.deliveryNumber = @" ";
    }
    IWadVehicle *vehicle = delivery.vehicle;
    NSDictionary *param = @{@"delivery[name]":delivery.name,
                            @"delivery[email]":delivery.email,
                            @"delivery[from_location]":delivery.startAddress,
                            @"delivery[to_location]":delivery.destinationAddress,
                            @"delivery[delivery_date]":[delivery.delivaryDate stringByAppendingFormat:@" %@",delivery.delivaryTime],
                            @"delivery[promocode_id]":promoCodeID,
                            @"delivery[no_of_people]":[NSString stringWithFormat:@"%li",(long)delivery.noOfPeople],
                            @"delivery[from_lat]":[NSString stringWithFormat:@"%f",delivery.startCoord.latitude],
                            @"delivery[from_lon]":[NSString stringWithFormat:@"%f",delivery.startCoord.longitude],
                            @"delivery[to_lat]":[NSString stringWithFormat:@"%f",delivery.destinationCoord.latitude],
                            @"delivery[to_lon]":[NSString stringWithFormat:@"%f",delivery.destinationCoord.longitude],
                            @"delivery[delivery_vehicle_id]":[NSString stringWithFormat:@"%li",(long)vehicle.vehicleID],
                            @"delivery[cost]":[NSString stringWithFormat:@"%.2f",delivery.cost],
                            @"delivery[note]":delivery.note,
                            @"delivery[driver_id]":driverID,
                            @"delivery[from_door_number]":delivery.doorNumberFrom,
                            @"delivery[to_door_number]":delivery.doorNumberTo,
                            @"delivery[delivery_contact]":delivery.deliveryContact,
                            @"delivery[delivery_number]":delivery.deliveryNumber};
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] initWithDictionary:param];
    if (cellType == PaymentCellTypeCredit) {
        [parameters setObject:token.tokenId forKey:@"token"];
    }
    
    [syncManager createDelivery:parameters token:token.tokenId parentView:[BaseUtilClass superView]];
//    @"delivery[cost]":[NSString stringWithFormat:@"%.2f",delivery.cost
}

-(void)setNavigationBarTintClear {
    NSDictionary *batItemAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIColor clearColor],NSForegroundColorAttributeName,
                                       nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:batItemAttributes
                                                forState:UIControlStateNormal];
}

- (void) animateScanCardSection {
    imgViewScannedCard.hidden = NO;
    imgViewScannedCard.alpha = 0;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        imgViewScannedCard.alpha = 1;
        btnScanCard.transform = CGAffineTransformMakeTranslation(0, 100);
    } completion:^(BOOL finished) {
        
    }];
}

- (void) resetAnimateScanCardSection {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        btnScanCard.transform = CGAffineTransformIdentity;
        imgViewScannedCard.alpha = 0;
    } completion:^(BOOL finished) {
        imgViewScannedCard.hidden = YES;
    }];
}

- (BOOL)checkAllCardDetailsEntered {
    if ([txtExpiryDate.text isEmpty] || [txtCVCNo.text isEmpty] || [txtCardNumber.text isEmpty]) {
        return NO;
    } else {
        return YES;
    }
}

@end
