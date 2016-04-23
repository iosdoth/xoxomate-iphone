//
//  SignUpVC.m
//  XoxoMate
//
//  Created by apple on 2016-04-11.
//  Copyright © 2016 doth. All rights reserved.
//

#import "SignUpVC.h"
#import "Constants.h"

@interface SignUpVC ()
{
    AppDelegate *app;
}

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) OnlineUserList *onlineUserList;
@property (strong, nonatomic) DialogsViewController *activeUserList;
@property (strong, nonatomic) ChatViewController *chatVC;

@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@end

@implementation SignUpVC

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

- (void)commonInit{
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.isLogin) {
        self.btnBack.hidden = YES;
    }else{
        self.btnBack.hidden = NO;
    }
    
    [self getWebViewData];
    
}

- (void)getWebViewData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *dict = @{
                                  }.mutableCopy;
    
    NSError *serr;
    
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&serr];
    
    if (serr){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        return;
    }
    NSString *strURL = [NSString stringWithFormat:@"https://xoxomate.com/api/Apis/get_details_by_username/%@.json",self.strUserName];
    
#define appService [NSURL URLWithString:strURL]
    
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
         if ([strErrorCode isEqualToString:@"1"]){
             [[TKAlertCenter defaultCenter] postAlertWithMessage:responseDict[@"response"][@"message"] image:kErrorImage];
         }else{
             NSLog(@"Response :: %@",responseDict);
              NSString *strSubcription = [NSString stringWithFormat:@"%@",responseDict[@"response"][@"result"][@"data"][@"no_subscription"]];
             [Helper addToNSUserDefaults:strSubcription forKey:@"isSubcription"];
             NSString *strURL;
             if ([strSubcription isEqualToString:@"1"]) {
                 strURL = @"https://xoxomate.com/demo/plan.html";
             }else{
                 strURL = @"https://xoxomate.com/demo/home.html";
             }
             [self loadURLInWebView:strURL];
         }
     }];
}

- (void)loadURLInWebView:(NSString *)strURL{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *websiteUrl = [NSURL URLWithString:strURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
    [self.webView loadRequest:urlRequest];
}

#pragma mark - UIWebView Delegate Method

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"Error :: %@",error.debugDescription);
}

#pragma mark - Button Click Event

- (IBAction)btnBackTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnOnlineUserTapped:(id)sender{

    if ([[Helper getFromNSUserDefaults:@"isSubcription"] isEqualToString:@"1"]) {
        [self getWebViewData];
    }else{
        for (UIViewController *aVC in _activeUserList.navigationController.viewControllers)
        {
            if ([aVC isKindOfClass:[ChatViewController class]])
            {
                [_activeUserList.navigationController popToViewController:self.activeUserList animated:NO];
            }
        }
        
        [_activeUserList removeFromParentViewController];
        [_activeUserList.view removeFromSuperview];
        [_activeUserList willMoveToParentViewController:nil];
        
        if (app.isLogin) {
            [[self view] endEditing:TRUE];
            
            self.onlineUserList = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OnlineUserList"];
            UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:self.onlineUserList];
            navController.navigationBar.hidden = YES;
            
            CGRect aRect = [[UIScreen mainScreen] bounds];
            
            [navController.view setFrame:(CGRect){0, 0, aRect.size.width, aRect.size.height-47}];
            
            [self addChildViewController:navController];
            [self.view addSubview:navController.view];
            [self didMoveToParentViewController:navController];
            
        }else{
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Please login first!!!" image:kErrorImage];
        }
    }

}

- (IBAction)btnActiveUserTapped:(id)sender{
    
    if ([[Helper getFromNSUserDefaults:@"isSubcription"] isEqualToString:@"1"]) {
        [self getWebViewData];
    }else{
        for (UIViewController *aVC in _onlineUserList.navigationController.viewControllers)
        {
            if ([aVC isKindOfClass:[ChatViewController class]])
            {
                [_onlineUserList.navigationController popToViewController:self.onlineUserList animated:NO];
            }
        }
        
        [_onlineUserList removeFromParentViewController];
        [_onlineUserList.view removeFromSuperview];
        [_onlineUserList willMoveToParentViewController:nil];
        
        if (app.isLogin) {
            [[self view] endEditing:TRUE];
            
            self.activeUserList = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DialogsViewController"];
            UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:self.activeUserList];
            navController.navigationBar.hidden = YES;
            
            CGRect aRect = [[UIScreen mainScreen] bounds];
            
            [navController.view setFrame:(CGRect){0, 0, aRect.size.width, aRect.size.height-47}];
            [self addChildViewController:navController];
            [self.view addSubview:navController.view];
            [self didMoveToParentViewController:navController];
            
        }else{
            [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Please login first!!!" image:kErrorImage];
        }
    }
}

- (IBAction)btnLogOutTapped:(id)sender{
    if (app.isLogin) {
        [SVProgressHUD showSuccessWithStatus:@"Logout..."];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        
        dispatch_group_t logoutGroup = dispatch_group_create();
        dispatch_group_enter(logoutGroup);
        // unsubscribing from pushes
        NSString *deviceIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [QBRequest unregisterSubscriptionForUniqueDeviceIdentifier:deviceIdentifier successBlock:^(QBResponse *response) {
            //
            dispatch_group_leave(logoutGroup);
        } errorBlock:^(QBError *error) {
            //
            dispatch_group_leave(logoutGroup);
        }];
        
        [ServicesManager instance].lastActivityDate = nil;
        
        dispatch_group_notify(logoutGroup,dispatch_get_main_queue(),^{
            
            [[QMServicesManager instance] logoutWithCompletion:^{
                [Helper addToNSUserDefaults:@"" forKey:@"SavePassword"];
                app.isLogin = NO;
                [self.navigationController popViewControllerAnimated:YES];
                
                NSURL *websiteUrl = [NSURL URLWithString:@"https://xoxomate.com/demo/appinterface.html?action=userlogout"];
                NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
                [self.webView loadRequest:urlRequest];
                
                [SVProgressHUD showSuccessWithStatus:@"Completed"];
            }];
        });
    }else{
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"You are not logged in!!!" image:kErrorImage];
    }
}

- (void)payment{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *dict = @{
                                  }.mutableCopy;
    
    NSError *serr;
    
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&serr];
    
    if (serr){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        return;
    }
    
#define appServiceRequest [NSURL URLWithString:@"https://xoxomate.com/api/Apis/check_payment_status/74.json"]
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:appServiceRequest];
    
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
         if ([strErrorCode isEqualToString:@"1"]){
             [[TKAlertCenter defaultCenter] postAlertWithMessage:responseDict[@"response"][@"message"] image:kErrorImage];
         }else{
              [[TKAlertCenter defaultCenter] postAlertWithMessage:responseDict[@"response"][@"result"][@"message"] image:kErrorImage];
             NSLog(@"Response :: %@",responseDict);
         }
     }];
}

@end
