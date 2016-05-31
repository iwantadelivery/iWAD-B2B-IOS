//
//  AddNoteViewController.m
//  iWAD
//
//  Created by Himal Madhushan on 2/26/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "AddNoteViewController.h"

@interface AddNoteViewController () <UITextViewDelegate> {
    __weak IBOutlet UITextView *txtView;
    __weak IBOutlet UILabel *lblCharacters;
    __weak IBOutlet UIButton *btnAdd;
}

@end

@implementation AddNoteViewController
@synthesize delivery, delegate = _delegate;

#pragma mark - View
-(void)viewWillAppear:(BOOL)animated {
    if (delivery.note) {
        txtView.text = delivery.note;
        btnAdd.enabled = YES;
        NSInteger len = txtView.text.length;
        lblCharacters.text = [NSString stringWithFormat:@"%li/500",len];
    } else
        btnAdd.enabled = NO;
    
    [txtView becomeFirstResponder];
    [self setPreferredContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 146, 350)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions
-(IBAction)addNote:(UIButton *)sender {
    delivery.note = txtView.text;
    if ([_delegate respondsToSelector:@selector(deliveryNoteAdded:)]) {
        [_delegate deliveryNoteAdded:delivery.note];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)cancel:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView {
    NSInteger len = textView.text.length;
    lblCharacters.text = [NSString stringWithFormat:@"%li/500",len];
    btnAdd.enabled = YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text length] == 0)
    {
        if([textView.text length] != 0)
        {
            return YES;
        }
    }
    else if([[textView text] length] >= 500)
    {
        return NO;
    }
    return YES;
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
