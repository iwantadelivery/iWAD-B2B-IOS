//
//  NewDeliveryStep2ViewController.m
//  iWad
//
//  Created by Saman Kumara on 12/16/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "NewDeliveryStep2ViewController.h"
#import "NewDeliveryStep3ViewController.h"
#import "SelectVehicleViewController.h"

@interface NewDeliveryStep2ViewController ()<VehicleSelectDelegate>{
    
    __weak IBOutlet UILabel *lblBikeDimension;
    __weak IBOutlet UILabel *lblBikePayload;
    __weak IBOutlet UILabel *lblBikeName;
    __weak IBOutlet UILabel *lblVanDimension;
    __weak IBOutlet UILabel *lblVanPayload;
    __weak IBOutlet UILabel *lblVanName;
    __weak IBOutlet UILabel *lblCarDimension;
    __weak IBOutlet UILabel *lblCarPayload;
    __weak IBOutlet UILabel *lblCarName;
    __weak IBOutlet UILabel *lblCost;
    
    __weak IBOutlet UIButton *btnVan;
    __weak IBOutlet UIButton *btnBike;
    __weak IBOutlet UIButton *btnCar;
    
    __weak IBOutlet UIButton *btnPlus;
    __weak IBOutlet UIButton *btnMinus;
    
    __weak IBOutlet UIImageView * imgViewCar;
    __weak IBOutlet UIImageView * imgViewVan;
    __weak IBOutlet UIImageView * imgViewBike;
    IWadVehicle *vehicle;
}
@property (weak, nonatomic) IBOutlet UILabel        *countLbl;
@property (weak, nonatomic) IBOutlet UIImageView    *carBgImgView;
@property (weak, nonatomic) IBOutlet UIImageView    *vanBgImgView;
@property (weak, nonatomic) IBOutlet UIImageView    *moterBikeImgView;

@end

@implementation NewDeliveryStep2ViewController

@synthesize delivery, showDateTime;

