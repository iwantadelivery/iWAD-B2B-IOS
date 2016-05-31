//
//  DeliveriesViewController.m
//  iWad
//
//  Created by Saman Kumara on 12/15/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "DeliveriesViewController.h"
#import "NewDeliveryStep1ViewController.h"
#import "NormalDeliveriesCell.h"
#import "TimedDeliveriesCell.h"
#import "NSDate+Category.h"
#import "Driver.h"
#import "UIImageView+SWNetworking.h"
#import "DeliveryDetailMainViewController.h"
#import "IWadAlertViewController.h"
#import "NoContentViewController.h"
#import "ViewNoteViewController.h"
#import "LocationPopupViewController.h"

@interface DeliveriesViewController () <SyncManagerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, NormalCellDelegate, TimedCellDelegate, NoContentDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITextFieldDelegate> {
    
    IBOutlet UITableView *tblDeliveries;
    __weak IBOutlet UISearchBar *searchBar;
    UIRefreshControl *refreshControl;
    SyncManager * syncManager;
    NoContentViewController *noContentVC;
    NSFetchRequest *fetchRequest;
    float offsetY;
}

@end

@implementation DeliveriesViewController

@synthesize fetchedResultsController = _fetchedResultsController;

-(void)viewWillAppear:(BOOL)animated {
    self.title = @"YOUR DELIVERIES";
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [self fetchDeliveries];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Happy new year..! I Love iOS... <3");
    searchBar.delegate = self;
    fetchRequest = [[NSFetchRequest alloc] init];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = IWAD_TEXT_COLOR;
    [refreshControl addTarget:self action:@selector(fetchDeliveries) forControlEvents:UIControlEventValueChanged];
    [tblDeliveries addSubview:refreshControl];
    
    noContentVC = [[NoContentViewController alloc] initWithNibName:@"NoContentViewController" bundle:nil];
    noContentVC.delegate = self;
    CGRect waitFrame = noContentVC.view.frame;
    waitFrame = [BaseUtilClass superView].frame;
    waitFrame.origin.x -= 129;
    waitFrame.origin.y -= 64;
    noContentVC.view.frame = waitFrame;
}


-(void)viewWillDisappear:(BOOL)animated {
    [searchBar resignFirstResponder];
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id secInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    NSInteger count = [secInfo numberOfObjects];
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 222;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Deliveries * delivery;
    
    NormalDeliveriesCell *normalCell;
    TimedDeliveriesCell *timedCell;
    
    delivery = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([delivery.deliveryDate isEqualToString:kNO_DATE] || [delivery.deliveryDate isEqualToString:kNO_TIME]) {
        
        normalCell = [tableView dequeueReusableCellWithIdentifier:@"normalCell" forIndexPath:indexPath];
        if (!normalCell) {
            normalCell = (NormalDeliveriesCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"normalCell"];
        }
        normalCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureNormalCell:normalCell atIndexPath:indexPath delivery:delivery];
        normalCell.delivery = delivery;
        normalCell.delegate = self;
        return normalCell;
        
    } else {
        timedCell = [tableView dequeueReusableCellWithIdentifier:@"timedCell" forIndexPath:indexPath];
        if (!timedCell) {
            timedCell = (TimedDeliveriesCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timedCell"];
        }
        timedCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureTimedCell:timedCell atIndexPath:indexPath delivery:delivery];
        timedCell.delivery = delivery;
        timedCell.delegate = self;
        return timedCell;
    }
    
    
}

