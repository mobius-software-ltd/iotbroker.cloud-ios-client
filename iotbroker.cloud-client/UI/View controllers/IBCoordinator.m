/**
 * Mobius Software LTD
 * Copyright 2015-2017, Mobius Software LTD
 *
 * This is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 2.1 of
 * the License, or (at your option) any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this software; if not, write to the Free
 * Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA, or see the FSF site: http://www.fsf.org.
 */

#import "IBCoordinator.h"
#import "IBLoadingViewController.h"
#import "IBAccountListViewController.h"
#import "IBCertificateViewController.h"
#import "IBRootViewController.h"
#import "IBAlertViewController.h"
#import "IBAddTopicViewController.h"
#import "IBLoginViewController.h"
#import "IBTabBarController.h"
#import "IBAccountManager.h"
#import "IBProtocolTypeViewController.h"
#import "IBProgressHUDViewController.h"

static NSString *const IBLoadingIdentifier = @"IBLoadingViewControllerIdentifier";
static NSString *const IBRootIdentifier = @"IBRootViewControllerIdentifier";
static NSString *const IBAccountListIdentifier = @"IBAccountListViewControllerIdentifier";
static NSString *const IBCertificateIdentifier = @"IBCertificateViewControllerIdentifier";
static NSString *const IBAddTopicIdentifier = @"IBAddTopicViewControllerIdentifier";
static NSString *const IBLoginControllerIdentifier = @"IBLoginControllerIdentifier";
static NSString *const IBProtocolControllerIdentifier = @"IBProtocolTypeViewControllerIdentifier";
static NSString *const IBTabBarIdentifier = @"IBTabBarControllerIdentifier";
static NSString *const IBProgressHUDIdentifier = @"IBProgressHUDViewControllerIdentifier";

@interface IBCoordinator () <IBAccountListDelegate, IBLoginControllerDelegate, IBTabBarControllerDelegate, IBProtocolTypeViewControllerDelegate, IBCertificateControllerDelegate>

@property (strong, nonatomic) IBAccountManager *accountManager;

@end

@implementation IBCoordinator

#pragma mark - Initializers -

+ (instancetype) coordinatorWithNavigationController : (UINavigationController *) navigationController {
    return [[IBCoordinator alloc] initWithNavigationController:navigationController];
}

- (instancetype) initWithNavigationController : (UINavigationController *) navigationController {
    self = [super init];
    if (self != nil) {
        self->_navigationController = navigationController;
        self->_accountManager = [IBAccountManager getInstance];
    }
    return self;
}

#pragma mark - API's methods -

- (void)start {    
    IBLoadingViewController *loading = (IBLoadingViewController *)[self controllerWithIdentifier:IBLoadingIdentifier];
    [loading pushViewController:self->_navigationController animated:false withCompletionHandler:^(BOOL animated) {
        [self->_navigationController popViewControllerAnimated:animated];
        NSArray<Account *> *accounts = [self->_accountManager accounts];
        if (accounts.count > 0) {
            [self showAccountsControllerWithAccounts:accounts];
        } else {
            [self showLoginController];
        }
    }];
}

#pragma mark - Private methods -

- (UIViewController *) controllerWithIdentifier : (NSString *) identifier {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyboard instantiateViewControllerWithIdentifier:identifier];
}

- (UIViewController *) topViewController {
    return [self.navigationController topViewController];
}

- (void) showAccountsControllerWithAccounts : (NSArray<Account *> *) accountsArray {

    IBAccountListViewController *accounts = (IBAccountListViewController *)[self controllerWithIdentifier:IBAccountListIdentifier];
    accounts.delegate = self;
    accounts.accounts = accountsArray;
    UIViewController *controller = [self topViewController];

    [controller addChildViewController:accounts];
    accounts.view.frame = controller.view.bounds;
    [controller.view addSubview:accounts.view];
    [accounts didMoveToParentViewController:controller];
}

- (void) showLoginController {
    IBLoginViewController *login = (IBLoginViewController *)[self controllerWithIdentifier:IBLoginControllerIdentifier];
    login.delegate = self;
    login.account = [self->_accountManager account];
    login.backButton = ([self->_accountManager accounts].count > 0);
    [self->_navigationController pushViewController:login animated:true];
}

#pragma mark - IBAccountListDelegate -

- (void) accountListViewController:(IBAccountListViewController *)accountList didSelectedAccount:(Account *)account {

    [self->_accountManager setDefaultAccountWithClientID:account.clientID];
    IBTabBarController *tabBarController = (IBTabBarController *)[self controllerWithIdentifier:IBTabBarIdentifier];
    tabBarController.tabBarDelegate = self;
    tabBarController.accountManager = self->_accountManager;
    [self->_navigationController pushViewController:tabBarController animated:true];
}

