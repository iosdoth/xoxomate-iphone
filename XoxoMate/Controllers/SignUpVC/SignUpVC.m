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
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@end

@implementation SignUpVC

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
    if (app.isLogin) {
        self.btnBack.hidden = YES;
    }else{
        self.btnBack.hidden = NO;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *websiteUrl = [NSURL URLWithString:@"https://xoxomate.com/home.html"];
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
    if (app.isLogin) {
        [[self view] endEditing:TRUE];
        
        self.onlineUserList = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OnlineUserList"];
        UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:self.onlineUserList];
        navController.navigationBar.hidden = YES;
        
        //    self.onlineUserList.delegate = self;
        
        CGRect aRect = [[UIScreen mainScreen] bounds];
        
        [navController.view setFrame:(CGRect){0, 0, aRect.size.width, aRect.size.height-60}];
        
        [self addChildViewController:navController];
        [self.view addSubview:navController.view];
        [self didMoveToParentViewController:navController];
    }else{
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Please login first!!!" image:kErrorImage];
    }
}

- (IBAction)btnActiveUserTapped:(id)sender{
    //    __weak __typeof(self)weakSelf = self;
    //    __typeof(self) strongSelf = weakSelf;
    //    [strongSelf performSegueWithIdentifier:kGoToDialogsSegueIdentifier sender:nil];
    
    if (app.isLogin) {
        [[self view] endEditing:TRUE];
        
        self.activeUserList = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DialogsViewController"];
        UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:self.activeUserList];
        navController.navigationBar.hidden = YES;
        
        //    self.onlineUserList.delegate = self;
        
        CGRect aRect = [[UIScreen mainScreen] bounds];
        
        [navController.view setFrame:(CGRect){0, 0, aRect.size.width, aRect.size.height-60}];
        [self addChildViewController:navController];
        [self.view addSubview:navController.view];
        [self didMoveToParentViewController:navController];
        
    }else{
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"Please login first!!!" image:kErrorImage];
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
        
        // resetting last activity date
        [ServicesManager instance].lastActivityDate = nil;
        
        //    __weak __typeof(self)weakSelf = self;
        dispatch_group_notify(logoutGroup,dispatch_get_main_queue(),^{
            // logging out
            [[QMServicesManager instance] logoutWithCompletion:^{
                // [weakSelf performSegueWithIdentifier:@"kBackToLoginViewController" sender:nil];
                app.isLogin = NO;
                [self.navigationController popViewControllerAnimated:YES];
                [SVProgressHUD showSuccessWithStatus:@"Completed"];
            }];
        });
    }else{
        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"You are not logged in!!!" image:kErrorImage];
    }
}

@end
