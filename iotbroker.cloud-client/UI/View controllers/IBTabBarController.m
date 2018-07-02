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

#import "IBTabBarController.h"
#import "IBTopicsListTableViewController.h"
#import "IBSendMessageTableViewController.h"
#import "IBMessagesListTableViewController.h"
#import "IBAlertViewController.h"
#import "IBMQTT.h"
#import "IBMQTTSN.h"
#import "IBCoAP.h"
#import "IBAMQP.h"

@interface IBTabBarController () <IBTopicsListControllerDelegate, IBSendMessageControllerDelegate, IBAddTopicDelegate, IBMessagesControllerDelegate, IBResponsesDelegate>

@property (strong, nonatomic) id<IBRequests> requests;
@property (strong, nonatomic) IBProgressHUDViewController *progressHUD;
@end

@implementation IBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = false;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationItem.hidesBackButton = true;
    [self.navigationController setNavigationBarHidden:false animated:true];
        
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ImageLogout"] style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    [self.navigationItem setRightBarButtonItem:logoutButton];
    
    [self initializeConnection];
    [self setDelegateForViewControllers];
}

- (void) initializeConnection {
    
    Account *account = [self->_accountManager readDefaultAccount];
    
    if (account != nil) {
        
        NSInteger port = (NSInteger)account.port;
        NSString *host = account.serverHost;
                
        if (account.protocol == IBMqttProtocolType) {
            self->_requests = [[IBMQTT alloc] initWithHost:host port:port andResponseDelegate:self];
            [self->_requests secureWithCertificate:account.keyPath withPassword:account.keyPass];
        } else if (account.protocol == IBMqttSNProtocolType) {
            self->_requests = [[IBMQTTSN alloc] initWithHost:host port:port andResponseDelegate:self];
        } else if (account.protocol == IBCoAPProtocolType) {
            self->_requests = [[IBCoAP alloc] initWithHost:host port:port andResponseDelegate:self];
        } else if (account.protocol == IBAMQPProtocolType) {
            self->_requests = [[IBAMQP alloc] initWithHost:host port:port andResponseDelegate:self];
            [self->_requests secureWithCertificate:account.keyPath withPassword:account.keyPass];
        }
        [self showProgressWithMessage:@"Connection..."];
        [self->_requests prepareToSendingRequest];
    }
}

#pragma mark - Private methods -

- (void) setDelegateForViewControllers {
    
    Account *account = [self->_accountManager readDefaultAccount];
    for (UIViewController *item in [self viewControllers]) {
        if ([item isKindOfClass:[IBTopicsListTableViewController class]]) {
            ((IBTopicsListTableViewController *)item).delegate = self;
        } else if ([item isKindOfClass:[IBSendMessageTableViewController class]]) {
            ((IBSendMessageTableViewController *)item).delegate = self;
            ((IBSendMessageTableViewController *)item).protocol = account.protocol;
        } else if ([item isKindOfClass:[IBMessagesListTableViewController class]]) {
            ((IBMessagesListTableViewController *)item).delegate = self;
        }
    }
}

- (void) showProgressWithMessage : (NSString *) message {
    self->_progressHUD = [self.tabBarDelegate getPreparedProgressHUD];
    self->_progressHUD.parentController = self;
    [self->_progressHUD showWithMessage:message];
    for (UITabBarItem *item in self.tabBar.items) {
        [item setEnabled:false];
    }
}

- (void) closeProgress {
    [self->_progressHUD close];
    for (UITabBarItem *item in self.tabBar.items) {
        [item setEnabled:true];
    }
}

- (IBTopicsListTableViewController *) topicsListTableViewController {
    for (UIViewController *item in [self viewControllers]) {
        if ([item isKindOfClass:[IBTopicsListTableViewController class]]) {
            return (IBTopicsListTableViewController *)item;
        }
    }
    return nil;
}

- (void) addTopicName : (NSString *) name qos : (NSInteger) qos content : (NSData *) content isDup : (BOOL) isDup isRetain : (BOOL) isRetain isIncoming : (BOOL) isIncoming  {
    Message *message = [self->_accountManager message];
    message.topicName = name;
    message.qos = (int32_t)qos;
    message.content = content;
    message.isDup = (int)dup;
    message.isRetain = isRetain;
    message.isIncoming = isIncoming;
    [self->_accountManager addMessageForDefaultAccount:message];
}

- (void)logout {
    [self->_accountManager unselectDefaultAccount];
    [self->_requests disconnectWithDuration:0];
    [self.navigationController popToRootViewControllerAnimated:true];
    [self.tabBarDelegate tabBarControllerDidClickOnLogoutButton:self];
}

#pragma mark - IBTopicsListControllerDelegate -

- (void)topicsListTableViewControllerDidLoad:(IBTopicsListTableViewController *)topicsListTableViewController {
    topicsListTableViewController.topics = [self->_accountManager getTopicsForCurrentAccount];
}

- (void) topicsListTableViewControllerDidClickAddButton : (IBTopicsListTableViewController *) topicsListTableViewController {
    [self.tabBarDelegate showAddTopicViewControllerOnViewController:self andSetDelegate:self];
}

- (void) topicsListTableViewController : (IBTopicsListTableViewController *) topicsListTableViewController didClickDeleteButtonWithTopic : (Topic *) topic {
    [self showProgressWithMessage:@"Unsubscription..."];
    [self->_requests unsubscribeFromTopic:topic];
}

