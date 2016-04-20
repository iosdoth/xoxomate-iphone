////
//  SecondViewController.m
//  sample-chat
//
//  Created by Igor Khomenko on 10/16/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import "DialogsViewController.h"
#import "Constants.h"
#import "CallViewController.h"
#import "ChatManager.h"
#import "CheckUserTableViewCell.h"
#import "IncomingCallViewController.h"
#import "QMSoundManager.h"
#import "SVProgressHUD.h"
#import "UsersDataSourceCall.h"

@interface DialogsViewController ()
<
QMChatServiceDelegate,
QMAuthServiceDelegate,
QMChatConnectionDelegate,
QBRTCClientDelegate,
IncomingCallViewControllerDelegate
>

@property (nonatomic, strong) id <NSObject> observerDidBecomeActive;
@property (nonatomic, readonly) NSArray* dialogs;
@property (strong, nonatomic) UINavigationController *nav;
@property (weak, nonatomic) QBRTCSession *currentSession;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DialogsViewController

- (void)viewDidLoad {
    [super awakeFromNib];
    [QBRTCClient.instance addDelegate:self];
    
    // calling awakeFromNib due to viewDidLoad not being called by instantiateViewControllerWithIdentifier
    [ServicesManager.instance.chatService addDelegate:self];
    self.observerDidBecomeActive = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue]usingBlock:^(NSNotification *note) {
        if (![[QBChat instance] isConnected]) {
            [SVProgressHUD showSuccessWithStatus:@"Connecting to chat..."];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        }
    }];
    
    if ([QBChat instance].isConnected) {
        [self loadDialogs];
    }
     self.navigationItem.title = [ServicesManager instance].currentUser.login;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
   
	[self.tableView reloadData];
}

#pragma mark - Button Click Event

- (IBAction)btnBackTapped:(id)sender{
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
    [self willMoveToParentViewController:nil]; 
}

- (IBAction)logoutButtonPressed:(UIButton *)sender
{
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
    
    __weak __typeof(self)weakSelf = self;
    dispatch_group_notify(logoutGroup,dispatch_get_main_queue(),^{
        // logging out
        [[QMServicesManager instance] logoutWithCompletion:^{
            [weakSelf performSegueWithIdentifier:@"kBackToLoginViewController" sender:nil];
            [SVProgressHUD showSuccessWithStatus:@"Completed"];
        }];
    });
}

- (void)loadDialogs
{
    __weak __typeof(self) weakSelf = self;
    if ([ServicesManager instance].lastActivityDate != nil) {
        [[ServicesManager instance].chatService fetchDialogsUpdatedFromDate:[ServicesManager instance].lastActivityDate andPageLimit:kDialogsPageLimit iterationBlock:^(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs, BOOL *stop) {
            //
            __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.tableView reloadData];
        } completionBlock:^(QBResponse *response) {
            //
            if ([ServicesManager instance].isAuthorized && response.success) {
                [ServicesManager instance].lastActivityDate = [NSDate date];
            }
        }];
    }
    else {
        [SVProgressHUD showSuccessWithStatus:@"Loading dialogs"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        
        [[ServicesManager instance].chatService allDialogsWithPageLimit:kDialogsPageLimit extendedRequest:nil iterationBlock:^(QBResponse *response, NSArray *dialogObjects, NSSet *dialogsUsersIDs, BOOL *stop) {
            __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.tableView reloadData];
        } completion:^(QBResponse *response) {
            if ([ServicesManager instance].isAuthorized) {
                if (response.success) {
                    [SVProgressHUD showSuccessWithStatus:@"Completed"];
                    [ServicesManager instance].lastActivityDate = [NSDate date];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"Failed to load dialogs"];
                }
            }
        }];
    }
}

