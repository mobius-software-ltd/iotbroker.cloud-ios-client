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

#import "IBSendMessageTableViewController.h"
#import "IBPickerView.h"

@interface IBSendMessageTableViewController () <IBPickerViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UITextField *topicTextField;
@property (weak, nonatomic) IBOutlet UITextField *qosTextField;
@property (weak, nonatomic) IBOutlet UISwitch *retainSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *duplicateSwitch;

@end

@implementation IBSendMessageTableViewController
{
    IBPickerView *_qosPickerView;
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
    
    self->_qosPickerView = [[IBPickerView alloc] initWithFrame:CGRectZero];
    self->_qosPickerView.ibDelegate = self;
    
    [self->_qosPickerView setValues:@[@0, @1, @2]];
    [self.qosTextField setInputView:self->_qosPickerView];
    [self.qosTextField setInputAccessoryView:[IBPickerView toolbarWithTarget:self selector:@selector(doneButtonClicker)]];
    [self.delegate sendMessageTableViewControllerDidLoad:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"Send message";
    [self.delegate sendMessageTableViewControllerDidLoad:self];
}

- (void)doneButtonClicker {
    self.qosTextField.text = self.qosTextField.text.length == 0 ? @"0" : self.qosTextField.text;
    [self.qosTextField resignFirstResponder];
}

- (IBAction) sendButtonClick : (id) sender {
    
    self->_message.content = [self.contentTextField.text dataUsingEncoding:NSUTF8StringEncoding];
    self->_message.topicName = self.topicTextField.text;
    self->_message.qos = (int32_t)[self.qosTextField.text integerValue];
    self->_message.isIncoming = false;
    self->_message.isRetain = self.retainSwitch.isOn;
    self->_message.isDup = self.duplicateSwitch.isOn;
    
    if ([self.delegate sendMessageTableViewController:self didClickSendButtonWithMessage:self->_message] == true) {
        [self clearFields];
    }
}

- (void) clearFields {

    self.contentTextField.text = nil;
    self.topicTextField.text = nil;
    self.qosTextField.text = nil;
    self.retainSwitch.on = false;
    self.duplicateSwitch.on = false;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
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
    if (self.protocol == IBCoAPProtocolType) {
        return 2;
    }
    return 5;
}

@end
