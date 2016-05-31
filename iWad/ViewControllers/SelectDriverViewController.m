//
//  AvailableDriversViewController.m
//  iWAD
//
//  Created by Himal Madhushan on 2/11/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "SelectDriverViewController.h"
#import "DriverCell.h"
#import "AnimatedClockView.h"

@interface SelectDriverViewController () <UITableViewDataSource, UITableViewDelegate, SyncManagerDelegate> {
    IBOutlet UITableView *tblDrivers;
    IBOutlet UILabel *lblETA;
    NSIndexPath *previousIndexPath, *currentIndexPath;
    NSMutableArray *driversArr;
    
    SyncManager *sm;
    UIRefreshControl *refreshControl;
    dispatch_queue_t directionsQueue;
}

@end

@implementation SelectDriverViewController

@synthesize delegate = _delegate, selectedDriver, delivery;

- (void)viewDidLoad
{
    [super viewDidLoad];
    driversArr = [NSMutableArray new];
    sm = [[SyncManager alloc] initWithDelegate:self];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = IWAD_TEXT_COLOR;
    [refreshControl addTarget:self action:@selector(fetchDrivers) forControlEvents:UIControlEventValueChanged];
    [tblDrivers addSubview:refreshControl];
    self.title = @"SELECT THE PREFERRED DRIVER";
    directionsQueue = dispatch_queue_create("directionsQueue", NULL);
}

-(void)viewWillAppear:(BOOL)animated {
//    selectedDriver = nil;
    [self fetchDrivers];
    previousIndexPath = nil;
    currentIndexPath = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)done:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(driverSelected:)]) {
        [_delegate driverSelected:selectedDriver];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return driversArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DriverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    IWadDriver *driver = [driversArr objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([selectedDriver.driverID isEqualToString:driver.driverID]) {
        cell.imgViewTick.hidden = NO;
        previousIndexPath = indexPath;
    } else {
        cell.imgViewTick.hidden = YES;
    }
    [cell.imgViewPhoto loadWithURLString:driver.imageURL loadFromCacheFirst:YES complete:^(UIImage *image) {
        if (!image) {
            cell.imgViewPhoto.image = [UIImage imageNamed:@"userProfDefaultPic"];
        }
    }];
//    [self setDriverImageForURL:driver.imageURL cell:cell];
    
    cell.lblDriverName.text = [NSString stringWithFormat:@"(ID: %@) %@",driver.driverID, driver.name];
    cell.lblPhoneNumber.text = driver.mobile;
    if (delivery.startAddress) {
        [self calculateETA:driver.coordinates cell:cell];
    } else
        cell.lblETA.text = @" ";
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    selectedDriver = [driversArr objectAtIndex:indexPath.row];
    
    currentIndexPath = indexPath;
    
    DriverCell *cell = nil;
    
    if (!previousIndexPath) {
        previousIndexPath = currentIndexPath;
    }
    
    if (previousIndexPath != currentIndexPath) {
        cell = (DriverCell *) [tableView cellForRowAtIndexPath:previousIndexPath];
        cell.imgViewTick.transform = CGAffineTransformMakeScale(0, 0);
        
        
        cell = (DriverCell *) [tableView cellForRowAtIndexPath:currentIndexPath];
        cell.imgViewTick.hidden = NO;
        
        cell.imgViewTick.transform = CGAffineTransformMakeScale(0, 0);
        
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            cell.imgViewTick.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
        }];
        
        previousIndexPath = currentIndexPath;
    }
    
    if (previousIndexPath == currentIndexPath) {
        cell = (DriverCell *) [tableView cellForRowAtIndexPath:previousIndexPath];
        cell.imgViewTick.hidden = NO;
        
        cell.imgViewTick.transform = CGAffineTransformMakeScale(0, 0);
        
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            cell.imgViewTick.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
}


#pragma mark - SyncManager Delegate

