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

#import "IBLoadingViewController.h"

static NSString *const IBLoginSegue = @"IBLoginSegue";
static NSString *const IBMainSegue = @"IBMainSegue";
static NSString *const IBChooseAccountPopover = @"IBChooseAccountPopover";

@interface IBLoadingViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation IBLoadingViewController
{
    NSArray<Account *> *_accounts;
    IBAccountListViewController *_popoverViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self->_accountManager = [IBAccountManager getInstance];
    self->_mqtt = [IBMQTT sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:true animated:false];
    self.progressView.progress = 0.f;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"size = %zd", [self->_accountManager.coreDataManager getEntities:IBAccountEntity].count);
    [self performSelectorInBackground:@selector(runLoadingMethod:) withObject:nil];
}

- (void) runLoadingMethod : (NSObject *) object {
    
    for (int i = 1; i <= 10; i++) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            double value = i/10.f;
            [self.progressView setProgress:value animated:true];
        });
        [NSThread sleepForTimeInterval:0.1];
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
 
        self->_accounts = [self->_accountManager.coreDataManager getEntities:IBAccountEntity];
        
        if (self->_accounts.count > 0) {
            [self performSegueWithIdentifier:IBChooseAccountPopover sender:self];
        } else {
            [self performSegueWithIdentifier:IBLoginSegue sender:self];
        }
    });
}

#pragma mark - IBAccountListDelegate

- (void)didSelectedAccount:(Account *)account {
    
    if (account != nil && self->_popoverViewController != nil) {
        
        NSLog(@"USERNAME : %@", account.username);
        NSLog(@"PASSWORD : %@", account.password);
        NSLog(@"TOPICS : %zd", account.topics.count);
        NSLog(@"MESSAGES : %zd", account.messages.count);

        self->_mqtt.delegate = self;
        self->_mqtt.connectDelegate = self;
        
        if ([self->_accountManager isAccountAlreadyExist:account]) {
            [self->_accountManager setDefaultAccountWithUserame:account.username];
            [self->_mqtt startWithHost:account.serverHost port:(NSInteger)account.port];
        }
    }
}

- (void)didClickToCreateNewAccount {

    [self->_popoverViewController dismissViewControllerAnimated:true completion:nil];
    [self performSegueWithIdentifier:IBLoginSegue sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:IBLoginSegue]) {
    
    } else if ([segue.identifier isEqualToString:IBMainSegue]) {
    
    } else if ([segue.identifier isEqualToString:IBChooseAccountPopover]) {
        self->_popoverViewController = [segue destinationViewController];
        self->_popoverViewController.accounts = self->_accounts;
        self->_popoverViewController.ibDelegate = self;
        self->_popoverViewController.preferredContentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        if ([self->_popoverViewController popoverPresentationController] != nil) {
            UIPopoverPresentationController *popover = [self->_popoverViewController popoverPresentationController];
            popover.delegate = self;
        }
    }
}

#pragma mark - UIPopoverPresentationControllerDelegate

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    return false;
}

#pragma mark - IBMQTTDelegate

- (void) mqttDidOpen : (IBMQTT *) mqtt  {
    NSLog(@" >> Loading : mqttDidOpen");
    
    Account *account = [self->_accountManager readDefaultAccount];
    if ([self->_mqtt connectWithAccount:account] == false) {
        self->_timer = [[IBMessageTimer alloc] initWithTimeInterval:3.0 connectTimerFor:self->_mqtt withAccount:account];
    }
}

- (void) mqttDidDisconnect : (IBMQTT *) mqtt {
    NSLog(@" >> Loading : mqttDidDisconnect");

    if (self->_timer != nil) {
        [self->_timer stop];
    }
}

- (void) mqtt : (IBMQTT *) mqtt didFailWithError : (NSError *)error {
    NSLog(@" >> Loading : didFailWithError %@", error);

}

#pragma mark - IBMQTTConnectionMessageDelegate

- (void) connectionAcknowledgmentReceivedWithCode:(IBConnectReturnCode)code andSessionPresent:(BOOL)sessionPresent {

    [self->_timer stop];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self->_popoverViewController dismissViewControllerAnimated:true completion:nil];
        self->_popoverViewController = nil;
        [self performSegueWithIdentifier:IBMainSegue sender:self];
    });
}

@end
