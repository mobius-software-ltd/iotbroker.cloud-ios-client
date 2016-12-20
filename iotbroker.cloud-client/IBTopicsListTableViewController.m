/**
 * Mobius Software LTD
 * Copyright 2015-2016, Mobius Software LTD
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

#import "IBTopicsListTableViewController.h"

static NSString *const IBAddTopicPopover = @"IBAddTopicPopover";

@interface IBTopicsListTableViewController ()

@end

@implementation IBTopicsListTableViewController
{
    IBAddTopicViewController *_popoverViewController;
    UITextField *_alertTopicNameTextField;
    UITextField *_alertQosTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self->_qosPickerView = [[IBPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 128, self.tableView.frame.size.width, 128)];
    self->_qosPickerView.ibDelegate = self;
    [self->_qosPickerView setValues:@[@0, @1, @2]];

    self->_mqtt = [IBMQTT sharedInstance];
    self->_mqtt.delegate = self;
    self->_mqtt.subscribeDelegate = self;
    
    self->_accountManager = [IBAccountManager getInstance];
    
    self->_topics = [NSMutableArray array];
    
    NSArray *topicsFromDatabase = [self->_accountManager getTopicsForCurrentAccount];
    if (topicsFromDatabase != nil) {
        self->_topics = [NSMutableArray arrayWithArray:topicsFromDatabase];
    }
    
    UIImage *image = [UIImage imageNamed:@"ImageBackground"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    UITableView *tableView = (UITableView *)self.view;
    tableView.backgroundView = imageView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"Topics list";
}

- (void) deleteTopics : (NSArray *) arrayOfTopics {

    NSMutableArray *toDelete = [NSMutableArray array];
    
    for (IBTopic *itemTopic in self->_topics) {
        for (NSString *itemTopicName in arrayOfTopics) {
            if ([itemTopic.name isEqualToString:itemTopicName]) {
                [toDelete addObject:itemTopic];
            }
        }
    }
    [self->_topics removeObjectsInArray:toDelete];
}

#pragma mark - IBPickerViewDelegate

- (void) pickerView:(IBPickerView *)view didSelectValue:(NSObject *)value {

    if (self->_alertQosTextField != nil) {
        self->_alertQosTextField.text = [((NSNumber *)value) stringValue];
        [self->_alertQosTextField resignFirstResponder];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self->_topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IBTopicsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    IBTopic *item = [self->_topics objectAtIndex:indexPath.row];
    cell.topicNameLabel.text = item.name;
    cell.qosLabel.text = [@([item.qos getValue]) stringValue];
    
    return cell;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSString *topicName = [self->_topics objectAtIndex:indexPath.row].name;
        if ([self->_mqtt unsubscribeFromTopics:@[topicName]] == false) {
            self->_unsubTimer = [[IBMessageTimer alloc] initWithTimeInterval:3.0 message:IBUnsubscribeMessage timerFor:self->_mqtt withUserInfo:@[topicName]];
        }
    }];
    delete.backgroundColor = [UIColor grayColor]; //arbitrary color
    
    return @[delete];
}

#pragma mark - UIPopoverPresentationControllerDelegate

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

#pragma mark - IBAddTopicDelegate

- (void)topic:(NSString *)topic andQosValue:(NSInteger)valueToAdd {
    
    if (self->_popoverViewController != nil) {
        [self->_popoverViewController dismissViewControllerAnimated:true completion:^{
            IBQoS *qos = [[IBQoS alloc] initWithValue:valueToAdd];
            IBTopic *topicItem = [[IBTopic alloc] initWithName:topic andQoS:qos];
            if ([self->_mqtt subscribeToTopics:@[topicItem]] == false) {
                self->_subTimer = [[IBMessageTimer alloc] initWithTimeInterval:3.0 message:IBSubscribeMessage timerFor:self->_mqtt withUserInfo:@[topicItem]];
            }
        }];
    }
}

#pragma mark - IBMQTTDelegate

- (void) mqttDidDisconnect : (IBMQTT *) mqtt {
    if (self->_subTimer != nil) {
        [self->_subTimer stop];
    }
    if (self->_unsubTimer != nil) {
        [self->_unsubTimer stop];
    }
}

- (void) mqtt : (IBMQTT *) mqtt didFailWithError : (NSError *)error {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    if (self.presentedViewController == nil) {
        [self presentViewController:alert animated:true completion:nil];
    }
}

#pragma mark - IBMQTTSubscribeMessageDelegate

- (void) subscribeAcknowledgmentReceivedWithPacketID:(NSInteger)packetID andSubscribe:(IBSubscribe *)subscribe {
    [self->_subTimer stop];
    
    for (IBTopic *item in subscribe.topics) {
        [self->_accountManager addTopicToCurrentAccount:item];
    }
    
    [self->_topics addObjectsFromArray:subscribe.topics];
    [self.tableView reloadData];
    
}

- (void) usubscribeAcknowledgmentReceivedWithPacketID : (NSInteger) packetID fromTopics:(NSArray<NSString *> *)topics {
    [self->_unsubTimer stop];
    
    for (NSString *item in topics) {
        [self->_accountManager deleteTopicByTopicName:item];
    }
    
    [self deleteTopics:topics];
    [self.tableView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:IBAddTopicPopover]) {
        self->_popoverViewController = [segue destinationViewController];
        self->_popoverViewController.delegate = self;
        self->_popoverViewController.preferredContentSize = CGSizeMake(self.view.frame.size.width, 200);
        if ([self->_popoverViewController popoverPresentationController] != nil) {
            UIPopoverPresentationController *popover = [self->_popoverViewController popoverPresentationController];
            popover.delegate = self;
            
        }
    }
}

@end