- (void) accountListViewControllerDidClickToCreateNewAccount:(IBAccountListViewController *)accountList {
    [self showLoginController];
}

- (void)accountListViewController:(IBAccountListViewController *)accountList willRemoveAccount:(Account *)account {
    [self->_accountManager deleteAccount:account];
    [accountList setAccounts:[self->_accountManager accounts]];
}

#pragma mark - IBLoginControllerDelegate -

- (void)loginTableViewController:(IBLoginViewController *)loginTableViewController newAccountToAdd:(Account *)account {
    
    if ([account isValid] == true) {
        if ([self->_accountManager accountByClientID:account.clientID] != nil) {
            IBAlertViewController *alert = [IBAlertViewController alertControllerWithTitle:@"Attention" message:@"This client id have been already use" preferredStyle:UIAlertControllerStyleActionSheet];
            [alert pushToNavigationControllerStack:self->_navigationController];
            return;
        }
        if (![account isValidKeepaliveRange]) {
            IBAlertViewController *alert = [IBAlertViewController alertControllerWithTitle:@"Attention" message:@"Keepalive must be in the range [0, 65535]." preferredStyle:UIAlertControllerStyleActionSheet];
            [alert pushToNavigationControllerStack:self->_navigationController];
            return;
        }
        [self->_accountManager writeAccount:account];
        [self->_accountManager setDefaultAccountWithClientID:account.clientID];
        IBTabBarController *tabBarController = (IBTabBarController *)[self controllerWithIdentifier:IBTabBarIdentifier];
        tabBarController.tabBarDelegate = self;
        tabBarController.accountManager = self->_accountManager;
        [self->_navigationController pushViewController:tabBarController animated:true];
    } else {
        IBAlertViewController *alert = [IBAlertViewController alertControllerWithTitle:@"Attention" message:@"Some fields are empty or not valid" preferredStyle:UIAlertControllerStyleActionSheet];
        [alert pushToNavigationControllerStack:self->_navigationController];
    }
}

- (void)loginTableViewControllerBackButtonDidClick:(IBLoginViewController *)loginTableViewController {
    [self showAccountsControllerWithAccounts:[self->_accountManager accounts]];
}

- (void)loginTableViewControllerProtocolCellDidClick:(IBLoginViewController *)loginTableViewController {
    IBProtocolTypeViewController *protocolType = (IBProtocolTypeViewController *)[self controllerWithIdentifier:IBProtocolControllerIdentifier];
    protocolType.delegate = self;
    UIViewController *controller = [self topViewController];
    
    [controller addChildViewController:protocolType];
    protocolType.view.frame = controller.view.bounds;
    [controller.view addSubview:protocolType.view];
    [protocolType didMoveToParentViewController:controller];
}

- (void)loginTableViewControllerKeyFieldSelected:(IBLoginViewController *)loginTableViewController {
    IBCertificateViewController *controller = (IBCertificateViewController *)[self controllerWithIdentifier:IBCertificateIdentifier];
    controller.delegate = self;
    UIViewController *top = [self topViewController];
    
    [top addChildViewController:controller];
    controller.view.frame = top.view.bounds;
    [top.view addSubview:controller.view];
    [controller didMoveToParentViewController:top];
}

#pragma mark - IBCertificateControllerDelegate -

- (void) certificateViewControllerDidClickOkButton : (IBCertificateViewController *) certificateViewController {
    NSString *certificate = certificateViewController.certificate;
    NSLog(@"%@", certificate);
}

#pragma mark - IBProtocolTypeViewControllerDelegate -
    
- (void) protocolTypeViewController : (IBProtocolTypeViewController *) protocolTypeViewController didSelectProtocol : (IBProtocolsType) type {
    IBLoginViewController *login = (IBLoginViewController *)[self topViewController];
    [login setProtocolType:type];
}

#pragma mark - IBTabBarControllerDelegate -

- (IBAddTopicViewController *)showAddTopicViewControllerOnViewController:(UIViewController *)controller andSetDelegate:(id<IBAddTopicDelegate>)delegate {
    
    IBAddTopicViewController *addTopic = (IBAddTopicViewController *)[self controllerWithIdentifier:IBAddTopicIdentifier];
    addTopic.delegate = delegate;
    
    [controller addChildViewController:addTopic];
    addTopic.view.frame = controller.view.bounds;
    [controller.view addSubview:addTopic.view];
    [addTopic didMoveToParentViewController:controller];
    
    return addTopic;
}

- (void) tabBarControllerDidClickOnLogoutButton : (IBTabBarController *) controller {
    [self start];
}

- (IBProgressHUDViewController *)getPreparedProgressHUD {
    return (IBProgressHUDViewController *)[self controllerWithIdentifier:IBProgressHUDIdentifier];
}

@end