-(void)syncManagerResponseSuccessWithResponse:(NSDictionary *)response withTag:(NSInteger)tag {
    [refreshControl endRefreshing];
    if ([[response valueForKey:@"success"] isEqualToString:@"true"]) {
        [driversArr removeAllObjects];
        NSArray *drivers = [response valueForKey:@"drivers"];
        for (NSDictionary *resp in drivers) {
            
            NSDictionary *driverDic = [resp valueForKey:@"driver"];
            NSString *name = [NSString stringWithFormat:@"%@ %@",[driverDic valueForKey:@"first_name"], [driverDic valueForKey:@"surname"]];
            
            IWadDriver *driver = [[IWadDriver alloc] init];
            driver.driverID = [NSString stringWithFormat:@"%@",[resp valueForKey:@"driver_id"]];
            float lat = [[resp valueForKey:@"lat"] floatValue];
            float lon = [[resp valueForKey:@"lon"] floatValue];
            driver.coordinates = CLLocationCoordinate2DMake(lat, lon);
            driver.name = name;
            driver.mobile = [driverDic valueForKey:@"mobile_no"];
            driver.imageURL = [NSString stringWithFormat:@"%@%@",BASE_IMAGE_URL, [driverDic valueForKey:@"avatar_url"]];
            [driversArr addObject:driver];
        }
        [tblDrivers reloadData];
    }
    
}


#pragma mark - Other Methods

-(void)fetchDrivers {
    [tblDrivers reloadData];
    if ([BaseUtilClass isConnectedToInternetInVC:self]) {
        [refreshControl beginRefreshing];
        [sm fetchAvailableDriversInView:[BaseUtilClass superView]];
    }
}

-(void)calcell:(UITableViewCell *)cell {
    
}

-(void)setDriverImageForURL:(NSString *)imgURL cell:(DriverCell *)cell {
    dispatch_queue_t driverImageQueue = dispatch_queue_create("driverImageQueue", NULL);
    dispatch_async(driverImageQueue, ^{
    NSError *error;
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL] options:NSDataReadingUncached error:&error];
        if (imgData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imgViewPhoto.image = [UIImage imageWithData:imgData];
                cell.imgViewPhoto.alpha = 0;
                [UIView animateWithDuration:0.3 animations:^{
                    cell.imgViewPhoto.alpha = 1;
                }];
            });
        } else
            cell.imgViewPhoto.image = [UIImage imageNamed:@"userProfDefaultPic"];
        
    });
}

-(void)calculateETA:(CLLocationCoordinate2D)driverCoordinates cell:(DriverCell *)cell {
    
//    AnimatedClockView *clock = [[AnimatedClockView alloc] init];
//    [clock showInView:cell.viewClock];
    
    dispatch_async(directionsQueue, ^{
        NSString *strUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&mode=%@", driverCoordinates.latitude,  driverCoordinates.longitude, delivery.startCoord.latitude,  delivery.startCoord.longitude, @"driving"];
        NSURL *url = [NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSData *jsonData = [NSData dataWithContentsOfURL:url];
        if(jsonData != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = nil;
                id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
                NSMutableArray *arrDistance = [result objectForKey:@"routes"];
                if ([arrDistance count] == 0) {
//                    NSLog(@"ETA : no available ETA"); // no available ETA
                    cell.lblETA.text = IWAD_ERROR_NOT_APPLICABLE;
                    cell.lblDistance.text = IWAD_ERROR_NOT_APPLICABLE;
                } else {
                    NSMutableArray *arrLeg = [[arrDistance objectAtIndex:0]objectForKey:@"legs"];
                    NSMutableDictionary *dictleg = [arrLeg objectAtIndex:0];
                    NSString *eta = [NSString stringWithFormat:@"%@",[[dictleg   objectForKey:@"duration"] objectForKey:@"text"]];
                    cell.lblETA.text = eta;
                    
                    NSString *distanceStr = [NSString stringWithFormat:@"%@",[[dictleg   objectForKey:@"distance"] objectForKey:@"text"]];
                    NSArray *dis = [distanceStr componentsSeparatedByString:@"k"];
                    float distance = [[NSString stringWithFormat:@"%@",[dis objectAtIndex:0]] floatValue] * 0.621371;
                    cell.lblDistance.text = [NSString stringWithFormat:@"%.2f Miles",distance];
                }
            });
        } else {
//            NSLog(@"ETA : no response"); // no response
        }
    });
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
//    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld Hours : %02ld Minutes", (long)hours, (long)minutes];
}

@end
