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

//Live URL

#define BASE_URL                                @"https://xoxomate.com/api/Apis/"


#define kLogin                                  BASE_URL@"login.json"

#define kAppDelegate                            ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define kStoryboard                             [UIStoryboard storyboardWithName:@"Main" bundle:nil]

#define kErrorImage                             [UIImage imageNamed:@"error"]
#define kRightImage                             [UIImage imageNamed:@"right"]

#define kdeviceToken                            [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceTokenKey]

#define kUserInformation                        @"UserInformation"
#define kDeviceTokenKey                         @"DeviceToken"
#define kdeviceType                             @"2"

#define IPHONE4S                                [UIScreen mainScreen].bounds.size.height==480
#define IPHONE5S                                [UIScreen mainScreen].bounds.size.height==568
#define IPHONE6                                 [UIScreen mainScreen].bounds.size.height==667
#define IPHONE6PLUS                             [UIScreen mainScreen].bounds.size.height==736
#define IPAD                                    [UIScreen mainScreen].bounds.size.height==1024

#define msgEnterName                            @"Please enter username."
#define msgEnterPassword                        @"Please enter password."
#define msgEnterConfirmPass                     @"Please enter confirm pin."
#define msgEnterValidEmail                      @"Please enter a valid email address."
#define msgEnterValidPhoneNo                    @"Please enter valid phone number."
#define msgConfirmPassNotMatch                  @"Pin and confirm pin do not match."
#define msgEnterItemName                        @"Please enter item name."
#define msgSelectCategory                       @"Please select category."
#define msgSelectLendBy                         @"Please select lent by."
#define msgSelectBorrowedBy                     @"Please select borrowed by."
#define msgSelectReturnDate                     @"Please select return date."
#define msgDeleteTitle                          @"Delete"
#define msgDeleteDesc                           @"Are you sure you want to delete this photo?"
#define msgItemNotFound                         @"No items available."
#define msgFriendNotFound                       @"No friends available."
#define msgCategoryNotFound                     @"No categories available."
#define msgInternetSlow                         @"Internet connection is too slow or not connected. Please try again."
#define msgPinValidation                        @"Please enter 4 digit pin."
#define msgEnterValidPin                        @"Incorrect Pin. Please enter a valid pin."
#define msgDeleteItem                           @"Are you sure you want to delete this item?"

#endif
