//
//  HelpViewController.m
//  iWad
//
//  Created by Saman Kumara on 12/17/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "HelpViewController.h"
#import <MessageUI/MessageUI.h>
#import "LocationPopupViewController.h"

@interface HelpViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation HelpViewController

-(void)viewWillAppear:(BOOL)animated {
    self.title = @"HELP";
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)callHelpLine:(UIButton *)sender {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"telprompt://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:IWAD_HELP_CALL_LINE]];
    } else {
        [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:@"Your device doesn't support calling." actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
    }
}

-(IBAction)sendEmail:(UIButton *)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setToRecipients:@[IWAD_HELP_MAIL]];
        [self presentViewController:composeViewController animated:YES completion:nil];
    } else {
        [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:IWAD_ERROR_CANT_SEND_MAILS actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
    }
}

-(IBAction)shareWithFriends:(UIButton *)sender {
    NSString *textToShare = @"Place orders with iWAD - I Want A Deliver. Make your life easier..";
    NSURL *myWebsite = [NSURL URLWithString:@"+448001700141"];
    NSArray *objectsToShare = @[textToShare, myWebsite];
    
    UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    avc.excludedActivityTypes = excludeActivities;
    
    UIPopoverPresentationController *popPC = avc.popoverPresentationController;
    popPC.backgroundColor = IWAD_POPOVER_ARROW_COLOR;
    avc.popoverPresentationController.sourceRect = sender.frame;
    avc.popoverPresentationController.sourceView = sender;
    popPC.permittedArrowDirections = UIPopoverArrowDirectionDown;
    
    [self presentViewController:avc animated:YES completion:nil];
}


#pragma mark - Mail Compose View Controller Delegate

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end