-(void)configureNormalCell:(NormalDeliveriesCell *)normalCell atIndexPath:(NSIndexPath *)indexPath delivery:(Deliveries *)delivery {
    
    normalCell.lblCost.text = [NSString stringWithFormat:@"%@",delivery.cost];
    normalCell.lblCost.adjustsFontSizeToFitWidth = YES;
    
//    normalCell.lblFrom.text = delivery.fromAddress;
    normalCell.lblNoOfPeople.text = [NSString stringWithFormat:@"%@",delivery.peopleCount];
    
    if (![delivery.doorNumberTo isEmpty] && delivery.doorNumberTo != nil) {
        normalCell.lblTo.text = [NSString stringWithFormat:@"%@, %@",delivery.doorNumberTo,delivery.toAddress];
    } else {
        normalCell.lblTo.text = delivery.toAddress;
    }
    
    if (![delivery.doorNumberFrom isEmpty] && delivery.doorNumberFrom != nil) {
        normalCell.lblFrom.text = [NSString stringWithFormat:@"%@, %@",delivery.doorNumberFrom,delivery.fromAddress];
    } else {
        normalCell.lblFrom.text = delivery.fromAddress;
    }
    
    normalCell.lblClient.text = delivery.name;
    normalCell.lblPhone.text = delivery.email;
    normalCell.lblOrderID.text = [NSString stringWithFormat:@"%@",delivery.deliveryID];
    
    if ([delivery.note isEmpty]) {
        normalCell.viewNote.hidden = YES;
    }
    
    normalCell.lblOrderDate.text = [self formatDeliveryDate:delivery.createdDate];
    normalCell.lblOrderTime.text = [self formatDeliveryTime:delivery.createdDate];
    
    Driver *driver = delivery.driverRS;
    if (driver != nil) {
        normalCell.lblName.text = [NSString stringWithFormat:@"(ID: %@) %@ %@",driver.driverID, driver.fName, driver.surName];
        [normalCell.imgViewUserPic loadWithURLString:driver.photoURL loadFromCacheFirst:YES complete:^(UIImage *image) {
            if (!image) {
                normalCell.imgViewUserPic.image = [UIImage imageNamed:@"userProfDefaultPic"];
            }
        }];
    } else {
        normalCell.lblName.text = nil;
        normalCell.imgViewUserPic.image = [UIImage imageNamed:@"userProfDefaultPic"];
    }
    
    if ([delivery.vehicleID isEqualToNumber:[NSNumber numberWithInt:1]]) {
        normalCell.imgViewVehicle.image = [UIImage imageNamed:@"deliveriesNewDeliveryCarInactiveIcon"];
    } else if ([delivery.vehicleID isEqualToNumber:[NSNumber numberWithInt:2]]) {
        normalCell.imgViewVehicle.image = [UIImage imageNamed:@"deliveriesNewDeliveryVanInactiveIcon"];
    } else if ([delivery.vehicleID isEqualToNumber:[NSNumber numberWithInt:3]]) {
        normalCell.imgViewVehicle.image = [UIImage imageNamed:@"deliveriesNewDeliveryBikeInactiveIcon"];
    }
    
    /**
     *  updating status indicators
     */
    if ([delivery.status isEqualToNumber:[NSNumber numberWithInt:1]]) { // WaitingForAccept
        
        normalCell.imgViewLine1.highlighted = NO;                       // 1st line image
        
        if ([delivery.isManuel isEqualToNumber:[NSNumber numberWithInt:0]]) {
            
            normalCell.imgViewStatus0.highlighted = NO;                     // 1st image view
            normalCell.lblAllocated.textColor = IWAD_TEXT_COLOR;            // delivery placed but driver is not allocated. so color is grey.
            normalCell.lblAllocated.text = DELIVERY_AWAITING_FOR_DRIVER;    // lbl color is grey. set text to show that waiting for a driver.
            
        } else if ([delivery.isManuel isEqualToNumber:[NSNumber numberWithInt:1]]){
            
            normalCell.imgViewStatus0.highlighted = YES;                    // 1st image view should be green. so highlight.
            normalCell.lblAllocated.textColor = DELIVERIES_TXTCOLOR_GREEN;  // delivery placed but driver is not allocated. so color is grey.
            normalCell.lblAllocated.text = DELIVERY_DRIVER_ALLOCATED;       // lbl color is grey. set text to show that waiting for a driver.
            
        }
        
        normalCell.imgViewStatus1.highlighted = NO;
        normalCell.imgViewLine2.highlighted = NO;
        normalCell.imgViewStatus2.highlighted = NO;
        normalCell.imgViewLine3.highlighted = NO;
        normalCell.imgViewStatus3.highlighted = NO;
        
        // other lables' color should be grey. coz this is first stage
        normalCell.lblPicked.textColor = DELIVERIES_TXTCOLOR_GREY;
        normalCell.lblDelivered.textColor = DELIVERIES_TXTCOLOR_GREY;
        normalCell.lblEnRoute.textColor = DELIVERIES_TXTCOLOR_GREY;
        
    }
    if ([delivery.status isEqualToNumber:[NSNumber numberWithInt:2]]) { // EnRouteToPickUp - driver allocated and is going to pick up the package.
        
        // status 1
        normalCell.imgViewLine1.highlighted = YES;                      // 1st line image should be green. so highlight.
//        if ([delivery.isManuel isEqualToNumber:[NSNumber numberWithInt:0]]) {
//            
//            normalCell.imgViewStatus0.highlighted = NO;                     // 1st image view
//            normalCell.lblAllocated.textColor = IWAD_TEXT_COLOR;            // delivery placed but driver is not allocated. so color is grey.
//            normalCell.lblAllocated.text = DELIVERY_AWAITING_FOR_DRIVER;    // lbl color is grey. set text to show that waiting for a driver.
        
//        } else if ([delivery.isManuel isEqualToNumber:[NSNumber numberWithInt:1]]){
            
            normalCell.imgViewStatus0.highlighted = YES;                    // 1st image view should be green. so highlight.
            normalCell.lblAllocated.textColor = DELIVERIES_TXTCOLOR_GREEN;  // delivery placed but driver is not allocated. so color is grey.
            normalCell.lblAllocated.text = DELIVERY_DRIVER_ALLOCATED;       // lbl color is grey. set text to show that waiting for a driver.
            
//        }
        
        normalCell.imgViewStatus1.highlighted = NO;
        normalCell.imgViewLine2.highlighted = NO;
        normalCell.imgViewStatus2.highlighted = NO;
        normalCell.imgViewLine3.highlighted = NO;
        normalCell.imgViewStatus3.highlighted = NO;
        
        // other lables' color should be grey. coz this is first stage
        normalCell.lblPicked.textColor = DELIVERIES_TXTCOLOR_GREY;
        normalCell.lblDelivered.textColor = DELIVERIES_TXTCOLOR_GREY;
        normalCell.lblEnRoute.textColor = DELIVERIES_TXTCOLOR_GREY;
        
    } else if ([delivery.status isEqualToNumber:[NSNumber numberWithInt:3]]) { //PickedUp - package was picked up.
        
        // status 1
        normalCell.imgViewStatus0.highlighted = YES;                    // 1st image view should be green. so highlight.
        normalCell.imgViewLine1.highlighted = YES;                      // 1st line image should be green. so highlight.
        normalCell.lblAllocated.textColor = DELIVERIES_TXTCOLOR_GREEN;  // stage 2, driver is allocated. first label color should be green.
        normalCell.lblAllocated.text = DELIVERY_DRIVER_ALLOCATED;       // change first label text to "delivery placed"
        
        // status 2
        normalCell.imgViewStatus1.highlighted = YES;                    // 2nd image view. driver allocated. green, highlight.
        normalCell.imgViewLine2.highlighted = YES;                      // 2nd line image. green. highlight.
        normalCell.lblPicked.textColor = DELIVERIES_TXTCOLOR_GREEN;     // 2nd label, driver allocated, green.
        
        normalCell.lblDelivered.textColor = DELIVERIES_TXTCOLOR_GREY;   // other lables' color should be grey. coz this is first stage
        normalCell.lblEnRoute.textColor = DELIVERIES_TXTCOLOR_GREY;
        
    } else if ([delivery.status isEqualToNumber:[NSNumber numberWithInt:4]]) { //EnRouteToDelivery - package picked up. going to deliver.
        
        // status 1
        normalCell.imgViewStatus0.highlighted = YES;                    // 1st image view should be green. so highlight.
        normalCell.imgViewLine1.highlighted = YES;                      // 1st line image should be green. so highlight.
        normalCell.lblAllocated.textColor = DELIVERIES_TXTCOLOR_GREEN;  // stage 2, driver is allocated. first label color should be green.
        normalCell.lblAllocated.text = DELIVERY_DRIVER_ALLOCATED;       // change first label text to "delivery placed"
        
        // status 2
        normalCell.imgViewStatus1.highlighted = YES;                    // 2nd image view. driver allocated. green, highlight.
        normalCell.imgViewLine2.highlighted = YES;                      // 2nd line image. green. highlight.
        normalCell.lblPicked.textColor = DELIVERIES_TXTCOLOR_GREEN;     // 2nd label, driver allocated, green.
        
        // status 3
        normalCell.imgViewStatus2.highlighted = YES;                    // 3rd image view. packaged picked. green, hightlight.
        normalCell.lblEnRoute.textColor = DELIVERIES_TXTCOLOR_GREEN;    // 3rd label. green.
        normalCell.imgViewLine3.highlighted = YES;                      // 3rd line image. green, highlight.
        
        normalCell.lblDelivered.textColor = DELIVERIES_TXTCOLOR_GREY;   // other lables' color should be grey. coz this is first stage
        
    } else if ([delivery.status isEqualToNumber:[NSNumber numberWithInt:5]]) { //Delivered
        
        // status 1
        normalCell.imgViewStatus0.highlighted = YES;                    // 1st image view should be green. so highlight.
        normalCell.imgViewLine1.highlighted = YES;                      // 1st line image should be green. so highlight.
        normalCell.lblAllocated.textColor = DELIVERIES_TXTCOLOR_GREEN;  // stage 2, driver is allocated. first label color should be green.
        normalCell.lblAllocated.text = DELIVERY_DRIVER_ALLOCATED;       // change first label text to "delivery placed"
        
        // status 2
        normalCell.imgViewStatus1.highlighted = YES;                    // 2nd image view. driver allocated. green, highlight.
        normalCell.imgViewLine2.highlighted = YES;                      // 2nd line image. green. highlight.
        normalCell.lblPicked.textColor = DELIVERIES_TXTCOLOR_GREEN;     // 2nd label, driver allocated, green.
        
        // status 3
        normalCell.imgViewStatus2.highlighted = YES;                    // 3rd image view. packaged picked. green, hightlight.
        normalCell.lblEnRoute.textColor = DELIVERIES_TXTCOLOR_GREEN;    // 3rd label. green.
        normalCell.imgViewLine3.highlighted = YES;                      // 3rd line image. green, highlight.
        
        // status 4
        normalCell.imgViewStatus3.highlighted = YES;                    // 4th image view. green, so highlight.
        normalCell.lblDelivered.textColor = DELIVERIES_TXTCOLOR_GREEN;  // 4th label. green, highlight.
    }
    
    
}

