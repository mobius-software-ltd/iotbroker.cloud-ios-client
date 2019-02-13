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

#import "IBTimerTask.h"
#import "IBPublish.h"
#import "IBSNPublish.h"
#import "IBConnect.h"
#import "IBSNConnect.h"

NSInteger const IBConnectRepeatTimes = 5;

@implementation IBTimerTask
{
    NSInteger _connectCount;
}

- (instancetype) initWithMessage : (id<IBMessage>) message request : (id<IBRequests>) request andPeriod : (NSInteger) period {
    self = [super init];
    if (self != nil) {
        self->_message = message;
        self->_request = request;
        self->_period = period;
        self->_status = false;
        self->_connectCount = 0;
    }
    return self;
}

- (void) start {
    self->_timer = [NSTimer scheduledTimerWithTimeInterval:self->_period target:self selector:@selector(timerMethod:) userInfo:nil repeats:true];
    [self->_timer fire];
}

- (void) stop {
    [self->_timer invalidate];
    self->_timer = nil;
}

#pragma mark - Private methods -

- (void) timerMethod : (NSTimer *) timer {
    
    if ([self->_message isKindOfClass:[IBConnect class]] || [self->_message isKindOfClass:[IBSNConnect class]]) {
        self->_connectCount += 1;
        if (self->_connectCount >= IBConnectRepeatTimes) {
            [self->_request connectionTimeout];
            self->_connectCount = 0;
            return;
        }
    }

    [self sendMessage];

}

- (void) sendMessage {
    
    if (self->_request.internetProtocol.state == IBTransportOpen) {
        if (self->_status == true) {
            if ([self->_message isKindOfClass:[IBPublish class]]) {
                IBPublish *publish = (IBPublish *)self->_message;
                publish.dup = true;
            } else if ([self->_message isKindOfClass:[IBSNPublish class]]) {
                IBSNPublish *publish = (IBSNPublish *)self->_message;
                publish.dup = true;
            }
        }
        [self->_request sendMessage:self->_message];
        self->_status = true;
    }
    
}

@end