#pragma mark - IBAddTopicDelegate -

- (void) addTopicViewControllerClickOnAddButton : (IBAddTopicViewController *) controller {
    Topic *topic = [self->_accountManager topic];
    topic.topicName = controller.topicName;
    topic.qos = (int32_t)controller.qosValue;
    self->_progressHUD = [self.tabBarDelegate getPreparedProgressHUD];
    self->_progressHUD.parentController = self;
    [self showProgressWithMessage:@"Subscription..."];
    [self->_requests subscribeToTopic:topic];
}

#pragma mark - IBSendMessageControllerDelegate -

- (void)sendMessageTableViewControllerDidLoad:(IBSendMessageTableViewController *)sendMessageTableViewController {
    sendMessageTableViewController.message = [self->_accountManager message];
}

- (BOOL) sendMessageTableViewController : (IBSendMessageTableViewController *) sendMessageTableViewController didClickSendButtonWithMessage : (Message *) message {

    if ([message isValid] == true) {
        [self->_requests publishMessage:message];
        if (message.qos != IBAtMostOnce) {
            [self showProgressWithMessage:@"Publishion..."];
        }

        return true;
    } else {
        IBAlertViewController *alert = [IBAlertViewController alertControllerWithTitle:@"Attention" message:@"Please fill in all fields" preferredStyle:UIAlertControllerStyleActionSheet];
        [alert pushToNavigationControllerStack:self.navigationController];
    }
    return false;
}

#pragma mark - IBMessagesControllerDelegate -

- (void)messagesListTableViewControllerDidLoad:(IBMessagesListTableViewController *)messagesListTableViewController {
    [messagesListTableViewController setMessages:[self->_accountManager getMessagesForCurrentAccount]];
}

#pragma mark - IBResponsesDelegate -

- (void) ready {
    Account *account = [self->_accountManager readDefaultAccount];
    if (account != nil) {
        [self->_requests connectWithAccount:account];
    }
}

- (void) connackWithCode : (NSInteger) returnCode {
    if (returnCode == 0) {
        [self closeProgress];
    }
}

- (void) publishWithTopicName : (NSString *) name qos : (NSInteger) qos content : (NSData *) content dup : (BOOL) dup retainFlag : (BOOL) retainFlag {
    if (qos != IBExactlyOnce) {
        [self addTopicName:name qos:qos content:content isDup:dup isRetain:retainFlag isIncoming:true];
    }
}

- (void) pubackForPublishWithTopicName : (NSString *) name qos : (NSInteger) qos content : (NSData *) content dup : (BOOL) dup retainFlag : (BOOL) retainFlag andReturnCode : (NSInteger) returnCode {
    [self closeProgress];
    [self addTopicName:name qos:qos content:content isDup:dup isRetain:retainFlag isIncoming:false];

    IBAlertViewController *alert = [IBAlertViewController alertControllerWithTitle:@"Perfect" message:@"Message has been sending" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert pushToNavigationControllerStack:self.navigationController];
}

- (void) pubrecForPublishWithTopicName : (NSString *) name qos : (NSInteger) qos content : (NSData *) content dup : (BOOL) dup retainFlag : (BOOL) retainFlag {
    // Pubrec
}

- (void) pubrelForPublishWithTopicName : (NSString *) name qos : (NSInteger) qos content : (NSData *) content dup : (BOOL) dup retainFlag : (BOOL) retainFlag {
    [self closeProgress];
    [self addTopicName:name qos:qos content:content isDup:dup isRetain:retainFlag isIncoming:true];
}

- (void) pubcompForPublishWithTopicName : (NSString *) name qos : (NSInteger) qos content : (NSData *) content dup : (BOOL) dup retainFlag : (BOOL) retainFlag {
    [self closeProgress];
    [self addTopicName:name qos:qos content:content isDup:dup isRetain:retainFlag isIncoming:false];

    IBAlertViewController *alert = [IBAlertViewController alertControllerWithTitle:@"Perfect" message:@"Message has been sending" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert pushToNavigationControllerStack:self.navigationController];
}

- (void) subackForSubscribeWithTopicName:(NSString *)name qos:(NSInteger)qos returnCode:(NSInteger)returnCode {
    [self closeProgress];

    IBTopicsListTableViewController *topic = [self topicsListTableViewController];
    Topic *item = [self->_accountManager topic];
    item.topicName = name;
    item.qos = (int32_t)qos;
    [self->_accountManager addTopicToCurrentAccount:item];
    [topic setTopics:[self->_accountManager getTopicsForCurrentAccount]];
}

- (void) unsubackForUnsubscribeWithTopicName:(NSString *)name {
    [self closeProgress];
    
    IBTopicsListTableViewController *topic = [self topicsListTableViewController];
    [self->_accountManager deleteTopicByTopicName:name];
    topic.topics = [self->_accountManager getTopicsForCurrentAccount];
}

- (void) pingresp {
    // Pingresp
}

- (void) disconnectWithDuration : (NSInteger) duration {
    // Disconnect
}

- (void)timeout {
    [self closeProgress];
    [self logout];
    IBAlertViewController *alert = [IBAlertViewController alertControllerWithTitle:@"Attention" message:@"Timeout error" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert pushToNavigationControllerStack:self.navigationController];
}

- (void) error : (NSError *) error {
    NSLog(@"Error %@", error);
}

@end