//+(NSString *)formatDeliveryDate:(NSString *)deliveryDate {
//    NSArray * dateArr =[deliveryDate componentsSeparatedByString:@"T"];
//    NSString * date = [dateArr objectAtIndex:0];
//    date = [date stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
//    return date;
//}
//
//+(NSString *)formatDeliveryTime:(NSString *)deliveryDate {
//    NSArray * dateArr =[deliveryDate componentsSeparatedByString:@"T"];
//    NSString * time = [dateArr objectAtIndex:1];
//    NSArray *timeArr = [time componentsSeparatedByString:@":"];
//    time = [NSString stringWithFormat:@"%@:%@",[timeArr objectAtIndex:0],[timeArr objectAtIndex:1]];
//    
//    return time;
//}

-(void)configureTimedCell:(TimedDeliveriesCell *)timedCell atIndexPath:(NSIndexPath *)indexPath delivery:(Deliveries *)delivery {
    
    timedCell.lblCost.text = [NSString stringWithFormat:@"%@",delivery.cost];
    timedCell.lblCost.adjustsFontSizeToFitWidth = YES;
    
//    timedCell.lblFrom.text = delivery.fromAddress;
    timedCell.lblNoOfPeople.text = [NSString stringWithFormat:@"%@",delivery.peopleCount];
    
    if (![delivery.doorNumberTo isEmpty] && delivery.doorNumberTo != nil) {
        timedCell.lblTo.text = [NSString stringWithFormat:@"%@, %@",delivery.doorNumberTo,delivery.toAddress];
    } else {
        timedCell.lblTo.text = delivery.toAddress;
    }
    
    if (![delivery.doorNumberFrom isEmpty] && delivery.doorNumberFrom != nil) {
        timedCell.lblFrom.text = [NSString stringWithFormat:@"%@, %@",delivery.doorNumberFrom,delivery.fromAddress];
    } else {
        timedCell.lblFrom.text = delivery.fromAddress;
    }
    
    if (![delivery.deliveryDate isEqualToString:kNO_DATE]) {
        timedCell.lblDate.text = delivery.deliveryDate;
    } if (![delivery.deliveryTime isEqualToString:kNO_TIME]) {
        timedCell.lblTime.text = delivery.deliveryTime;
    }
    
    if ([delivery.note isEmpty]) {
        timedCell.viewNote.hidden = YES;
    }
    
    timedCell.lblOrderDate.text = [self formatDeliveryDate:delivery.createdDate];
    timedCell.lblOrderTime.text = [self formatDeliveryTime:delivery.createdDate];
    
    timedCell.lblClientName.text = delivery.name;
    timedCell.lblPhone.text = delivery.email;
    timedCell.lblOrderID.text = [NSString stringWithFormat:@"%@",delivery.deliveryID];
    
    Driver *driver = delivery.driverRS;
    if (driver != nil) {
        timedCell.lblName.text = [NSString stringWithFormat:@"(ID: %@) %@ %@",driver.driverID, driver.fName, driver.surName];
        [timedCell.imgViewUserPic loadWithURLString:driver.photoURL loadFromCacheFirst:YES complete:^(UIImage *image) {
            if (!image) {
                timedCell.imgViewUserPic.image = [UIImage imageNamed:@"userProfDefaultPic"];
            }
        }];
    }  else {
        timedCell.lblName.text = nil;
        timedCell.imgViewUserPic.image = [UIImage imageNamed:@"userProfDefaultPic"];
    }
    
    if ([delivery.vehicleID isEqualToNumber:[NSNumber numberWithInt:1]]) {
        timedCell.imgViewVehicle.image = [UIImage imageNamed:@"deliveriesNewDeliveryCarInactiveIcon"];
    } else if ([delivery.vehicleID isEqualToNumber:[NSNumber numberWithInt:2]]) {
        timedCell.imgViewVehicle.image = [UIImage imageNamed:@"deliveriesNewDeliveryVanInactiveIcon"];
    } else if ([delivery.vehicleID isEqualToNumber:[NSNumber numberWithInt:3]]) {
        timedCell.imgViewVehicle.image = [UIImage imageNamed:@"deliveriesNewDeliveryBikeInactiveIcon"];
    }
    
    /**
     *  updating status indicators
     */
    if ([delivery.status isEqualToNumber:[NSNumber numberWithInt:1]]) { // WaitingForAccept
        
        if ([delivery.isManuel isEqualToNumber:[NSNumber numberWithInt:0]]) {
            timedCell.imgViewStatus0.highlighted = NO;                      // 1st image view
            timedCell.imgViewLine1.highlighted = NO;                        // 1st line image
            timedCell.lblAllocated.textColor = IWAD_TEXT_COLOR;            // delivery placed but driver is not allocated. so color is grey.
            timedCell.lblAllocated.text = DELIVERY_AWAITING_FOR_DRIVER;    // lbl color is grey. set text to show that waiting for a driver.
        } else {
            timedCell.imgViewStatus0.highlighted = YES;                    // 1st image view should be green. so highlight.
            timedCell.imgViewLine1.highlighted = YES;                        // 1st line image
            timedCell.lblAllocated.textColor = DELIVERIES_TXTCOLOR_GREEN;  // delivery placed but driver is not allocated. so color is grey.
            timedCell.lblAllocated.text = DELIVERY_DRIVER_ALLOCATED;       // lbl color is grey. set text to show that waiting for a driver.
        }
        
        timedCell.imgViewStatus1.highlighted = NO;
        timedCell.imgViewLine2.highlighted = NO;
        timedCell.imgViewStatus2.highlighted = NO;
        timedCell.imgViewLine3.highlighted = NO;
        timedCell.imgViewStatus3.highlighted = NO;
        
        // other lables' color should be grey. coz this is first stage
        timedCell.lblPicked.textColor = DELIVERIES_TXTCOLOR_GREY;
        timedCell.lblDelivered.textColor = DELIVERIES_TXTCOLOR_GREY;
        timedCell.lblEnRoute.textColor = DELIVERIES_TXTCOLOR_GREY;
        
    }
    if ([delivery.status isEqualToNumber:[NSNumber numberWithInt:2]]) { // EnRouteToPickUp - driver allocated and is going to pick up the package.
        
        // status 1
        timedCell.imgViewStatus0.highlighted = YES;                    // 1st image view should be green. so highlight.
        timedCell.imgViewLine1.highlighted = YES;                      // 1st line image should be green. so highlight.
        timedCell.lblAllocated.textColor = DELIVERIES_TXTCOLOR_GREEN;  // stage 2, driver is allocated. first label color should be green.
        timedCell.lblAllocated.text = DELIVERY_DRIVER_ALLOCATED;       // change first label text to "delivery placed"
        
        timedCell.imgViewStatus1.highlighted = NO;
        timedCell.imgViewLine2.highlighted = NO;
        timedCell.imgViewStatus2.highlighted = NO;
        timedCell.imgViewLine3.highlighted = NO;
        timedCell.imgViewStatus3.highlighted = NO;
        
        // other lables' color should be grey. coz this is first stage
        timedCell.lblPicked.textColor = DELIVERIES_TXTCOLOR_GREY;
        timedCell.lblDelivered.textColor = DELIVERIES_TXTCOLOR_GREY;
        timedCell.lblEnRoute.textColor = DELIVERIES_TXTCOLOR_GREY;
        
    } else if ([delivery.status isEqualToNumber:[NSNumber numberWithInt:3]]) { //PickedUp - package was picked up.
        
        // status 1
        timedCell.imgViewStatus0.highlighted = YES;                    // 1st image view should be green. so highlight.
        timedCell.imgViewLine1.highlighted = YES;                      // 1st line image should be green. so highlight.
        timedCell.lblAllocated.textColor = DELIVERIES_TXTCOLOR_GREEN;  // stage 2, driver is allocated. first label color should be green.
        timedCell.lblAllocated.text = DELIVERY_DRIVER_ALLOCATED;       // change first label text to "delivery placed"
        
        // status 2
        timedCell.imgViewStatus1.highlighted = YES;                    // 2nd image view. driver allocated. green, highlight.
        timedCell.imgViewLine2.highlighted = YES;                      // 2nd line image. green. highlight.
        timedCell.lblPicked.textColor = DELIVERIES_TXTCOLOR_GREEN;     // 2nd label, driver allocated, green.
        
        timedCell.lblDelivered.textColor = DELIVERIES_TXTCOLOR_GREY;   // other lables' color should be grey. coz this is first stage
        timedCell.lblEnRoute.textColor = DELIVERIES_TXTCOLOR_GREY;
        
    } else if ([delivery.status isEqualToNumber:[NSNumber numberWithInt:4]]) { //EnRouteToDelivery - package picked up. going to deliver.
        
        // status 1
        timedCell.imgViewStatus0.highlighted = YES;                    // 1st image view should be green. so highlight.
        timedCell.imgViewLine1.highlighted = YES;                      // 1st line image should be green. so highlight.
        timedCell.lblAllocated.textColor = DELIVERIES_TXTCOLOR_GREEN;  // stage 2, driver is allocated. first label color should be green.
        timedCell.lblAllocated.text = DELIVERY_DRIVER_ALLOCATED;       // change first label text to "delivery placed"
        
        // status 2
        timedCell.imgViewStatus1.highlighted = YES;                    // 2nd image view. driver allocated. green, highlight.
        timedCell.imgViewLine2.highlighted = YES;                      // 2nd line image. green. highlight.
        timedCell.lblPicked.textColor = DELIVERIES_TXTCOLOR_GREEN;     // 2nd label, driver allocated, green.
        
        // status 3
        timedCell.imgViewStatus2.highlighted = YES;                    // 3rd image view. packaged picked. green, hightlight.
        timedCell.lblEnRoute.textColor = DELIVERIES_TXTCOLOR_GREEN;    // 3rd label. green.
        timedCell.imgViewLine3.highlighted = YES;                      // 3rd line image. green, highlight.
        
        timedCell.lblDelivered.textColor = DELIVERIES_TXTCOLOR_GREY;   // other lables' color should be grey. coz this is first stage
        
    } else if ([delivery.status isEqualToNumber:[NSNumber numberWithInt:5]]) { //Delivered
        
        // status 1
        timedCell.imgViewStatus0.highlighted = YES;                    // 1st image view should be green. so highlight.
        timedCell.imgViewLine1.highlighted = YES;                      // 1st line image should be green. so highlight.
        timedCell.lblAllocated.textColor = DELIVERIES_TXTCOLOR_GREEN;  // stage 2, driver is allocated. first label color should be green.
        timedCell.lblAllocated.text = DELIVERY_DRIVER_ALLOCATED;       // change first label text to "delivery placed"
        
        // status 2
        timedCell.imgViewStatus1.highlighted = YES;                    // 2nd image view. driver allocated. green, highlight.
        timedCell.imgViewLine2.highlighted = YES;                      // 2nd line image. green. highlight.
        timedCell.lblPicked.textColor = DELIVERIES_TXTCOLOR_GREEN;     // 2nd label, driver allocated, green.
        
        // status 3
        timedCell.imgViewStatus2.highlighted = YES;                    // 3rd image view. packaged picked. green, hightlight.
        timedCell.lblEnRoute.textColor = DELIVERIES_TXTCOLOR_GREEN;    // 3rd label. green.
        timedCell.imgViewLine3.highlighted = YES;                      // 3rd line image. green, highlight.
        
        // status 4
        timedCell.imgViewStatus3.highlighted = YES;                    // 4th image view. green, so highlight.
        timedCell.lblDelivered.textColor = DELIVERIES_TXTCOLOR_GREEN;  // 4th label. green, highlight.
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DeliveryDetailMainViewController *mvc = [self.storyboard instantiateViewControllerWithIdentifier:@"deliveryMainVC"];
    mvc.delivery = [_fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:mvc animated:YES];
}


#pragma mark - Cell Delegates

-(void)NormalDeliveriesCell:(NormalDeliveriesCell *)cell view:(UIView *)view address:(NSString *)address type:(LocationType)type {
    CGRect cellRect = cell.frame;
    CGRect myRect = CGRectMake(cellRect.origin.x + view.frame.origin.x + 137, cellRect.origin.y + view.frame.origin.y + 112 - offsetY, cellRect.size.width - (view.frame.origin.x + 26), view.frame.size.height);
    LocationPopupViewController *lvc = [[LocationPopupViewController alloc] initWithType:type address:address frame:myRect];
    [lvc showInView:[BaseUtilClass superView]];
}

-(void)TimedDeliveriesCell:(TimedDeliveriesCell *)cell view:(UIView *)view address:(NSString *)address type:(LocationType)type {
    CGRect cellRect = cell.frame;
    CGRect myRect = CGRectMake(cellRect.origin.x + view.frame.origin.x + 137, cellRect.origin.y + view.frame.origin.y + 112 - offsetY, cellRect.size.width - (view.frame.origin.x + 26), view.frame.size.height);
    LocationPopupViewController *lvc = [[LocationPopupViewController alloc] initWithType:type address:address frame:myRect];
    [lvc showInView:[BaseUtilClass superView]];
}


#pragma mark - UISearchBar Delegate

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_fetchedResultsController.fetchRequest setPredicate:nil];
    [self reloadFetchedViewController];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        [_fetchedResultsController.fetchRequest setPredicate:nil];
        [self reloadFetchedViewController];
    } else {
        [self filter:searchText];
    }
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length == 0) {
        [_fetchedResultsController.fetchRequest setPredicate:nil];
        [self reloadFetchedViewController];
    }
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField {
    [_fetchedResultsController.fetchRequest setPredicate:nil];
    [self reloadFetchedViewController];
    return YES;
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [searchBar resignFirstResponder];
    offsetY = scrollView.contentOffset.y;
}


