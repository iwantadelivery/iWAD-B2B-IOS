//
//  PersonalInfoViewController.m
//  iWad
//
//  Created by Saman Kumara on 12/18/15.
//  Copyright © 2015 Saman Kumara. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "RoundedImageView.h"
#import "BaseUtilClass.h"
#import "CountryCodePickerViewController.h"

@interface PersonalInfoViewController () <SyncManagerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, CountryCodePickerDelegate> {
    IBOutlet UIScrollView *scrollView;
    UITextField *activeField;
    NSString * gender, *dob;
    
    __weak IBOutlet UITextField *mobileTxt;
    __weak IBOutlet UITextField *txtDate;
    __weak IBOutlet UITextField *txtMonth;
    __weak IBOutlet UITextField *txtYear;
    __weak IBOutlet UITextField *txtOrganisationName;
    __weak IBOutlet UILabel *lblCountryCode;
    __weak IBOutlet UIView *viewPersonalInfo;
    __weak IBOutlet UIButton * btnProfilePic;
    __weak IBOutlet UIButton * btnUpdate;
    
    __weak IBOutlet RoundedImageView *imgViewProfPic;
    
    UIImagePickerController * imagePickerController;
    UIImage * pickedProfImage;
    
}
@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;

@end

@implementation PersonalInfoViewController

@synthesize delegate = _delegate;

#pragma mark - View 

-(void)viewWillAppear:(BOOL)animated {
    scrollView.scrollEnabled = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showProfileInfo];
    
    [self registerForKeyboardNotifications];
    imagePickerController = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.showsCameraControls = YES;
    }
    
    pickedProfImage = [UIImage new];
    
}


#pragma mark - Button Actions

- (IBAction)tapGenderButton:(UIButton *)sender {
    [self resetButtons];
    sender.selected = YES;
    
    if (sender.tag == 0) {
        gender = @"MALE";
    } else {
        gender = @"FEMALE";
    }
}

- (IBAction)pickProfilePic:(UIButton *)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [BaseUtilClass showAlertViewInViewController:self title:@"Error!" message:@"Device has no camera" actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
    } else {
        UIActionSheet * as = [[UIActionSheet alloc] initWithTitle:@"Select the source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Select From Albums", nil];
        [as showInView:self.view];
    }
}

-(IBAction)updateProfile:(UIButton *)sender {
    
    if ([BaseUtilClass isConnectedToInternetInVC:self]) {
        
        if ([self.nameTxt.text isEmpty] || [lblCountryCode.text isEmpty] || lblCountryCode.text == nil){
            [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:IWAD_ERROR_MSG_GENERAL actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
            return;
        }
        
        dob = [txtYear.text stringByAppendingFormat:@"-%@-%@",txtMonth.text,txtDate.text ];
        
        NSString *phoneNumber = [lblCountryCode.text stringByAppendingString:mobileTxt.text];
        if (![phoneNumber isValidPhoneNumber]) {
            [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:IWAD_ERROR_NOT_VALID_PHONE actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
            return;
        }
        
        sender.enabled = NO;
        
        NSDictionary * params = @{@"user[email]":self.emailTxt.text,
                                  @"user[name]":self.nameTxt.text,
                                  @"user[date_of_birth]":dob,
                                  @"user[gender]":gender,
                                  @"user[phone_no]":mobileTxt.text,
                                  @"user[country_code]":[NSString stringWithFormat:@"%@",lblCountryCode.text]};
        
        SyncManager * sm = [[SyncManager alloc] initWithDelegate:self];
        
        
        NSString *fileName = [NSString stringWithFormat:@"%@",[CoreDataManager user].userID];
        fileName = [fileName stringByAppendingString:@".jpeg"];
        
        NSData * imageData = UIImageJPEGRepresentation(imgViewProfPic.image, 1);
        
        SWMedia *file1 = [[SWMedia alloc]initWithFileName:fileName key:@"user[avatar]" data:imageData];
        NSArray *fileArray = [NSArray arrayWithObject:file1];
        [sm updateUserProfile:params files:fileArray parentView:[BaseUtilClass superView]];
        
    }
}


#pragma mark - Text Field Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameTxt) {
        [mobileTxt becomeFirstResponder];
    } else if (textField == mobileTxt) {
        [mobileTxt resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    activeField = nil;
}


#pragma mark - SyncManager Delegate

-(void)syncManagerResponseSuccessWithResponse:(NSDictionary *)response withTag:(NSInteger)tag {
    btnUpdate.enabled = YES;
    if (tag == 105) {
        
    } else {
        if ([[response objectForKey:@"success"] isEqualToString:@"false"]) {
            NSArray * messageArray = [response objectForKey:@"errors"];
            NSString * message = [NSString string];
            message = [messageArray componentsJoinedByString:@" ,"];
            [BaseUtilClass showAlertViewInViewController:self title:IWAD_ERROR_TITLE_ERROR message:message actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
            
        } else {
            if ([_delegate respondsToSelector:@selector(userDidPickImage:)]) {
                [_delegate userDidPickImage:pickedProfImage];
            }
            NSData * imageData = UIImageJPEGRepresentation(pickedProfImage, 1);
            User *user = [CoreDataManager user];
            user.userName = self.nameTxt.text;
            user.userGender = gender;
            user.userPhone = mobileTxt.text;
            user.countryCode = lblCountryCode.text;
            user.userImage = imageData;
            [CoreDataManager saveToCoreData];
            [BaseUtilClass showAlertViewInViewController:self title:@"Success" message:@"Profile successfully updated." actionTitle:IWAD_ERROR_ALERT_OK_TITLE];
        }
    }
    
}

#pragma mark - CountryCodePicker Delegate

-(void)countryCodePicker:(UIPickerView *)datepicker didPickCode:(NSString *)code {
    if (code) {
        lblCountryCode.text = [NSString stringWithFormat:@"+%@",code];
    }
}

#pragma mark - Action Sheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    NSDictionary *batItemAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                       IWAD_TEXT_COLOR,NSForegroundColorAttributeName,
                                       nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:batItemAttributes
                                                forState:UIControlStateNormal];
    
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
//        [popover presentPopoverFromRect:btnProfilePic.bounds inView:btnProfilePic permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//        self.popOver = popover;
//    } else {
//        [self presentModalViewController:imagePickerController animated:YES];
//    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.navigationController presentViewController:imagePickerController animated:YES completion:^{
            imagePickerController.navigationController.navigationBar.tintColor = [UIColor redColor];
        }];
    }];
    
    
}

