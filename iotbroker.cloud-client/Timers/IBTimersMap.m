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

#import "IBTimersMap.h"
#import "IBCountableMessage.h"
#import "IBSNRegister.h"
#import "IBCoMessage.h"

static NSInteger const IBMessageResendPeriod = 3;
static NSInteger const IBMaxValue = 65535;
static NSInteger const IBFirstID = 1;

@implementation IBTimersMap

- (instancetype) initWithRequest : (id<IBRequests>) request {
    self = [super init];
    if (self != nil) {
        self->_timersDictionary = [NSMutableDictionary dictionary];
        self->_request = request;
        self->_connect = nil;
        self->_ping = nil;
        self->_registerPacket = nil;
        self->_counter = 0;
    }
    return self;
}

- (void) startConnectTimer : (id<IBMessage>) message {
    
    if (self->_connect != nil) {
        [self->_connect stop];
    }
    
    self->_connect = [[IBTimerTask alloc] initWithMessage:message request:self->_request andPeriod:IBMessageResendPeriod];
    [self->_connect start];
}

- (void) stopConnectTimer {
    
    if (self->_connect != nil) {
        [self->_connect stop];
        self->_connect = nil;
    }
}

- (void) startPingTimerWithKeepAlive : (NSInteger) keepAlive {
    
    if (self->_ping != nil) {
        [self->_ping stop];
    }
    
    id<IBMessage> ping = [self->_request getPingreqMessage];
    
    if (ping != nil) {
        self->_ping = [[IBTimerTask alloc] initWithMessage:ping request:self->_request andPeriod:keepAlive];
        [self->_ping start];
    } else {
        @throw [NSException exceptionWithName:[[self class] description] reason:@"Ping has not been send. ClientID is nil" userInfo:nil];
    }
}

- (void) stopPingTimer {
    
    if (self->_ping != nil) {
        [self->_ping stop];
        self->_ping = nil;
    }
}

- (void) startRegisterTimer: (id<IBMessage>) message {
    if (self->_registerPacket != nil) {
        [self->_registerPacket stop];
    }
    
    IBCountableMessage *countableMessage = (IBCountableMessage *)message;
    if (countableMessage.packetID == 0) {
        countableMessage.packetID = [self getNewPacketID];
    }
    
    self->_registerPacket = [[IBTimerTask alloc] initWithMessage:message request:self->_request andPeriod:IBMessageResendPeriod];
    [self->_registerPacket start];
}

- (void) stopRegisterTimer {
    if (self->_registerPacket != nil) {
        [self->_registerPacket stop];
        self->_registerPacket = nil;
    }
}

- (void) startCoAPMessageTimer: (id<IBMessage>) coapMessage {

    IBTimerTask *timerTask = [[IBTimerTask alloc] initWithMessage:coapMessage request:self->_request andPeriod:IBMessageResendPeriod];

    IBCoMessage *message = (IBCoMessage *)coapMessage;
    [self->_timersDictionary setObject:timerTask forKey:@(message.token)];
    
    [timerTask start];
}

- (void) startMessageTimer : (id<IBMessage>) message {
    
    IBTimerTask *timerTask = [[IBTimerTask alloc] initWithMessage:message request:self->_request andPeriod:IBMessageResendPeriod];
    
    if (self->_timersDictionary.count == IBMaxValue) {
        @throw [NSException exceptionWithName:[[self class] description] reason:@"Outgoing identifier overflow" userInfo:nil];
    }
    
    NSInteger number = [self getNewPacketID];
    
    if ([message isKindOfClass:[IBCountableMessage class]]) {
        IBCountableMessage *countableMessage = (IBCountableMessage *)message;
        if (countableMessage.packetID == 0) {
            countableMessage.packetID = [self getNewPacketID];
        }
    }
    
    [self->_timersDictionary setObject:timerTask forKey:@(number)];
    
    [timerTask start];
}

- (id<IBMessage>) removeTimerWithPacketID : (NSNumber *) packetID {
    
    IBTimerTask *timerTask = [self->_timersDictionary objectForKey:packetID];
    id<IBMessage> message = timerTask.message;
    
    if (timerTask != nil) {
        [timerTask stop];
    }
    
    [self->_timersDictionary removeObjectForKey:packetID];
    
    return message;
}

- (id<IBMessage>) stopTimerWithPacketID : (NSNumber *) packetID {

    IBTimerTask *timerTask = [self->_timersDictionary objectForKey:packetID];
    id<IBMessage> message = nil;
    
    if (timerTask != nil) {
        message = timerTask.message;
        [timerTask stop];
    }
    
    return message;
}

- (void) stopAllTimers {
    
    [self stopConnectTimer];
    [self stopPingTimer];
    
    for (NSNumber *item in self->_timersDictionary.allKeys) {
        IBTimerTask *timerTask = [self->_timersDictionary objectForKey:item];
        if (timerTask != nil) {
            [timerTask stop];
        }
        [self->_timersDictionary removeObjectForKey:item];
    }
    self->_counter = 0;
}

#pragma mark - Private methods -

- (NSInteger) getNewPacketID {

    self->_counter++;
    
    if (self->_counter == IBMaxValue) {
        self->_counter = IBFirstID;
    }
    
    return self->_counter;
}

@end
