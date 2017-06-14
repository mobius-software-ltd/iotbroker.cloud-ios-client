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

#import "IBLoginViewController.h"
#import "IBLoginTableViewCell.h"
#import "IBPickerView.h"

static NSString *const IBMQTTLoginControllerIdentifier = @"IBMQTTLoginTableViewControllerIdentifier";
static NSString *const IBMQTTSNLoginControllerIdentifier = @"IBMQTTSNLoginTableViewControllerIdentifier";

static NSInteger const IBRegustrationInfoSection = 0;
static NSInteger const IBSettingsSection = 1;

static NSString *const IBRegustrationInfoSectionTitle = @"Regustration info";
static NSString *const IBSettingsSectionTitle = @"Settings";

static NSString *const IBProtocolCell       = @"protocolCell";
static NSString *const IBUsernameCell       = @"usernameCell";
static NSString *const IBPasswordCell       = @"passwordCell";
static NSString *const IBClientIDCell       = @"clientIDCell";
static NSString *const IBServerHostCell     = @"serverHostCell";
static NSString *const IBPortCell           = @"portCell";
static NSString *const IBCleanSessionCell   = @"cleanSessionCell";
static NSString *const IBKeepaliveCell      = @"keepaliveCell";
static NSString *const IBWillCell           = @"willCell";
static NSString *const IBWillTopicCell      = @"willTopicCell";
static NSString *const IBRetainCell         = @"retainCell";
static NSString *const IBQoSCell            = @"qosCell";

@interface IBLoginViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, IBPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *registerInfoSectionCells;
@property (strong, nonatomic) NSMutableArray *settingsSectionCells;

@property (strong, nonatomic) IBPickerView *qosPickerView;

// regustration info

@property (weak, nonatomic) UITextField *protocolField;
@property (weak, nonatomic) UITextField *usernameField;
@property (weak, nonatomic) UITextField *passwordField;
@property (weak, nonatomic) UITextField *clientIDField;
@property (weak, nonatomic) UITextField *serverHostField;
@property (weak, nonatomic) UITextField *portField;

// settings

@property (weak, nonatomic) UISwitch *cleanSessionSwitch;
@property (weak, nonatomic) UITextField *keepaliveField;
@property (weak, nonatomic) UITextField *willField;
@property (weak, nonatomic) UITextField *willTopicField;
@property (weak, nonatomic) UISwitch *retainSwitch;
@property (weak, nonatomic) UITextField *qosTextField;

@end

@implementation IBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = false;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.navigationController setNavigationBarHidden:false animated:true];
    
    UIImage *image = [UIImage imageNamed:@"ImageBackground"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];    
    self.tableView.backgroundView = imageView;
    
    if (self->_backButton == false) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
    }
    
    self->_qosPickerView = [[IBPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 128, self.view.frame.size.width, 128)];
    self->_qosPickerView.ibDelegate = self;
    
    [self->_qosPickerView setValues:@[@0, @1, @2]];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self setCellsArraysWithProtocolType:IBMqttProtocolType];
}

- (void) setCellsArraysWithProtocolType : (IBProtocolsType) type {

    IBProtocolTypeEnum *protocolType = [[IBProtocolTypeEnum alloc] init];
    protocolType.type = type;
    
    self->_registerInfoSectionCells = [NSMutableArray array];
    [self->_registerInfoSectionCells addObject:IBProtocolCell];
    
    if (type == IBMqttProtocolType) {
        [self->_registerInfoSectionCells addObject:IBUsernameCell];
        [self->_registerInfoSectionCells addObject:IBPasswordCell];
        [self->_registerInfoSectionCells addObject:IBClientIDCell];
        [self->_registerInfoSectionCells addObject:IBServerHostCell];
        [self->_registerInfoSectionCells addObject:IBPortCell];
        self->_settingsSectionCells = [NSMutableArray array];
        [self->_settingsSectionCells addObject:IBCleanSessionCell];
        [self->_settingsSectionCells addObject:IBKeepaliveCell];
        [self->_settingsSectionCells addObject:IBWillCell];
        [self->_settingsSectionCells addObject:IBWillTopicCell];
        [self->_settingsSectionCells addObject:IBRetainCell];
        [self->_settingsSectionCells addObject:IBQoSCell];
    } else if (type == IBMqttSNProtocolType) {
        [self->_registerInfoSectionCells addObject:IBClientIDCell];
        [self->_registerInfoSectionCells addObject:IBServerHostCell];
        [self->_registerInfoSectionCells addObject:IBPortCell];
        self->_settingsSectionCells = [NSMutableArray array];
        [self->_settingsSectionCells addObject:IBCleanSessionCell];
        [self->_settingsSectionCells addObject:IBKeepaliveCell];
        [self->_settingsSectionCells addObject:IBRetainCell];
        [self->_settingsSectionCells addObject:IBQoSCell];
    } else if (type == IBCoAPProtocolType) {
        [self->_registerInfoSectionCells addObject:IBServerHostCell];
        [self->_registerInfoSectionCells addObject:IBPortCell];
        self->_settingsSectionCells = nil;
    } else if (type == IBAMQPProtocolType) {
        self->_settingsSectionCells = nil;
    }
    self.protocolField.text = [protocolType nameByValue];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"Log In";
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.isMovingFromParentViewController) {
        [self.delegate loginTableViewControllerBackButtonDidClick:self];
    }
}