-(void)actionSheetCancel:(UIActionSheet *)actionSheet {
    
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    pickedProfImage = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    imgViewProfPic.image = pickedProfImage;
    
    [self setNavigationBarTintClear];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self setNavigationBarTintClear];
}

-(void)setNavigationBarTintClear {
    NSDictionary *batItemAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIColor clearColor],NSForegroundColorAttributeName,
                                       nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:batItemAttributes
                                                forState:UIControlStateNormal];
}


#pragma mark - Other methods

- (void)registerForKeyboardNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}



- (void)keyboardWasShown:(NSNotification*)aNotification {
    scrollView.scrollEnabled = YES;
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect rect = activeField.frame;
    rect.origin.y = rect.origin.y + 270;
    
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, rect.origin) ) {
        [scrollView scrollRectToVisible:rect animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    [scrollView setContentOffset:CGPointZero animated:YES];
    scrollView.scrollEnabled = NO;
}

-(void)showProfileInfo {
    
    self.emailTxt.text = [CoreDataManager user].userEmail;
    self.nameTxt.text = [CoreDataManager user].userName;
    NSString * currentGender = [CoreDataManager user].userGender;
    gender = currentGender;
    [self resetButtons];
    if ([currentGender caseInsensitiveCompare:@"MALE"] || [currentGender isEqualToString:@"MALE"]) {
        self.maleBtn.selected = YES;
        self.femaleBtn.selected = NO;
    } else if ([gender caseInsensitiveCompare:@"FEMALE"] || [currentGender isEqualToString:@"FEMALE"]) {
        self.femaleBtn.selected = YES;
        self.maleBtn.selected = NO;
    }
    
    lblCountryCode.text = [CoreDataManager user].countryCode;
    mobileTxt.text = [CoreDataManager user].userPhone;
    
    NSString * doB = [CoreDataManager user].userDOB;
    NSArray * dobArr = [doB componentsSeparatedByString:@"-"];
    txtYear.text = [dobArr objectAtIndex:0];
    txtMonth.text = [dobArr objectAtIndex:1];
    txtDate.text = [dobArr objectAtIndex:2];
    
    if (![CoreDataManager user].userImage) {
        SyncManager *sm = [[SyncManager alloc] initWithDelegate:self];
        [sm fetchUserDetailsInView:nil];
        imgViewProfPic.image = [UIImage imageNamed:@"userProfDefaultPic"];
    } else {
        imgViewProfPic.image = [UIImage imageWithData:[CoreDataManager user].userImage];
    }
    imgViewProfPic.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        imgViewProfPic.alpha = 1;
    }];
    
}


-(void)resetButtons{
    self.maleBtn.selected = NO;
    self.femaleBtn.selected = NO;
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"ccPicker"]) {
        CountryCodePickerViewController * dp = [segue destinationViewController];
        dp.delegate = self;
        [BaseUtilClass setPopOverArrowColorForViewController:dp];
        
    }
}
@end