-(void)viewWillAppear:(BOOL)animated {
    if (delivery.vehicle.vehicleID) {
        vehicle = delivery.vehicle;
        [self calculateCostForVehicle:vehicle.vehicleType];
    } else {
        lblCost.text = @"0";
        delivery.cost = 0;
        [self payloadDimensionLabelHidden:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NEW DELIVERY";
}


#pragma mark - Button Actions

- (IBAction)tapVehicleSelection:(UIButton *)sender {
    [self payloadDimensionLabelHidden:YES];
    [self resetLabelColors];
    
    if (sender.tag ==0) {
        self.carBgImgView.hidden = NO;
        lblCarDimension.textColor = [UIColor lightGrayColor];
        lblCarPayload.textColor = [UIColor lightGrayColor];
        lblCarDimension.hidden = NO;
        lblCarPayload.hidden = NO;
        lblCarName.hidden = NO;
        [self enablePeopleCountButtons:YES];
        
    }else if (sender.tag ==1) {
        self.vanBgImgView.hidden = NO;
        lblVanDimension.textColor = [UIColor lightGrayColor];
        lblVanPayload.textColor = [UIColor lightGrayColor];
        lblVanDimension.hidden = NO;
        lblVanPayload.hidden = NO;
        lblVanName.hidden = NO;
        [self enablePeopleCountButtons:YES];
        
    }else if (sender.tag ==2) {
        self.moterBikeImgView.hidden = NO;
        lblBikeDimension.textColor = [UIColor lightGrayColor];
        lblBikePayload.textColor = [UIColor lightGrayColor];
        lblBikeDimension.hidden = NO;
        lblBikePayload.hidden = NO;
        lblBikeName.hidden = NO;
        self.countLbl.text = @"1";
        [self enablePeopleCountButtons:NO];
    }
}


- (IBAction)tapCountChangeBtn:(UIButton *)sender {
    if (sender.tag ==1) {
        self.countLbl.text = [NSString stringWithFormat:@"%d", ([self.countLbl.text intValue] + 1)];
        
    }else {
        if ([self.countLbl.text isEqualToString:@"1"]) {
            return;
        }
        self.countLbl.text = [NSString stringWithFormat:@"%d", ([self.countLbl.text intValue] - 1)];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goNext"]) {
        NewDeliveryStep3ViewController *deliveryVC = [segue destinationViewController];
        delivery.noOfPeople = [self.countLbl.text integerValue];
        deliveryVC.delivery = delivery;
        deliveryVC.showDateTime = showDateTime;
        
    } if ([segue.identifier isEqualToString:@"selectVans"]) {
        SelectVehicleViewController *selectVehicleVC = [segue destinationViewController];
        delivery.vehicle = nil;
        selectVehicleVC.delivery = delivery;
        selectVehicleVC.delegate = self;
        selectVehicleVC.vehicleType = VehicleTypeVan;
    } if ([segue.identifier isEqualToString:@"selectCars"]) {
        SelectVehicleViewController *selectVehicleVC = [segue destinationViewController];
        delivery.vehicle = nil;
        selectVehicleVC.delivery = delivery;
        selectVehicleVC.delegate = self;
        selectVehicleVC.vehicleType = VehicleTypeCar;
    } if ([segue.identifier isEqualToString:@"selectBikes"]) {
        SelectVehicleViewController *selectVehicleVC = [segue destinationViewController];
        delivery.vehicle = nil;
        selectVehicleVC.delivery = delivery;
        selectVehicleVC.delegate = self;
        selectVehicleVC.vehicleType = VehicleTypeBike;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"goNext"]) {
        if (delivery.vehicle.vehicleID) {
            return YES;
        } else {
            [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:@"Please select vehicle" actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
            return NO;
        }
    }
    return YES;
}

#pragma mark - VehicleSelectDelegate

- (void)vehicleSelected:(Delivery *)deliver vehicleType:(VehicleType)type {
    if (delivery.vehicle.vehicleID) {
        [self payloadDimensionLabelHidden:YES];
        IWadVehicle *selectVehicle = delivery.vehicle;
        if (type == VehicleTypeCar) {
            lblCarDimension.hidden = NO;
            lblCarPayload.hidden = NO;
            lblCarName.hidden = NO;
            lblCarPayload.text = selectVehicle.vehiclePayload;
            lblCarDimension.text = selectVehicle.vehicleDimension;
            lblCarName.text = selectVehicle.vehicleName;
        }
        if (type == VehicleTypeVan) {
            lblVanDimension.hidden = NO;
            lblVanPayload.hidden = NO;
            lblVanName.hidden = NO;
            lblVanPayload.text = selectVehicle.vehiclePayload;
            lblVanDimension.text = selectVehicle.vehicleDimension;
            lblVanName.text = selectVehicle.vehicleName;
        }
        if (type == VehicleTypeBike) {
            lblBikeDimension.hidden = NO;
            lblBikePayload.hidden = NO;
            lblBikeName.hidden = NO;
            lblBikePayload.text = selectVehicle.vehiclePayload;
            lblBikeDimension.text = selectVehicle.vehicleDimension;
            lblBikeName.text = selectVehicle.vehicleName;
        }
    }
    
}


#pragma mark - Other Methods

- (void)calculateCostForVehicle:(NSString *)vehicleType {
    float totalCost;
    if ([vehicle.vehicleType isEqualToString:VEHICLE_TYPE_VAN]) {
        [self tapVehicleSelection:btnVan];
        totalCost = delivery.distance * COST_PER_MILE_VAN;
        
    } else if ([vehicle.vehicleType isEqualToString:VEHICLE_TYPE_CAR]) {
        [self tapVehicleSelection:btnCar];
        totalCost = delivery.distance * COST_PER_MILE_CAR;
        
    } else if ([vehicle.vehicleType isEqualToString:VEHICLE_TYPE_BIKE]) {
        [self tapVehicleSelection:btnBike];
        totalCost = delivery.distance * COST_PER_MILE_BIKE;
        
    }
    
    delivery.cost = totalCost;
    lblCost.text = [NSString stringWithFormat:@"%.2f",totalCost];
    [lblCost adjustsFontSizeToFitWidth];
    
    [self setManualCost:17.0];
}

- (void)setManualCost:(float)cost {
    delivery.cost = cost;
    lblCost.text = [NSString stringWithFormat:@"%.2f",cost];
}

- (void)resetLabelColors {
    UIColor * color = [UIColor colorWithRed:0.4745 green:0.4863 blue:0.5137 alpha:1.0];
    lblBikeDimension.textColor = color;
    lblBikePayload.textColor = color;
    lblVanDimension.textColor = color;
    lblVanPayload.textColor = color;
    lblCarDimension.textColor = color;
    lblCarPayload.textColor = color;
}

- (void)payloadDimensionLabelHidden:(BOOL)hidden {
    self.carBgImgView.hidden = YES;
    self.vanBgImgView.hidden = YES;
    self.moterBikeImgView.hidden = YES;
    lblCarDimension.hidden = hidden;
    lblCarPayload.hidden = hidden;
    lblCarName.hidden = hidden;
    lblVanDimension.hidden = hidden;
    lblVanPayload.hidden = hidden;
    lblVanName.hidden = hidden;
    lblBikeDimension.hidden = hidden;
    lblBikePayload.hidden = hidden;
    lblBikeName.hidden = hidden;
}

/**
 *  will enable or disable people count buttons. Usage ex: when the bike is selected, disable these buttons. Coz bike can only have one.
 *
 *  @param enable button enable/disable state.
 */
- (void)enablePeopleCountButtons:(BOOL)enable {
    btnMinus.enabled = enable;
    btnPlus.enabled = enable;
}


@end