#pragma mark - Sync Manager Delegate

-(void)syncManagerResponseSuccessWithResponse:(NSDictionary *)response withTag:(NSInteger)tag{
    [refreshControl endRefreshing];
    [self reloadFetchedViewController];
    if ([[response valueForKey:@"success"] isEqualToString:@"true"]) {
        NSArray *delis = [response valueForKey:@"deliveries"];
        if (delis.count > 0) {
            if (noContentVC) {
                [noContentVC willMoveToParentViewController:nil];
                [noContentVC.view removeFromSuperview];
                [noContentVC removeFromParentViewController];
            }
            
        } else {
            [self addChildViewController:noContentVC];
            [self.view addSubview:noContentVC.view];
        }
    }
}

-(void)noContentView:(NoContentViewController *)view buttonTappedWithType:(DeliveryType)type {
    if (type == DeliveryTypeNow) {
        [self performSegueWithIdentifier:@"deliverNow" sender:nil];
    } else if (type == DeliveryTypeLater) {
        [self performSegueWithIdentifier:@"deliverLater" sender:nil];
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NewDeliveryStep1ViewController *nvc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"deliverNow"]) {
        nvc.showDateTime = NO;
        nvc.deliveryLater = NO;
        nvc.delivery = [[Delivery alloc] init];
        nvc.delivery.driver = nil;
    } else if ([segue.identifier isEqualToString:@"deliverLater"]) {
        nvc.showDateTime = YES;
        nvc.deliveryLater = YES;
        nvc.delivery = [[Delivery alloc] init];
        nvc.delivery.driver = nil;
    }
}


