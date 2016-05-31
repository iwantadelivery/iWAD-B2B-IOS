//
//  MainViewController.h
//  iWad
//
//  Created by Saman Kumara on 12/11/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
@property(nonatomic, strong) IBOutlet UIViewController       *rightViewController;
@property(nonatomic, strong) IBOutlet UIViewController       *menuViewController;
@end


@interface LeftMenuSegue : UIStoryboardSegue



@end


#pragma mark - UIViewController(MainViewController) Category

@interface UIViewController(MainViewController)

- (MainViewController*)revealViewController;

@end