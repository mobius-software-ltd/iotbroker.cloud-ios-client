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

#import "IBSendMessageTableViewController.h"

@interface IBSendMessageTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UITextField *topicTextField;
@property (weak, nonatomic) IBOutlet UITextField *qosTextField;
@property (weak, nonatomic) IBOutlet UISwitch *retainSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *duplicateSwitch;

@end

@implementation IBSendMessageTableViewController
{
    NSMutableDictionary *_publishTopics;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"ImageBackground"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    UITableView *tableView = (UITableView *)self.view;
    tableView.backgroundView = imageView;
    
    self.contentTextField.delegate = self;
    self.topicTextField.delegate = self;
    self.qosTextField.delegate = self;
    
    self->_qosPickerView = [[IBPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 128, self.view.frame.size.width, 128)];
    self->_qosPickerView.ibDelegate = self;
    
    [self->_qosPickerView setValues:@[@0, @1, @2]];
    [self.qosTextField setInputView:self->_qosPickerView];
    
    self->_mqtt = [IBMQTT sharedInstance];
    self->_mqtt.delegate = self;
    self->_mqtt.publishOutDelegate = self;
    
    self->_publishTopics = [NSMutableDictionary dictionary];
    
    self->_accountManager = [IBAccountManager getInstance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"Send message";
}

- (IBAction) sendButtonClick : (id) sender {
    
    if ([self isNonEmptyFields] == true) {
    
        NSData *data = [self.contentTextField.text dataUsingEncoding:NSUTF8StringEncoding];
        
        IBQoS *qos = [[IBQoS alloc] initWithValue:self.qosTextField.text.integerValue];
        IBTopic *topic = [[IBTopic alloc] initWithName:self.topicTextField.text andQoS:qos];
        
        NSInteger packetID = 0;
        if ([qos getValue] != 0) {
            packetID = [self->_mqtt generateNextID];
        }
        
        IBPublish *publish = [[IBPublish alloc] initWithPacketID:packetID andTopic:topic andContent:data andIsRetain:self.retainSwitch.on andDup:self.duplicateSwitch.on];
        
        [self->_publishTopics setObject:publish forKey:@(packetID)];
        
        if ([self->_mqtt publish:publish] == false) {
            publish.dup = true;
            self->_publishTimer = [[IBMessageTimer alloc] initWithTimeInterval:3.0 message:IBPublishMessage timerFor:self->_mqtt withUserInfo:publish];
        }
        
    } else {
        [self showAlertWithTitle:@"Error" andMessage:@"Please fill in all fields"];
    }
}

- (BOOL) isNonEmptyFields {
    
    if (self.contentTextField.text.length == 0 || self.topicTextField.text.length == 0) {
        return false;
    }
    return true;
}

- (void) clearFields {

    self.contentTextField.text = nil;
    self.topicTextField.text = nil;
    self.qosTextField.text = nil;
    self.retainSwitch.on = false;
    self.duplicateSwitch.on = false;
}

- (void) showAlertWithTitle : (NSString *) title andMessage : (NSString *) message {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    if (self.presentedViewController == nil) {
        [self presentViewController:alert animated:true completion:nil];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return [self.contentTextField resignFirstResponder] || [self.topicTextField resignFirstResponder] || [self.qosTextField resignFirstResponder];
}

#pragma mark - IBPickerViewDelegate-

- (void)pickerView:(IBPickerView *)view didSelectValue:(NSObject *)value {

    NSString *string = [((NSNumber *)value) stringValue];
    self.qosTextField.text = string;
    [self.qosTextField resignFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

#pragma mark - IBMQTTDelegate

- (void) mqttDidDisconnect : (IBMQTT *) mqtt {
    if (self->_publishTimer != nil) {
        [self->_publishTimer stop];
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

#pragma mark - IBMQTTPublishOutMessageDelegate

- (void) publishAcknowledgmentReceivedWithPacketID : (NSInteger) packetID {
    if (self->_publishTimer != nil) {
        [self->_publishTimer stop];
    }
    IBPublish *publish = [self->_publishTopics objectForKey:@(packetID)];
    if (publish.dup != true) {
        [self->_accountManager addIncoming:false message:publish];
    }
    [self showAlertWithTitle:@"Message status" andMessage:@"Message has been sent"];
    [self clearFields];
}

- (void) publishReceivedWithPacketID : (NSInteger) packetID {
    if (self->_publishTimer != nil) {
        [self->_publishTimer stop];
    }
    
    if ([self->_mqtt pubrelWithPacketID:packetID] == false) {
        self->_publishTimer = [[IBMessageTimer alloc] initWithTimeInterval:3.0 message:IBPubrelMessage timerFor:self->_mqtt withUserInfo:@[[[IBPubrel alloc] initWithPacketID:packetID]]];
    }
}

- (void) publishCompleteReceivedWithPacketID : (NSInteger) packetID {
    if (self->_publishTimer != nil) {
        [self->_publishTimer stop];
    }
    IBPublish *publish = [self->_publishTopics objectForKey:@(packetID)];
    if (publish.dup != true) {
        [self->_accountManager addIncoming:false message:publish];
    }
    [self showAlertWithTitle:@"Message status" andMessage:@"Message has been sent"];
    [self clearFields];
}

@end
