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

#import "IBSNConnect.h"
#import "IBMQTT-SNEnums.h"

@implementation IBSNConnect

- (instancetype) initWithWillPresent : (BOOL) willPresent cleanSession : (BOOL) cleanSession duration : (NSInteger) duration clientID : (NSString *) clientID {
    self = [super init];
    if (self != nil) {
        self->_willPresent = willPresent;
        self->_cleanSession = cleanSession;
        self->_protocolID = IBMQTTSNProtocolID;
        self->_duration = duration;
        self->_clientID = clientID;
    }
    return self;
}

- (NSInteger)getLength {
    if (self->_clientID.length == 0) {
        @throw [NSException exceptionWithName:@"Exception" reason:@"Connect must contain a valid clientID" userInfo:nil];
    }
    return self->_clientID.length + 6;
}

- (NSInteger)getMessageType {
    return IBConnectMessage;
}

- (BOOL)isWillPresent {
    return self->_willPresent;
}

- (BOOL)isCleanSession {
    return self->_cleanSession;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n - willPresent = %@\n - cleanSession = %@\n - protocolID = %zd\n - duration = %zd\n - clientID = %@",
            (self->_willPresent == true)?@"yes":@"no",
            (self->_cleanSession == true)?@"yes":@"no",
            self->_protocolID,
            self->_duration,
            self->_clientID];
}

@end

