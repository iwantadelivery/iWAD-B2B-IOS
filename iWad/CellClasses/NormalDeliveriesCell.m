//
//  NormalDeliveriesCell.m
//  iWAD
//
//  Created by Himal Madhushan on 1/19/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "NormalDeliveriesCell.h"
#import "ViewNoteViewController.h"

@implementation NormalDeliveriesCell
@synthesize delegate = _delegate, viewNote;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)viewNote:(UIButton *)sender {
    ViewNoteViewController *contentVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"viewNote"];
    contentVC.delivery = self.delivery;
    contentVC.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController *popPC = contentVC.popoverPresentationController;
    popPC.backgroundColor = IWAD_POPOVER_ARROW_COLOR;
    CGRect sourceRect = viewNote.frame;
//    sourceRect.origin.x += sourceRect.size.width;
//    sourceRect.origin.y += 100;
    contentVC.popoverPresentationController.sourceRect = sourceRect;
    contentVC.popoverPresentationController.sourceView = self;
    popPC.permittedArrowDirections = UIPopoverArrowDirectionLeft;
    
    [self.viewController presentViewController:contentVC animated:YES completion:nil];
}

-(IBAction)tapFromView:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(NormalDeliveriesCell:view:address:type:)]) {
        [_delegate NormalDeliveriesCell:self view:self.viewFrom address:self.delivery.fromAddress type:LocationTypeFrom];
    }
}

-(IBAction)tapToView:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(NormalDeliveriesCell:view:address:type:)]) {
        [_delegate NormalDeliveriesCell:self view:self.viewTo address:self.delivery.toAddress type:LocationTypeTo];
    }
}

@end