- (NSArray *)dialogs
{
    // Retrieving dialogs sorted by updatedAt date from memory storage.
	return [ServicesManager.instance.chatService.dialogsMemoryStorage dialogsSortByUpdatedAtWithAscending:NO];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.dialogs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DialogTableViewCell *cell = (DialogTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"ChatRoomCellIdentifier"];
    
    QBChatDialog *chatDialog = self.dialogs[indexPath.row];
    
    switch (chatDialog.type) {
        case QBChatDialogTypePrivate: {
//            cell.lastMessageTextLabel.text = chatDialog.lastMessageText;
//			QBUUser *recipient = [[ServicesManager instance].usersService.usersMemoryStorage userWithID:chatDialog.recipientID];
//            

//          cell.dialogNameLabel.text = recipient.login == nil ? (recipient.fullName == nil ? [NSString stringWithFormat:@"%lu", (unsigned long)recipient.ID] : recipient.fullName) : recipient.login;
//            
//            cell.dialogImageView.image = [UIImage imageNamed:@"chatRoomIcon"];
            
            cell.lastMessageTextLabel.text = chatDialog.lastMessageText;
            cell.dialogNameLabel.text = chatDialog.name;
            cell.dialogImageView.image = [UIImage imageNamed:@"placeholder_regular"];
        }
            break;
        case QBChatDialogTypeGroup: {
            cell.lastMessageTextLabel.text = chatDialog.lastMessageText;
            cell.dialogNameLabel.text = chatDialog.name;
            cell.dialogImageView.image = [UIImage imageNamed:@"GroupChatIcon"];
        }
            break;
        case QBChatDialogTypePublicGroup: {
            cell.lastMessageTextLabel.text = chatDialog.lastMessageText;
            cell.dialogNameLabel.text = chatDialog.name;
            cell.dialogImageView.image = [UIImage imageNamed:@"GroupChatIcon"];
        }
            break;
            
        default:
            break;
    }
    
    BOOL hasUnreadMessages = chatDialog.unreadMessagesCount > 0;
    cell.unreadContainerView.hidden = !hasUnreadMessages;
    if (hasUnreadMessages) {
        NSString* unreadText = nil;
        if (chatDialog.unreadMessagesCount > 99) {
            unreadText = @"99+";
        } else {
            unreadText = [NSString stringWithFormat:@"%lu", (unsigned long)chatDialog.unreadMessagesCount];
        }
        cell.unreadCountLabel.text = unreadText;
    } else {
        cell.unreadCountLabel.text = nil;
    }
	
    return cell;
}

