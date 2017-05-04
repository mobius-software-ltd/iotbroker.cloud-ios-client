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
    
    [self setDelegateForViewControllers];
    [self initializeConnection];
}

- (void) initializeConnection {

    Account *account = [self->_accountManager readDefaultAccount];
    if (account != nil) {
        if (account.protocol == IBMqttProtocolType) {
            self->_requests = [[IBMQTT alloc] initWithHost:account.serverHost port:account.port andResponseDelegate:self];
        } else if (account.protocol == IBMqttSNProtocolType) {
            self->_requests = [[IBMQTTSN alloc] initWithHost:account.serverHost port:account.port andResponseDelegate:self];
        }
        [self->_requests prepareToSendingRequest];
        [self showProgressWithMessage:@"Connection..."];
    }
}

#pragma mark - Private methods -

- (void) setDelegateForViewControllers {
    for (UIViewController *item in [self viewControllers]) {
        if ([item isKindOfClass:[IBTopicsListTableViewController class]]) {
            ((IBTopicsListTableViewController *)item).delegate = self;
        } else if ([item isKindOfClass:[IBSendMessageTableViewController class]]) {
            ((IBSendMessageTableViewController *)item).delegate = self;
        } else if ([item isKindOfClass:[IBMessagesListTableViewController class]]) {
            ((IBMessagesListTableViewController *)item).delegate = self;
        }
    }
}

- (void) showProgressWithMessage : (NSString *) message {
    self->_progressHUD = [self.tabBarDelegate getPreparedProgressHUD];
    self->_progressHUD.parentController = self;
    [self->_progressHUD showWithMessage:message];
}

- (void) closeProgress {
    [self->_progressHUD close];
}

- (IBTopicsListTableViewController *) topicsListTableViewController {
    for (UIViewController *item in [self viewControllers]) {
        if ([item isKindOfClass:[IBTopicsListTableViewController class]]) {
            return (IBTopicsListTableViewController *)item;
        }
    }
    return nil;
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
    [self->_requests unsubscribeFromTopic:topic];
    [self showProgressWithMessage:@"Unsubscription..."];
}

#pragma mark - IBAddTopicDelegate -

- (void) addTopicViewControllerClickOnAddButton : (IBAddTopicViewController *) controller {
    Topic *topic = [self->_accountManager topic];
    topic.topicName = controller.topicName;
    topic.qos = (int32_t)controller.qosValue;
    [self->_requests subscribeToTopic:topic];
    self->_progressHUD = [self.tabBarDelegate getPreparedProgressHUD];
    self->_progressHUD.parentController = self;
    [self showProgressWithMessage:@"Subscription..."];
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
        Message *message = [self->_accountManager message];
        message.topicName = name;
        message.qos = (int32_t)qos;
        message.content = content;
        message.isDup = dup;
        message.isRetain = retainFlag;
        message.isIncoming = false;
        [self->_accountManager addMessageForDefaultAccount:message];
    }
}

- (void) pubackForPublishWithTopicName : (NSString *) name qos : (NSInteger) qos content : (NSData *) content dup : (BOOL) dup retainFlag : (BOOL) retainFlag andReturnCode : (NSInteger) returnCode {
    [self closeProgress];

    Message *message = [self->_accountManager message];
    message.topicName = name;
    message.qos = (int32_t)qos;
    message.content = content;
    message.isDup = dup;
    message.isRetain = retainFlag;
    message.isIncoming = false;
    [self->_accountManager addMessageForDefaultAccount:message];
    IBAlertViewController *alert = [IBAlertViewController alertControllerWithTitle:@"Perfect" message:@"Message has been sending" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert pushToNavigationControllerStack:self.navigationController];
}

- (void) pubrecForPublishWithTopicName : (NSString *) name qos : (NSInteger) qos content : (NSData *) content dup : (BOOL) dup retainFlag : (BOOL) retainFlag {

}

- (void) pubrelForPublishWithTopicName : (NSString *) name qos : (NSInteger) qos content : (NSData *) content dup : (BOOL) dup retainFlag : (BOOL) retainFlag {
    [self closeProgress];

    Message *message = [self->_accountManager message];
    message.topicName = name;
    message.qos = (int32_t)qos;
    message.content = content;
    message.isDup = dup;
    message.isRetain = retainFlag;
    message.isIncoming = true;
    [self->_accountManager addMessageForDefaultAccount:message];
}

- (void) pubcompForPublishWithTopicName : (NSString *) name qos : (NSInteger) qos content : (NSData *) content dup : (BOOL) dup retainFlag : (BOOL) retainFlag {
    [self closeProgress];

    Message *message = [self->_accountManager message];
    message.topicName = name;
    message.qos = (int32_t)qos;
    message.content = content;
    message.isDup = dup;
    message.isRetain = retainFlag;
    message.isIncoming = false;
    [self->_accountManager addMessageForDefaultAccount:message];
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
    
}

- (void) disconnectWithDuration : (NSInteger) duration {

}

- (void) error : (NSError *) error {
    NSLog(@"Error %@", error);
}

@end
