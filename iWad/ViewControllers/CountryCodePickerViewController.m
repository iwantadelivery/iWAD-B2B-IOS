//
//  CountryCodePickerViewController.m
//  iWAD
//
//  Created by Himal Madhushan on 1/13/16.
//  Copyright © 2016 Saman Kumara. All rights reserved.
//

#import "CountryCodePickerViewController.h"

@interface CountryCodePickerViewController () <UIPickerViewDelegate, UIPickerViewDataSource> {
    
    __weak IBOutlet UIPickerView *ccPicker;
    
    NSString * cCode;
}

@end

@implementation CountryCodePickerViewController

@synthesize delegate = _delegate, countryCodesArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    countryCodesArray = [NSArray arrayWithObjects:@"93",@"355",@"213",@"376",@"244",@"54",@"374",@"297",@"43",@"994",@"1",@"973",@"880",@"375",@"32",@"501",@"229",@"975",@"387",@"267",@"55",@"246",@"359",@"226",@"257",@"855",@"237",@"238",@"345",@"236",@"235",@"56",@"86",@"57",@"269",@"242",@"682",@"506",@"385",@"53",@"537",@"420",@"45",@"253",@"593",@"20",@"503",@"240",@"291",@"372",@"251",@"298",@"679",@"358",@"33",@"594",@"689",@"241",@"220",@"995",@"49",@"233",@"350",@"30",@"299",@"502",@"224",@"245",@"509",@"504",@"36",@"354",@"91",@"62",@"964",@"353",@"972",@"39",@"81",@"962",@"77",@"254",@"686",@"965",@"996",@"371",@"961",@"266",@"231",@"423",@"370",@"352",@"261",@"265",@"60",@"960",@"223",@"356",@"692",@"596",@"222",@"230",@"52",@"377",@"976",@"382",@"212",@"95",@"264",@"674",@"977",@"31",@"599",@"687",@"64",@"505",@"227",@"234",@"683",@"672",@"47",@"968",@"92",@"680",@"507",@"675",@"595",@"51",@"63",@"48",@"351",@"974",@"40",@"250",@"685",@"378",@"966",@"221",@"381",@"248",@"232",@"65",@"421",@"386",@"677",@"27",@"500",@"34",@"94",@"249",@"597",@"268",@"46",@"41",@"992",@"66",@"228",@"690",@"676",@"216",@"90",@"993",@"688",@"256",@"380",@"971",@"598",@"998",@"678",@"681",@"967",@"260",@"263",@"591",@"673",@"61",@"243",@"225",@"379",@"852",@"98",@"44",@"850",@"82",@"856",@"218",@"853",@"389",@"691",@"373",@"258",@"970",@"872",@"262",@"7",@"290",@"590",@"508",@"239",@"252",@"963",@"886",@"255",@"670",@"58",@"84",@"1340", @"1670", @"1787", @"1868", nil];
    
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"intValue" ascending: YES];
    countryCodesArray = [countryCodesArray sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]];
    
    self.preferredContentSize = CGSizeMake(320, 300);
    self.view.backgroundColor = IWAD_POPOVER_ARROW_COLOR;
}

-(void)viewDidAppear:(BOOL)animated {
    [ccPicker reloadAllComponents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Button Actions
- (IBAction)done:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([_delegate respondsToSelector:@selector(countryCodePicker:didPickCode:)]) {
            [_delegate countryCodePicker:ccPicker didPickCode:cCode];
        }
    }];
}


#pragma mark - UIPickerView DataSource and Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return countryCodesArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [countryCodesArray objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    cCode = [countryCodesArray objectAtIndex:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = [NSString stringWithFormat:@"+%@",[countryCodesArray objectAtIndex:row]];
    label.textAlignment = NSTextAlignmentCenter;
    return label;    
}

@end
