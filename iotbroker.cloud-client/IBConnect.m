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

#import "IBConnect.h"

static NSString *const IBProtocolName = @"MQTT";
static Byte const IBDefaultProtocolLevel = 4;
static NSInteger const IBHeaderBytesLength = 10;

@implementation IBConnect

- (instancetype) init {
    
    self = [super init];
    if (self != nil) {
        self->_protocolLevel = IBDefaultProtocolLevel;
        self.username = nil;
        self.password = nil;
        self.clientID = nil;
        self.keepalive = 10;
    }
    return self;
}

- (instancetype) initWithUsername : (NSString *) username andPassword : (NSString *) password andClientID : (NSString *) clientID andCleanSession : (BOOL) isClean andWill : (IBWill *) will {

    self = [super init];
    if (self != nil) {
        self->_protocolLevel = IBDefaultProtocolLevel;
        self.username = username;
        self.password = password;
        self.clientID = clientID;
        self.cleanSession = isClean;
        self.will = will;
        self.keepalive = 10;
    }
    return self;
}

+ (instancetype) connectWithUsername : (NSString *) username andPassword : (NSString *) password andClientID : (NSString *) clientID andCleanSession : (BOOL) isClean andWill : (IBWill *) will {
    
    return [[IBConnect alloc] initWithUsername:username andPassword:password andClientID:clientID andCleanSession:isClean andWill:will];
}

- (IBMessages) getMessageType {
    return IBConnectMessage;
}

- (NSInteger) getLength {
    
    NSInteger length = IBHeaderBytesLength;
    length += self.clientID.length + 2;
    length += [self isWillFlag]?[self.will retrieveLength]:0;       // Will
    length += [self isUsernameFlag] ? self.username.length + 2 : 0;
    length += [self isPasswordFlag] ? self.password.length + 2 : 0;
    return length;
}

- (void) setCurrentProtocolLevel : (NSInteger) level {
    self->_protocolLevel = (Byte)level;
}

- (NSString *) getProtocolName {
    return IBProtocolName;
}

- (BOOL) isClean {
    return self.cleanSession;
}

- (BOOL) isWillFlag {
    return self.will != nil;
}

- (BOOL) isUsernameFlag {
    return self.username != nil;
}

- (BOOL) isPasswordFlag {
    return self.password != nil;
}

@end