- (void)deleteDialogWithID:(NSString *)dialogID {
	__weak __typeof(self) weakSelf = self;
    // Deleting dialog from Quickblox and cache.
	[ServicesManager.instance.chatService deleteDialogWithID:dialogID
                                                  completion:^(QBResponse *response) {
														if (response.success) {
															__typeof(self) strongSelf = weakSelf;
															[strongSelf.tableView reloadData];
															[SVProgressHUD dismiss];
														} else {
															[SVProgressHUD showErrorWithStatus:@"Error leaving"];
															NSLog(@"can not delete dialog: %@", response.error);
														}
                                                    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	QBChatDialog *dialog = self.dialogs[indexPath.row];

    ChatViewController* chatViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    chatViewController.dialog = dialog;
    [self.navigationController pushViewController:chatViewController animated:YES];
    
//    [self performSegueWithIdentifier:kGoToChatSegueIdentifier sender:dialog];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0f;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kGoToChatSegueIdentifier]) {
        ChatViewController* chatViewController = segue.destinationViewController;
        chatViewController.dialog = sender;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        QBChatDialog *chatDialog = self.dialogs[indexPath.row];

        // remove current user from occupants
        NSMutableArray *occupantsWithoutCurrentUser = [NSMutableArray array];
        for (NSNumber *identifier in chatDialog.occupantIDs) {
            if (![identifier isEqualToNumber:@(ServicesManager.instance.currentUser.ID)]) {
                [occupantsWithoutCurrentUser addObject:identifier];
            }
        }
        chatDialog.occupantIDs = [occupantsWithoutCurrentUser copy];
        
        [SVProgressHUD showSuccessWithStatus:@"Leaving..."];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        
        if (chatDialog.type == QBChatDialogTypeGroup) {
            NSString *notificationText = [NSString stringWithFormat:@"%@ %@", [ServicesManager instance].currentUser.login, @"has left dialog."];
            __weak __typeof(self) weakSelf = self;
            
            // Notifying user about updated dialog - user left it.
              [[ServicesManager instance].chatService sendNotificationMessageAboutLeavingDialog:chatDialog withNotificationText:notificationText completion:^(NSError * _Nullable error) {
                    [weakSelf deleteDialogWithID:chatDialog.ID];
              }];
        }
        else {
            [self deleteDialogWithID:chatDialog.ID];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Leave";
}

#pragma mark -
#pragma mark Chat Service Delegate

- (void)chatService:(QMChatService *)chatService didAddChatDialogsToMemoryStorage:(NSArray *)chatDialogs {
	[self.tableView reloadData];
}

- (void)chatService:(QMChatService *)chatService didAddChatDialogToMemoryStorage:(QBChatDialog *)chatDialog {
	[self.tableView reloadData];
}

- (void)chatService:(QMChatService *)chatService didUpdateChatDialogInMemoryStorage:(QBChatDialog *)chatDialog {
	[self.tableView reloadData];
}

- (void)chatService:(QMChatService *)chatService didUpdateChatDialogsInMemoryStorage:(NSArray *)dialogs {
    [self.tableView reloadData];
}

- (void)chatService:(QMChatService *)chatService didReceiveNotificationMessage:(QBChatMessage *)message createDialog:(QBChatDialog *)dialog {
	[self.tableView reloadData];
}

- (void)chatService:(QMChatService *)chatService didAddMessageToMemoryStorage:(QBChatMessage *)message forDialogID:(NSString *)dialogID {
    [self.tableView reloadData];
}

- (void)chatService:(QMChatService *)chatService didAddMessagesToMemoryStorage:(NSArray *)messages forDialogID:(NSString *)dialogID {
    [self.tableView reloadData];
}

- (void)chatService:(QMChatService *)chatService didDeleteChatDialogWithIDFromMemoryStorage:(NSString *)chatDialogID {
    [self.tableView reloadData];
}

#pragma mark - QMChatConnectionDelegate

- (void)chatServiceChatDidConnect:(QMChatService *)chatService
{
    [SVProgressHUD showSuccessWithStatus:@"Connected"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [self loadDialogs];
}

- (void)chatServiceChatDidReconnect:(QMChatService *)chatService
{
    [SVProgressHUD showSuccessWithStatus:@"Reconnected"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];

    [self loadDialogs];
}

- (void)chatServiceChatDidAccidentallyDisconnect:(QMChatService *)chatService
{
    [SVProgressHUD showErrorWithStatus:@"Disconnected"];
}

- (void)chatService:(QMChatService *)chatService chatDidNotConnectWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@ %@", @"Did not connect with error:", [error description]]];
}

- (void)chatServiceChatDidFailWithStreamError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@ %@", @"Chat failed with error:", [error description]]];
}

#pragma mark - QBWebRTCChatDelegate

- (void)didReceiveNewSession:(QBRTCSession *)session userInfo:(NSDictionary *)userInfo {
    
    if (self.currentSession) {
        
        [session rejectCall:@{@"reject" : @"busy"}];
        return;
    }
    
    self.currentSession = session;
    
    [QBRTCSoundRouter.instance initialize];
    
    NSParameterAssert(!self.nav);
    
    IncomingCallViewController *incomingViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"IncomingCallViewController"];
    incomingViewController.delegate = self;
    
    self.nav = [[UINavigationController alloc] initWithRootViewController:incomingViewController];
    
    incomingViewController.session = session;
    
    [self presentViewController:self.nav animated:NO completion:nil];
}

- (void)sessionDidClose:(QBRTCSession *)session {
    
    if (session == self.currentSession ) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.nav.view.userInteractionEnabled = NO;
            [self.nav dismissViewControllerAnimated:NO completion:nil];
            self.currentSession = nil;
            self.nav = nil;
        });
    }
}

#pragma mark - IncomingCall Delegate Methods

- (void)incomingCallViewController:(IncomingCallViewController *)vc didAcceptSession:(QBRTCSession *)session {
    
    CallViewController *callViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"CallViewController"];
    
//    QBRTCSession *session = [QBRTCClient.instance
//                             createNewSessionWithOpponents:@[@(receipentID.intValue)]
//                             withConferenceType:conferenceType];

    callViewController.session = session;
    callViewController.isIncoming = YES;
    
    self.nav.viewControllers = @[callViewController];
}

- (void)incomingCallViewController:(IncomingCallViewController *)vc didRejectSession:(QBRTCSession *)session {
    
    [session rejectCall:nil];
    [self.nav dismissViewControllerAnimated:NO completion:nil];
    self.nav = nil;
}

@end
