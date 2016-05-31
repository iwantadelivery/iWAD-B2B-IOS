//
//  MainViewController.m
//  iWad
//
//  Created by Saman Kumara on 12/11/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//


#import "MainViewController.h"

@interface MainViewController ()
@property (nonatomic, strong) UIView *contentView;
@end

@implementation MainViewController

NSString * const IWadSegueContentIdentifier = @"iwad_contentView";
NSString * const IWadSegueLeftIdentifier = @"iwad_LeftMenu";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    /**
     the view under status bar.
     
     - returns: black view.
     */
    UIView * blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    blackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:blackView];
    
}

#pragma mark - View lifecycle

- (void)loadView {
    CGRect frame = [[UIScreen mainScreen] bounds];
    _contentView                    = [[UIView alloc]initWithFrame:frame];
    _contentView.backgroundColor    = [UIColor colorWithRed:0.1922 green:0.201 blue:0.2322 alpha:1.0];
    [_contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];

    self.view = self.contentView;
    [self loadStoryBoardControllers];
}

-(void)loadStoryBoardControllers {
    if (self.storyboard) {
        @try{
            [self performSegueWithIdentifier:IWadSegueLeftIdentifier sender:nil];
        }@catch(NSException *exception) {
            NSLog(@"error-%@", exception);
        }
        
        @try{
            [self performSegueWithIdentifier:IWadSegueContentIdentifier sender:nil];
        }@catch(NSException *exception) {}
    }
}

@end


@implementation LeftMenuSegue

-(void)perform {
    MainViewController *sourceViewController = self.sourceViewController;
    UIViewController *destinationViewController = self.destinationViewController;
    
    if ([self.identifier isEqualToString:IWadSegueContentIdentifier]) {
        
        sourceViewController.rightViewController = destinationViewController;
        destinationViewController.view.frame = CGRectMake(128, 0, sourceViewController.view.frame.size.width-128, self.destinationViewController.view.frame.size.height);
        
    }else if ([self.identifier isEqualToString:IWadSegueLeftIdentifier]) {
        sourceViewController.menuViewController = destinationViewController;
//        destinationViewController.view.backgroundColor = [UIColor redColor];
        destinationViewController.view.frame = CGRectMake(0, 0, 128, self.destinationViewController.view.frame.size.height);
        
    }
    [sourceViewController addChildViewController:destinationViewController];
    [sourceViewController.view addSubview:destinationViewController.view];
}



@end

#pragma mark - UIViewController(MainViewController) Category

@implementation UIViewController(MainViewController)

- (MainViewController*)revealViewController {
    UIViewController *parent = self;
    Class revealClass = [MainViewController class];
    while ( nil != (parent = [parent parentViewController]) && ![parent isKindOfClass:revealClass] ) {}
    return (id)parent;
}

@end