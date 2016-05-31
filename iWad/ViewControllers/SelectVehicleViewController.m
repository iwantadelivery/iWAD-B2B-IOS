//
//  SelectVehicleViewController.m
//  iWAD
//
//  Created by Himal Madhushan on 4/19/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "SelectVehicleViewController.h"
#import "VehicleCell.h"

@interface SelectVehicleViewController ()<SyncManagerDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *vehiclesArray;
    __weak IBOutlet UITableView *tblVehicles;
    __weak IBOutlet UIButton *btnDone;
    NSIndexPath *previousIndexPath, *currentIndexPath;
    NSMutableArray *vehicleArray;
}

@end

@implementation SelectVehicleViewController

@synthesize delivery, selectedVehicle, delegate = _delegate, vehicleType;

- (void)viewWillAppear:(BOOL)animated {
    vehicleArray = [NSMutableArray new];
    selectedVehicle = [[IWadVehicle alloc] init];
    if ([BaseUtilClass isConnectedToInternetInVC:self]) {
        SyncManager *syncManager = [[SyncManager alloc] initWithDelegate:self];
        [syncManager fetchVehicles];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"SELECT VEHICLE";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button Actions

- (IBAction)vehiclePicked:(UIButton *)sender {
    delivery.vehicle = selectedVehicle;
    if ([_delegate respondsToSelector:@selector(vehicleSelected:vehicleType:)]) {
        [_delegate vehicleSelected:delivery vehicleType:vehicleType];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return vehicleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VehicleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    IWadVehicle *vehicle = [vehicleArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (selectedVehicle.vehicleID == vehicle.vehicleID) {
        cell.imgViewTick.hidden = NO;
        previousIndexPath = indexPath;
    } else {
        cell.imgViewTick.hidden = YES;
    }
    //    [self setDriverImageForURL:driver.imageURL cell:cell];
    
    cell.lblVehicleName.text = vehicle.vehicleName;
    cell.lblPayload.text = vehicle.vehiclePayload;
    cell.lblDimension.text = vehicle.vehicleDimension;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    selectedVehicle = [vehicleArray objectAtIndex:indexPath.row];
    
    currentIndexPath = indexPath;
    
    VehicleCell *cell = nil;
    
    if (!previousIndexPath) {
        previousIndexPath = currentIndexPath;
    }
    
    if (previousIndexPath != currentIndexPath) {
        cell = (VehicleCell *) [tableView cellForRowAtIndexPath:previousIndexPath];
        cell.imgViewTick.transform = CGAffineTransformMakeScale(0, 0);
        
        
        cell = (VehicleCell *) [tableView cellForRowAtIndexPath:currentIndexPath];
        cell.imgViewTick.hidden = NO;
        
        cell.imgViewTick.transform = CGAffineTransformMakeScale(0, 0);
        
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            cell.imgViewTick.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
        }];
        
        previousIndexPath = currentIndexPath;
    }
    
    if (previousIndexPath == currentIndexPath) {
        cell = (VehicleCell *) [tableView cellForRowAtIndexPath:previousIndexPath];
        cell.imgViewTick.hidden = NO;
        
        cell.imgViewTick.transform = CGAffineTransformMakeScale(0, 0);
        
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            cell.imgViewTick.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
}


#pragma mark - SyncManagerDelegate

- (void)syncManagerResponseSuccessWithResponse:(NSDictionary *)response withTag:(NSInteger)tag {
    NSLog(@"fetchVehicles response : %@", response);
    NSArray *types = [response valueForKey:@"vehicleTypes"];
    for (NSDictionary *typeDic in types) {
        if (vehicleType == VehicleTypeCar) {
            if ([[typeDic valueForKey:@"id"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                NSArray *deliveryVehicles = [typeDic valueForKey:@"delivery_vehicles"];
                for (NSDictionary *vehicleDic in deliveryVehicles) {
                    [vehicleArray addObject:[self createVehicleObjects:vehicleDic type:VEHICLE_TYPE_CAR]];
                }
                
            }
            
        } else if (vehicleType == VehicleTypeVan) {
            if ([[typeDic valueForKey:@"id"] isEqualToNumber:[NSNumber numberWithInt:2]]) {
                NSArray *deliveryVehicles = [typeDic valueForKey:@"delivery_vehicles"];
                for (NSDictionary *vehicleDic in deliveryVehicles) {
                    [vehicleArray addObject:[self createVehicleObjects:vehicleDic type:VEHICLE_TYPE_VAN]];
                }
                
            }
            
        } else if (vehicleType == VehicleTypeBike) {
            if ([[typeDic valueForKey:@"id"] isEqualToNumber:[NSNumber numberWithInt:3]]) {
                NSArray *deliveryVehicles = [typeDic valueForKey:@"delivery_vehicles"];
                for (NSDictionary *vehicleDic in deliveryVehicles) {
                    [vehicleArray addObject:[self createVehicleObjects:vehicleDic type:VEHICLE_TYPE_BIKE]];
                }
                
            }
            
        }
    }
    [tblVehicles reloadData];
}

- (IWadVehicle *)createVehicleObjects:(NSDictionary *)vehicleDic type:(NSString *)type {
    IWadVehicle *vehicle = [[IWadVehicle alloc] init];
    if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[vehicleDic valueForKey:@"name"]]) {
        vehicle.vehicleName = [vehicleDic valueForKey:@"name"];
    }
    if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[vehicleDic valueForKey:@"payload"]]) {
        vehicle.vehiclePayload = [vehicleDic valueForKey:@"payload"];
    }
    if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[vehicleDic valueForKey:@"load_space"]]) {
        vehicle.vehicleDimension = [vehicleDic valueForKey:@"load_space"];
    }
    if ([[BaseUtilClass sharedInstance] responseValueIsNotNull:[vehicleDic valueForKey:@"id"]]) {
        vehicle.vehicleID = [[vehicleDic valueForKey:@"id"] intValue];
    }
    vehicle.vehicleType = type;
    return vehicle;
}
@end
