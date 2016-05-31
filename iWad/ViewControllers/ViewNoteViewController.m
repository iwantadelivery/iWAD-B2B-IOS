//
//  ViewNoteViewController.m
//  iWAD
//
//  Created by Himal Madhushan on 2/26/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "ViewNoteViewController.h"

@interface ViewNoteViewController () {
    __weak IBOutlet UITextView *txtView;
    __weak IBOutlet UILabel *lblTitle;
}

@end

@implementation ViewNoteViewController
@synthesize delivery;

-(void)viewWillAppear:(BOOL)animated {
    txtView.text = delivery.note;
    lblTitle.text = [NSString stringWithFormat:@"DELIVERY NOTE ON ODER ID: %@",delivery.deliveryID];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
