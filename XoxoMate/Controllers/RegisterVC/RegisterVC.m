//
//  RegisterVC.m
//  XoxoMate
//
//  Created by apple on 2016-04-22.
//  Copyright © 2016 doth. All rights reserved.
//

#import "RegisterVC.h"
#import "Constants.h"

@interface RegisterVC ()

@property (strong, nonatomic) IBOutlet MSTextField *txtFirstName;
@property (strong, nonatomic) IBOutlet MSTextField *txtLastName;
@property (strong, nonatomic) IBOutlet MSTextField *txtUserName;
@property (strong, nonatomic) IBOutlet MSTextField *txtEmail;
@property (strong, nonatomic) IBOutlet MSTextField *txtPassword;
@property (strong, nonatomic) IBOutlet MSTextField *txtConfirmPassword;
@property (strong, nonatomic) IBOutlet MSTextField *txtDOB;

@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation RegisterVC

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Click Event

- (IBAction)btnBackTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDOBTapped:(id)sender{
    [self resignFields];
    [self.scrollView setContentOffset:CGPointMake(0, 130) animated:YES];
    [self showDatePickerView];
}

- (IBAction)btnRightTapped:(id)sender{
    _pickerView.hidden = YES;
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateFormat];
    NSString *value = [dateFormatter stringFromDate:_datePicker.date];
    _txtDOB.text = [value uppercaseString];
}

- (IBAction)btnCloseTapped:(id)sender{
    _pickerView.hidden = YES;
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (IBAction)btnRegisterTapped:(id)sender{
    if ([self isValidRegisterDetails]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSMutableDictionary *dict = @{
                                      @"first_name":_txtFirstName.text,
                                      @"last_name":_txtLastName.text,
                                      @"username":_txtUserName.text,
                                      @"email":_txtEmail.text,
                                      @"password":_txtPassword.text,
                                      @"password_confirmation":_txtConfirmPassword.text,
                                      @"birthdate":_txtDOB.text
                                      }.mutableCopy;
        
        NSError *serr;
        
        NSData *jsonData = [NSJSONSerialization
                            dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&serr];
        
        if (serr){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return;
        }
        
#define appService [NSURL URLWithString:@"https://xoxomate.com/api/Apis/register.json"]
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:appService];
        
        request.HTTPMethod = @"POST";
        request.HTTPBody = jsonData;
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [request setValue:[NSString stringWithFormat:@"%lu",
                           (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *r, NSData *data, NSError *error)
         {
             if (!data){
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 [[TKAlertCenter defaultCenter] postAlertWithMessage:@"No data returned from server, error ocurred" image:kErrorImage];
                 
                 return;
             }
             
             NSError *deserr;
             NSDictionary *responseDict = [NSJSONSerialization
                                           JSONObjectWithData:data
                                           options:kNilOptions
                                           error:&deserr];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             NSString *strErrorCode = [NSString stringWithFormat:@"%@",responseDict[@"response"][@"error"]];
             [self resignFields];
             if ([strErrorCode isEqualToString:@"1"]){
                 [[TKAlertCenter defaultCenter] postAlertWithMessage:responseDict[@"response"][@"message"] image:kErrorImage];
             }else{
                 [self.navigationController popViewControllerAnimated:YES];
             }
         }];
    }
}

#pragma mark - Show Picker View

- (void)showDatePickerView{
    _pickerView.hidden = NO;
    _datePicker.hidden = NO;
    [self.view bringSubviewToFront:_datePicker];
    _datePicker.datePickerMode = UIDatePickerModeDate;
}

#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _pickerView.hidden = YES;
    return YES;
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//
//    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
//    [keyboardDoneButtonView sizeToFit];
//    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked:)];
//    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
//    textField.inputAccessoryView = keyboardDoneButtonView;
//
//    return YES;
//}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [textField resignFirstResponder];
//    
//    return YES;
//}

//- (IBAction)doneClicked:(id)sender{
//    [self.view endEditing:YES];
//}

- (void)resignFields{
    [self.txtFirstName resignFirstResponder];
    [self.txtLastName resignFirstResponder];
    [self.txtUserName resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self.txtConfirmPassword resignFirstResponder];
    [self.txtDOB resignFirstResponder];
}

#pragma mark - Touch Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (BOOL)isValidRegisterDetails{
    if(!_txtFirstName.text || [_txtFirstName.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterFirstName image:kErrorImage];
        return NO;
    }else if(!_txtLastName.text || [_txtLastName.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterLastName image:kErrorImage];
        return NO;
    }else if(!_txtUserName.text || [_txtUserName.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterName image:kErrorImage];
        return NO;
    }else if(!_txtEmail.text || [_txtEmail.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterEmail image:kErrorImage];
        return NO;
    }else if(!_txtPassword.text || [_txtPassword.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterPassword image:kErrorImage];
        return NO;
    }else if(!_txtConfirmPassword.text || [_txtConfirmPassword.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterConfirmPass image:kErrorImage];
        return NO;
    }else if(!_txtDOB.text || [_txtDOB.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterDOB image:kErrorImage];
        return NO;
    }
    
    if(![_txtEmail.text isValidEmail]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterValidEmail image:kErrorImage];
        return NO;
    }
    
    if(![_txtPassword.text isEqualToString:_txtConfirmPassword.text]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgConfirmPassNotMatch image:kErrorImage];
        return NO;
    }
    
    return YES;
}

@end
