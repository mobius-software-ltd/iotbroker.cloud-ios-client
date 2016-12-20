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

#import "IBMessageTimer.h"

@implementation IBMessageTimer

- (instancetype) initWithTimeInterval : (NSTimeInterval) interval connectTimerFor : (IBMQTT *) mqtt withAccount : (Account *) account {
    self = [super init];
    if (self != nil) {
        self->_timer = [NSTimer scheduledTimerWithTimeInterval:interval target:mqtt selector:@selector(connectWithUserInfo:) userInfo:account repeats:true];
    }
    return self;
}

- (instancetype) initWithTimeInterval : (NSTimeInterval) interval message : (IBMessages) message timerFor : (IBMQTT *) mqtt withUserInfo : (id) userInfo {
    self = [super init];
    if (self != nil) {
        
         if (message == IBSubscribeMessage) {
            self->_timer = [NSTimer scheduledTimerWithTimeInterval:interval target:mqtt selector:@selector(subscribeWithUserInfo:) userInfo:userInfo repeats:true];
        } else if (message == IBUnsubscribeMessage) {
            self->_timer = [NSTimer scheduledTimerWithTimeInterval:interval target:mqtt selector:@selector(unsubscribeWithUserInfo:) userInfo:userInfo repeats:true];
        } else if (message == IBPublishMessage) {
            self->_timer = [NSTimer scheduledTimerWithTimeInterval:interval target:mqtt selector:@selector(publishWithUserInfo:) userInfo:userInfo repeats:true];
        } else if (message == IBPubrecMessage) {
            self->_timer = [NSTimer scheduledTimerWithTimeInterval:interval target:mqtt selector:@selector(pubrecWithUserInfo:) userInfo:userInfo repeats:true];
        } else if (message == IBPubrelMessage) {
            self->_timer = [NSTimer scheduledTimerWithTimeInterval:interval target:mqtt selector:@selector(pubrelWithUserInfo:) userInfo:userInfo repeats:true];
        }
    }
    return self;
}

- (void) stop {

    [self.timer invalidate];
    self->_timer = nil;
}

@end
