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

#import "IBLoginTableViewController.h"

static NSInteger const IBRegustrationInfoSection = 0;
static NSInteger const IBSettingsSection = 1;

static NSString *const IBRegustrationInfoSectionTitle = @"Regustration info";
static NSString *const IBSettingsSectionTitle = @"Settings";

static NSString *const IBPattern = @"^(([0-9]{1}|[0-9]{2}|1[0-9][0-9]|2[0-5][0-5])\\.){3}([0-9]{1}|[0-9]{2}|1[0-9][0-9]|2[0-5][0-5])$";

static NSString *const IBLoginToMainSegue = @"IBLoginToMainSegue";

@interface IBLoginTableViewController ()

// regustration info

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *clientIDField;
@property (weak, nonatomic) IBOutlet UITextField *serverHostField;
@property (weak, nonatomic) IBOutlet UITextField *portField;

// settings

@property (weak, nonatomic) IBOutlet UISwitch *cleanSessionSwitch;
@property (weak, nonatomic) IBOutlet UITextField *keepaliveField;
@property (weak, nonatomic) IBOutlet UITextField *willField;
@property (weak, nonatomic) IBOutlet UITextField *willTopicField;
@property (weak, nonatomic) IBOutlet UISwitch *retainSwitch;
@property (weak, nonatomic) IBOutlet UITextField *qosTextField;

@end

@implementation IBLoginTableViewController
{
    IBPickerView *_qosPickerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = false;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.navigationController setNavigationBarHidden:false animated:true];
    
    self->_accountManager = [IBAccountManager getInstance];
    
    if ([self->_accountManager.coreDataManager getEntities:IBAccountEntity].count == 0) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
    }
    
    UIImage *image = [UIImage imageNamed:@"ImageBackground"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    UITableView *tableView = (UITableView *)self.view;
    tableView.backgroundView = imageView;
    
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    self.clientIDField.delegate = self;
    self.serverHostField.delegate = self;
    self.portField.delegate = self;
    self.keepaliveField.delegate = self;
    self.willField.delegate = self;
    self.willTopicField.delegate = self;
    self.qosTextField.delegate = self;
    
    self->_qosPickerView = [[IBPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 128, self.view.frame.size.width, 128)];
    self->_qosPickerView.ibDelegate = self;
    
    [self->_qosPickerView setValues:@[@0, @1, @2]];
    [self.qosTextField setInputView:self->_qosPickerView];
    
    self->_mqtt = [IBMQTT sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"Log In";
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return [self.usernameField resignFirstResponder] || [self.passwordField resignFirstResponder] || [self.clientIDField resignFirstResponder] || [self.serverHostField resignFirstResponder] || [self.portField resignFirstResponder] || [self.keepaliveField resignFirstResponder] || [self.willField resignFirstResponder] || [self.willTopicField resignFirstResponder] || [self.qosTextField resignFirstResponder];
}

- (BOOL) textField: (UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString: (NSString *)string {
    
    if ([theTextField isEqual:self.keepaliveField]) {
        return [self isTextIsNumeric:self.keepaliveField.text andString:string];
    } else if ([theTextField isEqual:self.portField] ) {
        return [self isTextIsNumeric:self.portField.text andString:string];
    } else {
        return true;
    }
    return false;
}

#pragma mark - IBPickerViewDelegate

- (void) pickerView:(IBPickerView *)view didSelectValue:(NSObject *)value {
    
    if ([view isEqual:self->_qosPickerView]) {
        NSString *string = [((NSNumber *)value) stringValue];
        self.qosTextField.text = string;
        [self.qosTextField resignFirstResponder];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == IBRegustrationInfoSection) {
        return 5;
    } else if (section == IBSettingsSection) {
        return 6;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.tableView.frame.size.width, 40)];
    label.textColor = [UIColor whiteColor];
    [label setFont:[UIFont boldSystemFontOfSize:12.f]];
    
    if (section == IBRegustrationInfoSection) {
        label.text = IBRegustrationInfoSectionTitle;
    } else if (section == IBSettingsSection) {
        label.text = IBSettingsSectionTitle;
    }
    
    [view addSubview:label];
    return view;
}

- (IBAction) loginButtonCLick : (id) sender {
    
    if ([sender isKindOfClass:[UIButton class]]) {
        
        Account *account = [self makeAccountFromInputData];
        
        self->_mqtt.delegate = self;
        self->_mqtt.connectDelegate = self;
        if ([self isNonEmptyFields] == true) {
            NSLog(@"- %i",account.qos);
            if ([self isHostValid:self.serverHostField.text] == true) {
                [self->_accountManager writeAccount:account];
                [self->_mqtt startWithHost:account.serverHost port:(NSInteger)account.port];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Host is incorrect" preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:okAction];
                if (self.presentedViewController == nil) {
                    [self presentViewController:alert animated:true completion:nil];
                }
            }
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please fill in all fields" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:okAction];
            if (self.presentedViewController == nil) {
                [self presentViewController:alert animated:true completion:nil];
            }
        }
    }
}

#pragma mark - IBMQTTDelegate

- (void) mqttDidOpen : (IBMQTT *) mqtt  {
    NSLog(@" >> Login : mqttDidOpen");
    
    Account *account = [self->_accountManager readDefaultAccount];
    if ([self->_mqtt connectWithAccount:account] == false) {
        self->_timer = [[IBMessageTimer alloc] initWithTimeInterval:3.0 connectTimerFor:self->_mqtt withAccount:account];
    }
}

- (void) mqttDidDisconnect : (IBMQTT *) mqtt {
    
    if ([mqtt isEqual:self->_mqtt]) {
        NSLog(@" >> Login : mqttDidDisconnect");
        
        if (self->_timer != nil) {
            [self->_timer stop];
        }
    }
}

- (void) mqtt : (IBMQTT *) mqtt didFailWithError : (NSError *)error {
    if ([mqtt isEqual:self->_mqtt]) {
        NSLog(@" >> Login : didFailWithError %@", error);
        
        if (self->_timer != nil) {
            [self->_timer stop];
        }
    }
}

#pragma mark - IBMQTTConnectionMessageDelegate

- (void) connectionAcknowledgmentReceivedWithCode:(IBConnectReturnCode)code andSessionPresent:(BOOL)sessionPresent {
    
    [self->_timer stop];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:IBLoginToMainSegue sender:self];
    });
}

