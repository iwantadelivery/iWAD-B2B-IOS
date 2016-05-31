//
//  CardSelectorViewController.m
//  iWAD
//
//  Created by Himal Madhushan on 1/18/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "CardSelectorViewController.h"

@interface CardSelectorViewController () {
    __weak IBOutlet UIButton * btnVisa;
    __weak IBOutlet UIButton * btnAmex;
    __weak IBOutlet UIButton * btnMasterCard;
    __weak IBOutlet UIButton * btnDiscover;
    __weak IBOutlet UIButton * btnJCB;
    __weak IBOutlet UIButton * btnDinersClub;
    
    STPCardBrand cardBrand;
}

@end

@implementation CardSelectorViewController

@synthesize delegate = _delegate;

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(350, 160);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button Actions

-(IBAction)selectCard:(UIButton *)sender {
    
    if (sender == btnAmex) {
        cardBrand = STPCardBrandAmex;
        
    } else if (sender == btnVisa) {
        cardBrand = STPCardBrandVisa;
        
    } else if (sender == btnMasterCard) {
        cardBrand = STPCardBrandMasterCard;
        
    } else if (sender == btnJCB) {
        cardBrand = STPCardBrandJCB;
        
    } else if (sender == btnDinersClub) {
        cardBrand = STPCardBrandDinersClub;
        
    } else if (sender == btnDiscover) {
        cardBrand = STPCardBrandDiscover;
        
    }
    
    if ([_delegate respondsToSelector:@selector(cardSelectorDidPickStrpieCardType:)]) {
        [_delegate cardSelectorDidPickStrpieCardType:cardBrand];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
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
