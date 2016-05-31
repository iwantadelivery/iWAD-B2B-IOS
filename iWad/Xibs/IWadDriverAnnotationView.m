//
//  IWadDriverAnnotationView.m
//  iWAD
//
//  Created by Himal Madhushan on 2/19/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "IWadDriverAnnotationView.h"

@interface IWadDriverAnnotationView () <UIGestureRecognizerDelegate> {
    __weak IBOutlet UIButton *btnCall;
    __weak IBOutlet UIImageView *imgViewDriverPic;
    __weak IBOutlet UILabel *lblDriverName;
    
}
@property (nonatomic, strong) NSString *phoneNumber;
@end

@implementation IWadDriverAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib {
    self.layer.cornerRadius = self.frame.size.height/2;
    self.clipsToBounds = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callDriver:)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
}

- (void)setDriverDetails:(IWadDriver *)driver imgURL:(NSString *)imgURL {
    lblDriverName.text = [NSString stringWithFormat:@"(ID: %@) %@",driver.driverID, driver.name];
    self.phoneNumber = driver.mobile;
    [imgViewDriverPic loadWithURLString:[NSString stringWithFormat:@"%@%@",BASE_IMAGE_URL, imgURL] loadFromCacheFirst:NO complete:^(UIImage *image) {
        if (!image) {
            imgViewDriverPic.image = [UIImage imageNamed:@"userProfDefaultPic"];
        }
    }];
}

-(IBAction)callDriver:(UIButton *)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"telprompt://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.phoneNumber]]];
    } else {
        [BaseUtilClass showAlertViewInViewController:[AppDelegate sharedInstance].window.rootViewController title:@"Sorry!" message:@"Your device doesn't support calling." actionTitle:@"OK"];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}
@end