- (void) setProtocolType : (IBProtocolsType) type {
    [self setCellsArraysWithProtocolType:type];
    [self.tableView reloadData];
}

- (IBAction) addButtonDidClick : (id) sender {

    IBProtocolTypeEnum *type = [[IBProtocolTypeEnum alloc] init];
        
    self->_account.protocol = [type valueByName:self.protocolField.text];
    self->_account.username = self.usernameField.text;
    self->_account.password = self.passwordField.text;
    self->_account.clientID = self.clientIDField.text;
    self->_account.serverHost = self.serverHostField.text;
    self->_account.port = [self.portField.text integerValue];
    self->_account.cleanSession = self.cleanSessionSwitch.isOn;
    self->_account.keepalive = (int32_t)[self.keepaliveField.text integerValue];
    self->_account.will = self.willField.text;
    self->_account.willTopic = self.willTopicField.text;
    self->_account.isRetain = self.retainSwitch.isOn;
    self->_account.qos = (int32_t)[self.qosTextField.text integerValue];
    
    [self.delegate loginTableViewController:self newAccountToAdd:self->_account];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

#pragma mark - IBPickerViewDelegate

- (void) pickerView:(IBPickerView *)view didSelectValue:(NSObject *)value {
    
    if ([view isEqual:self->_qosPickerView]) {
        NSString *string = [((NSNumber *)value) stringValue];
        self.qosTextField.text = string;
        [self.qosTextField resignFirstResponder];
    }
}

#pragma mark - UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self->_registerInfoSectionCells != nil && self->_settingsSectionCells != nil) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == IBRegustrationInfoSection) {
        return self.registerInfoSectionCells.count;
    }
    return self.settingsSectionCells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSString *cellIdentifier = (indexPath.section == IBRegustrationInfoSection)?[self.registerInfoSectionCells objectAtIndex:indexPath.row]:[self.settingsSectionCells objectAtIndex:indexPath.row];
    IBLoginTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if ([cellIdentifier isEqualToString:IBProtocolCell]) {
        self.protocolField = ((UITextField *)cell.control);
    } else if ([cellIdentifier isEqualToString:IBUsernameCell]) {
        self.usernameField = ((UITextField *)cell.control);
        self.usernameField.delegate = self;
    } else if ([cellIdentifier isEqualToString:IBPasswordCell]) {
        self.passwordField = ((UITextField *)cell.control);
        self.passwordField.delegate = self;
    } else if ([cellIdentifier isEqualToString:IBClientIDCell]) {
        self.clientIDField = ((UITextField *)cell.control);
        self.clientIDField.delegate = self;
    } else if ([cellIdentifier isEqualToString:IBServerHostCell]) {
        self.serverHostField = ((UITextField *)cell.control);
        self.serverHostField.delegate = self;
    } else if ([cellIdentifier isEqualToString:IBPortCell]) {
        self.portField = ((UITextField *)cell.control);
        self.portField.delegate = self;
    } else if ([cellIdentifier isEqualToString:IBCleanSessionCell]) {
        self.cleanSessionSwitch = ((UISwitch *)cell.control);
    } else if ([cellIdentifier isEqualToString:IBKeepaliveCell]) {
        self.keepaliveField = ((UITextField *)cell.control);
        self.keepaliveField.delegate = self;
    } else if ([cellIdentifier isEqualToString:IBWillCell]) {
        self.willField = ((UITextField *)cell.control);
        self.willField.delegate = self;
    } else if ([cellIdentifier isEqualToString:IBWillTopicCell]) {
        self.willTopicField = ((UITextField *)cell.control);
        self.willTopicField.delegate = self;
    } else if ([cellIdentifier isEqualToString:IBRetainCell]) {
        self.retainSwitch = ((UISwitch *)cell.control);
    } else if ([cellIdentifier isEqualToString:IBQoSCell]) {
        self.qosTextField = ((UITextField *)cell.control);
        self.qosTextField.delegate = self;
        [self.qosTextField setInputView:self->_qosPickerView];
    }
    return cell;
}

#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == IBRegustrationInfoSection && indexPath.row == 0) {
        [self.delegate loginTableViewControllerProtocolCellDidClick:self];
        [tableView deselectRowAtIndexPath:indexPath animated:true];
    }
}

@end
