//
//  Constants.h
//  TMBomb
//
//  Created by Manish Dudharejia on 04/07/15.
//  Copyright (c) 2015 Manish Dudharejia. All rights reserved.
//
#ifndef TMBomb_Constants_h
#define TMBomb_Constants_h

#pragma mark - Import Files

#import "AppDelegate.h"
#import "RegisterVC.h"
#import "SignUpVC.h"
#import "LoginVC.h"
#import "DialogsViewController.h"
#import "ChatViewController.h"
#import "CallViewController.h"
#import "OnlineUserList.h"

#import "DialogTableViewCell.h"
#import "OnlineUserListCell.h"

#import <Quickblox/QBASession.h>
#import <QuickbloxWebRTC/QuickbloxWebRTC.h>

#import "ServicesManager.h"
#import "Settings.h"
#import "ChatManager.h"

#import "MSTextField.h"
#import "AFNetworking.h"
#import "WebClient.h"
#import "MBProgressHUD.h"
#import "TKAlertCenter.h"
#import <SVProgressHUD.h>
#import "IQKeyboardManager.h"
#import "Helper.h"

#pragma mark - WebServices

#define kDefaultErrorCode                       500

static const NSUInteger kDialogsPageLimit = 10;
static const NSUInteger kUsersLimit = 10;

static NSString *const kGoToDialogsSegueIdentifier = @"goToDialogs";
static NSString *const kGoToEditDialogSegueIdentifier = @"goToEditDialog";
static NSString *const kGoToAddOccupantsSegueIdentifier = @"goToAddOccupants";
static NSString *const kChatCacheNameKey = @"sample-cache";
static NSString *const kContactListCacheNameKey = @"sample-cache-contacts";
static NSString *const kLastActivityDateKey = @"last_activity_date";
static NSString *const kGoToChatSegueIdentifier = @"goToChat";
static NSString *const kUserTableViewCellIdentifier = @"UserTableViewCellIdentifier";
static NSString *const kPushNotificationDialogIdentifierKey = @"dialog_id";
static NSString *const kPushNotificationDialogMessageKey = @"message";

#define kAppDelegate                            ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define kStoryboard                             [UIStoryboard storyboardWithName:@"Main" bundle:nil]

#define kErrorImage                             [UIImage imageNamed:@"error"]
#define kRightImage                             [UIImage imageNamed:@"right"]

#define kdeviceToken                            [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceTokenKey]

#define kUserInformation                        @"UserInformation"
#define kDeviceTokenKey                         @"DeviceToken"
#define kdeviceType                             @"2"
#define kDateFormat                             @"yyyy-MM-dd"

#define IPHONE4S                                [UIScreen mainScreen].bounds.size.height==480
#define IPHONE5S                                [UIScreen mainScreen].bounds.size.height==568
#define IPHONE6                                 [UIScreen mainScreen].bounds.size.height==667
#define IPHONE6PLUS                             [UIScreen mainScreen].bounds.size.height==736
#define IPAD                                    [UIScreen mainScreen].bounds.size.height==1024

#define msgEnterFirstName                       @"Please enter firstname."
#define msgEnterLastName                        @"Please enter lastname."
#define msgEnterName                            @"Please enter username."
#define msgEnterEmail                           @"Please enter email address."
#define msgEnterPassword                        @"Please enter password."
#define msgEnterConfirmPass                     @"Please enter confirm password."
#define msgEnterDOB                             @"Please enter date of birth."
#define msgEnterValidEmail                      @"Please enter a valid email address."
#define msgConfirmPassNotMatch                  @"Password and confirm password do not match."

#endif
