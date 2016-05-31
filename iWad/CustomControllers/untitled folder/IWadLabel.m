//
//  IWadLabel.m
//  iWad
//
//  Created by Saman Kumara on 12/15/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "IWadLabel.h"
#import "ContentViewController.h"

@implementation IWadLabel

-(void)awakeFromNib{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self addGestureRecognizer:singleFingerTap];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    
    NSString * string = self.text;
    if (string.description != nil && string != nil && [string length] > 0 && ![string isKindOfClass:[NSNull class]] && ![string isEqualToString:@""]) {
        ContentViewController *contentVC = [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];
        contentVC.modalPresentationStyle = UIModalPresentationPopover;
        UIPopoverPresentationController *popPC = contentVC.popoverPresentationController;
        popPC.backgroundColor = IWAD_POPOVER_ARROW_COLOR;
        contentVC.popoverPresentationController.sourceRect = self.frame;
        contentVC.popoverPresentationController.sourceView = self;
        popPC.permittedArrowDirections = UIPopoverArrowDirectionUp;
        
        
        contentVC.view.layer.shadowColor = [[UIColor redColor] CGColor];
        contentVC.view.layer.shadowOffset = CGSizeMake(-15.0f, 15.0f);
        contentVC.view.layer.shadowRadius = 10.0f;
        contentVC.view.layer.shadowOpacity = 1.0f;
        
        [self.viewController presentViewController:contentVC animated:YES completion:^{
            [contentVC loadingWithText:self.text];
        }];
    }
    
}

@end