#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Deliveries"
                                   inManagedObjectContext:[CoreDataManager managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"deliveryID" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:5];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:[CoreDataManager managedObjectContext]
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

#pragma mark - Fetched Results Controller Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [tblDeliveries beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = tblDeliveries;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeUpdate:{
            Deliveries * delivery;
                delivery = [_fetchedResultsController objectAtIndexPath:indexPath];
            if ([delivery.deliveryDate isEqualToString:kNO_DATE]) {
                [self configureNormalCell:(NormalDeliveriesCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath delivery:delivery];
            } else {
                [self configureTimedCell:(TimedDeliveriesCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath delivery:delivery];
            }
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    UITableView *tableView = tblDeliveries;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationLeft];
            break;
            
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [tblDeliveries endUpdates];
}


#pragma mark - Other Methods

-(void)fetchDeliveries {
    if ([BaseUtilClass isConnectedToInternetInVC:self]) {
        [refreshControl beginRefreshing];
        [self resetFRC];
        [tblDeliveries reloadData];
        syncManager = [[SyncManager alloc] initWithDelegate:self];
        [syncManager fetchAllDeliveriesInView:nil];
    }
}

- (void)reloadFetchedViewController {
    NSError *error = nil;
    [self resetFRC];
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    [tblDeliveries reloadData];
}