- (Account *) makeAccountFromInputData {
    
    Account *account = (Account *)[self->_accountManager.coreDataManager entity:IBAccountEntity];
    
    account.username        = self.usernameField.text;
    account.password        = self.passwordField.text;
    account.clientID        = self.clientIDField.text;
    account.serverHost      = self.serverHostField.text;
    account.port            = [self.portField.text intValue];
    account.cleanSession    = self.cleanSessionSwitch.isOn;
    account.keepalive       = [self.keepaliveField.text intValue];
    account.will            = self.willField.text;
    account.willTopic       = self.willTopicField.text;
    account.isRetain        = self.retainSwitch.isOn;
    account.qos             = [self.qosTextField.text intValue];
    account.isDefault       = true;
    return account;
}

- (void) fillFieldsByUserDataWithUsername : (NSString *) name {
    
    if (name != nil) {
        
        Account *account = [self->_accountManager accountByUsername:name];
        
        if (account != nil) {
            
            self.usernameField.text     = account.username;
            self.passwordField.text     = account.password;
            self.clientIDField.text     = account.clientID;
            self.serverHostField.text   = account.serverHost;
            self.portField.text         = [@(account.port) stringValue];
            self.cleanSessionSwitch.on  = account.cleanSession;
            self.keepaliveField.text    = [@(account.keepalive) stringValue];
            self.willField.text         = account.will;
            self.willTopicField.text    = account.willTopic;
            self.retainSwitch.on        = account.isRetain;
            self.qosTextField.text      = [@(account.qos) stringValue];
            
        } else {
            
            self.usernameField.text     = nil;
            self.passwordField.text     = nil;
            self.clientIDField.text     = nil;
            self.serverHostField.text   = nil;
            self.portField.text         = nil;
            self.cleanSessionSwitch.on  = false;
            self.keepaliveField.text    = nil;
            self.willField.text         = nil;
            self.willTopicField.text    = nil;
            self.retainSwitch.on        = false;
            self.qosTextField.text      = nil;
        }
    }
}

- (BOOL) isNonEmptyFields {

    if (self.usernameField.text.length == 0 || self.passwordField.text.length == 0 || self.clientIDField.text.length == 0 || self.portField.text.length == 0 || self.keepaliveField.text.length == 0 || self.willField.text.length == 0 || self.willTopicField.text.length == 0) {
        return false;
    }
    return true;
}

- (BOOL) isHostValid : (NSString *) host  {
    
    NSString *string = host;
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:IBPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger count = [regexp numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    if (count == 1) {
        return true;
    } else {
        return false;
    }
}

- (BOOL) isTextIsNumeric : (NSString *) text andString : (NSString *) string {
    
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
    
    NSString * newString = [NSString stringWithFormat:@"%@%@", text, string];
    NSNumber * number = [numberFormatter numberFromString:newString];
    
    if (number) {
        return true;
    } else {
        return false;
    }
}

@end
