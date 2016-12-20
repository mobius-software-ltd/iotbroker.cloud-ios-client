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

#import "IBTabBarController.h"

@interface IBTabBarController ()

@end

@implementation IBTabBarController
{
    NSTimer *_timer;
    NSMutableDictionary *_publishTopics;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self->_mqtt = [IBMQTT sharedInstance];
    
    self.navigationController.navigationBar.translucent = false;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationItem.hidesBackButton = true;
    [self.navigationController setNavigationBarHidden:false animated:true];
        
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ImageLogout"] style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    [self.navigationItem setRightBarButtonItem:logoutButton];
    
    self->_accountManager = [IBAccountManager getInstance];
    self->_currentAccount = [self->_accountManager readDefaultAccount];
    self->_mqtt.publishInDelegate = self;
    
    self->_publishTopics = [NSMutableDictionary dictionary];
    
    if (self->_currentAccount != nil && self->_currentAccount.keepalive > 0) {
        NSLog(@" >> keepalive = %i", self->_currentAccount.keepalive);
        self->_timer = [NSTimer scheduledTimerWithTimeInterval: self->_currentAccount.keepalive target: self selector:@selector(timerMethod) userInfo: nil repeats:true];
    }
}

- (void)logout {
    
    NSLog(@" >> bye : %@", self->_currentAccount.username);
    
    if (self->_currentAccount != nil) {
        [self->_timer invalidate];
        self->_timer = nil;
        self->_currentAccount.isDefault = false;
        if ([self->_accountManager.coreDataManager save] == true) {
            [self->_mqtt disconnect];
            [[self navigationController] setNavigationBarHidden:true animated:false];
            [self.navigationController popToRootViewControllerAnimated:true];
        }
    }
}

- (void) timerMethod {

    if ([self->_mqtt ping] == true) {
        NSLog(@" >> ping ok");
    }
}

#pragma mark - IBMQTTPublishInMessageDelegate

- (void)publishRequestWithPacketID:(NSInteger)packetID topic:(IBTopic *)topic content:(NSData *)content isRetain:(BOOL)isRetain andIsDup:(BOOL)isDup {

    if ([topic.qos getValue] == 1) {
        if (isDup == false) {
            [self->_accountManager addIncoming:true message:[[IBPublish alloc] initWithPacketID:packetID andTopic:topic andContent:content andIsRetain:isRetain andDup:isDup]];
        }
        [self->_mqtt pubackWithPacketID:packetID];
    } else if ([topic.qos getValue] == 2) {
        if (isDup == false) {
            [self->_accountManager addIncoming:true message:[[IBPublish alloc] initWithPacketID:packetID andTopic:topic andContent:content andIsRetain:isRetain andDup:isDup]];
        }
        
        if ([self->_mqtt pubrecWithPacketID:packetID] == false) {
            self->_pubrecTimer = [[IBMessageTimer alloc] initWithTimeInterval:3.0 message:IBPubrecMessage timerFor:self->_mqtt withUserInfo:@(packetID)];
        }
    }
}

- (void) publishReleaseReceivedWithPacketID : (NSInteger) packetID {
    NSLog(@"---+ PUBREL");
    
    if (self->_pubrecTimer != nil) {
        [self->_pubrecTimer stop];
    }
    [self->_mqtt pubcompWithPacketID:packetID];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
