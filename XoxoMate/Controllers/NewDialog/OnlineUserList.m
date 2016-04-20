//
//  OnlineUserList.m
//  Shipango
//
//  Created by apple on 2016-04-11.
//  Copyright © 2016 dotHSolution. All rights reserved.
//

#import "OnlineUserList.h"
#import <Quickblox/Quickblox.h>
#import "Constants.h"
#import "UsersDataSource.h"

@interface OnlineUserList ()

@property (strong, nonatomic) IBOutlet UITableView *tblList;
@property (strong, nonatomic) NSMutableArray *arrList;
@property (strong, nonatomic) UsersDataSource *dataSource;
@property (strong, nonatomic) QBUUser *user;

@end

@implementation OnlineUserList

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrList = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    filters[@"order"] = @"desc date last_request_at";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [QBRequest usersWithExtendedRequest:filters page:[QBGeneralResponsePage responsePageWithCurrentPage:1 perPage:10] successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *users) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        [_arrList addObjectsFromArray:users];
        [_arrList removeObjectAtIndex:0];
        [_tblList reloadData];
    } errorBlock:^(QBResponse *response) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Click Event

- (IBAction)btnBackTapped:(id)sender{
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
    [self willMoveToParentViewController:nil];
}

#pragma mark - UITableView Delegate Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *MyIdentifier = @"OnlineUserListCell";
    
    OnlineUserListCell *cell = (OnlineUserListCell *)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];

    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    }
   
    cell.lblName.text = [[_arrList objectAtIndex:indexPath.row ] valueForKey:@"login"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof(self) weakSelf = self;
    
    NSString *str = [NSString stringWithFormat:@"%@",[[_arrList objectAtIndex:indexPath.row ] valueForKey:@"ID"]];
    NSInteger myInt = [str integerValue];
    NSUInteger unsignedInt = (NSUInteger)myInt;
    
    [QBRequest userWithID:unsignedInt successBlock:^(QBResponse *response, QBUUser *user) {
        self.user = user;
        
        [self createChatWithName:nil completion:^(QBChatDialog *dialog) {
            __typeof(self) strongSelf = weakSelf;
            if( dialog != nil ) {
                [strongSelf navigateToChatViewControllerWithDialog:dialog];
            }
            else {
                NSLog(@"Can not create dialog");
                [SVProgressHUD showErrorWithStatus:@"Can not create dialog"];
            }
        }];
        
    } errorBlock:^(QBResponse *response) {
        NSLog(@"Response :: %@",response);
    }];
}

- (void)createChatWithName:(NSString *)name completion:(void(^)(QBChatDialog* dialog))completion
{
    NSMutableIndexSet* indexSet = [NSMutableIndexSet indexSet];
    [self.tblList.indexPathsForSelectedRows enumerateObjectsUsingBlock:^(NSIndexPath* obj, NSUInteger idx, BOOL *stop) {
        [indexSet addIndex:obj.row];
    }];
    
    [ServicesManager.instance.chatService createPrivateChatDialogWithOpponent:self.user completion:^(QBResponse *response, QBChatDialog *createdDialog) {
        if( !response.success  && createdDialog == nil ) {
            if (completion) completion(nil);
        }
        else {
            if (completion) completion(createdDialog);
        }
    }];
}

- (void)navigateToChatViewControllerWithDialog:(QBChatDialog *)dialog
{
    ChatViewController* chatViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
    chatViewController.dialog = dialog;
    [self.navigationController pushViewController:chatViewController animated:YES];

//    [self performSegueWithIdentifier:kGoToChatSegueIdentifier sender:dialog];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kGoToChatSegueIdentifier]) {
        ChatViewController* viewController = segue.destinationViewController;
        viewController.shouldUpdateNavigationStack = YES;
        viewController.dialog = sender;
    }
}

@end
