//
//  LoginVC.m
//  XoxoMate
//
//  Created by apple on 2016-04-11.
//  Copyright © 2016 doth. All rights reserved.
//

#import "LoginVC.h"
#import "Constants.h"
#import "UsersDataSourceCall.h"

@interface LoginVC ()
{
    AppDelegate *app;
}

@property (strong, nonatomic) IBOutlet MSTextField *txtUserName;
@property (strong, nonatomic) IBOutlet MSTextField *txtPassword;
@property (strong, nonatomic) Settings *settings;

@property (strong, nonatomic) OnlineUserList *onlineUserList;
@property (strong, nonatomic) DialogsViewController *activeUserList;
@property (strong, nonatomic) SignUpVC *signUpVC;

@end

@implementation LoginVC

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.settings = Settings.instance;
}

#pragma mark - Button Tapped Event

- (IBAction)btnSignUpTapped:(id)sender{
    SignUpVC *signUp = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpVC"];
    [self.navigationController pushViewController:signUp animated:YES];
}

- (IBAction)btnLoginTapped:(id)sender{
    
    if ([self isValidLoginDetails]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSMutableDictionary *dict = @{
                                      @"username":_txtUserName.text,
                                      @"password":_txtPassword.text
                                      }.mutableCopy;
        
        NSError *serr;
        
        NSData *jsonData = [NSJSONSerialization
                            dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&serr];
        
        if (serr){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            NSLog(@"Error generating json data for send dictionary...");
            NSLog(@"Error (%@), error: %@", dict, serr);
            return;
        }
        
        NSLog(@"now sending this dictionary...\n%@\n\n\n", dict);
        
#define appService [NSURL URLWithString:@"https://xoxomate.com/api/Apis/login.json"]
        
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
                 NSLog(@"No data returned from server, error ocurred: %@", error);
                 [[TKAlertCenter defaultCenter] postAlertWithMessage:@"No data returned from server, error ocurred" image:kErrorImage];

                 return;
             }
             
             NSError *deserr;
             NSDictionary *responseDict = [NSJSONSerialization
                                           JSONObjectWithData:data
                                           options:kNilOptions
                                           error:&deserr];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             NSLog(@"The responseDict\n\n%@\n\n", responseDict);
             NSLog(@"ERROR CODE :: %@",responseDict[@"response"][@"error"]);
             NSString *strErrorCode = [NSString stringWithFormat:@"%@",responseDict[@"response"][@"error"]];
             [self resignFields];
             if ([strErrorCode isEqualToString:@"1"]){
                 [[TKAlertCenter defaultCenter] postAlertWithMessage:responseDict[@"response"][@"message"] image:kErrorImage];
             }else{
                 [self loginIntoApp:(NSUInteger)responseDict[@"response"][@"result"][@"data"][@"qb_id"]];
                 app.isLogin = YES;
             }
         }];
    }
}

#pragma mark - Login Into App

- (void)loginIntoApp:(NSUInteger)loginID{
//    __weak __typeof(self)weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    QBUUser *myUser = [[QBUUser alloc]init];
    myUser.login = _txtUserName.text;

    myUser.password = _txtPassword.text;
    
    [ServicesManager.instance logInWithUser:myUser completion:^(BOOL success, NSString *errorMessage) {
        if (success) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
           // [SVProgressHUD showSuccessWithStatus:@"Logged in"];
//            __typeof(self) strongSelf = weakSelf;
//            [strongSelf performSegueWithIdentifier:kGoToDialogsSegueIdentifier sender:nil];

            SignUpVC *signUp = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpVC"];
            [self.navigationController pushViewController:signUp animated:YES];

            [self logInChatWithUser:myUser];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
           // [SVProgressHUD showErrorWithStatus:@"Error"];
            NSLog(@"Error :: %@",errorMessage.debugDescription);
        }
    }];
}

- (QBUUser *)currentUser {
    return [QBSession currentSession].currentUser;
}

#pragma mark - UITextField Delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _txtPassword) {
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked:)];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
        textField.inputAccessoryView = keyboardDoneButtonView;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    return YES;
}

- (IBAction)doneClicked:(id)sender{
    [self.view endEditing:YES];
}

- (void)resignFields{
    [self.txtUserName resignFirstResponder];
    [self.txtPassword resignFirstResponder];
}

#pragma mark - Touch Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   [self.view endEditing:YES];
}

- (BOOL)isValidLoginDetails{
    if(!_txtUserName.text || [_txtUserName.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterName image:kErrorImage];
        return NO;
    }else if(!_txtPassword.text || [_txtPassword.text isEmptyString]){
        [[TKAlertCenter defaultCenter] postAlertWithMessage:msgEnterPassword image:kErrorImage];
        return NO;
    }
    return YES;
}

#pragma Login in chat

#define DEBUG_GUI 0

- (void)logInChatWithUser:(QBUUser *)user {
    
#if DEBUG_GUI
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    
#else
    
    [SVProgressHUD showWithStatus:@"Login chat"];
    
    __weak __typeof(self)weakSelf = self;
    [[ChatManager instance] logInWithUser:user completion:^(BOOL error) {
//        [UsersDataSourceCall.instance loadUsersWithList:self.settings.listType];
        if (!error) {
            
            [SVProgressHUD dismiss];
            [weakSelf applyConfiguration];
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"Login chat error!"];
        }
    } disconnectedBlock:^{
        [SVProgressHUD showWithStatus:@"Chat disconnected. Attempting to reconnect"];
        
    } reconnectedBlock:^{
        [SVProgressHUD showSuccessWithStatus:@"Chat reconnected"];
    }];
    
#endif
}

- (void)applyConfiguration {
    
    NSMutableArray *iceServers = [NSMutableArray array];
    
    for (NSString *url in self.settings.stunServers) {
        
        QBRTCICEServer *server = [QBRTCICEServer serverWithURL:url username:@"" password:@""];
        [iceServers addObject:server];
    }
    
    [iceServers addObjectsFromArray:[self quickbloxICE]];
    
    [QBRTCConfig setICEServers:iceServers];
    [QBRTCConfig setMediaStreamConfiguration:self.settings.mediaConfiguration];
    [QBRTCConfig setStatsReportTimeInterval:1.f];
}

- (NSArray *)quickbloxICE {
    
    NSString *password = @"baccb97ba2d92d71e26eb9886da5f1e0";
    NSString *userName = @"quickblox";
    
    QBRTCICEServer * stunServer = [QBRTCICEServer serverWithURL:@"stun:turn.quickblox.com"
                                                       username:@""
                                                       password:@""];
    
    QBRTCICEServer * turnUDPServer = [QBRTCICEServer serverWithURL:@"turn:turn.quickblox.com:3478?transport=udp"
                                                          username:userName
                                                          password:password];
    
    QBRTCICEServer * turnTCPServer = [QBRTCICEServer serverWithURL:@"turn:turn.quickblox.com:3478?transport=tcp"
                                                          username:userName
                                                          password:password];
    
    
    return@[stunServer, turnTCPServer, turnUDPServer];
}

@end