-(void)resetFRC {
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;
}


-(NSString *)formatDeliveryDate:(NSString *)deliveryDate {
//    NSArray * dateArr =[deliveryDate componentsSeparatedByString:@"T"];
//    NSString * date = [dateArr objectAtIndex:0];
//    date = [date stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
//    return date;
    NSArray * dateArr =[deliveryDate componentsSeparatedByString:@"T"];
    NSString * date = [dateArr objectAtIndex:0];
    date = [[BaseUtilClass sharedInstance] formatDateToUKFormat:date];
    date = [date stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    return date;
}

-(NSString *)formatDeliveryTime:(NSString *)deliveryDate {
    NSArray * dateArr =[deliveryDate componentsSeparatedByString:@"T"];
    NSString * time = [dateArr objectAtIndex:1];
    NSArray *timeArr = [time componentsSeparatedByString:@":"];
    time = [NSString stringWithFormat:@"%@:%@",[timeArr objectAtIndex:0],[timeArr objectAtIndex:1]];
    
    return time;
}

#pragma mark - Search Method

-(void)filter:(NSString*)text {
    if(text.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(deliveryID CONTAINS[c] %@) OR (fromAddress CONTAINS[c] %@) OR (toAddress CONTAINS[c] %@) OR (email CONTAINS[c] %@) OR (name CONTAINS[c] %@)", text, text, text, text, text];
        [fetchRequest setPredicate:predicate];
        [self reloadFetchedViewController];
    }
}
@end
