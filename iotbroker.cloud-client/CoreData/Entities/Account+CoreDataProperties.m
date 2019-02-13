/**
 * Mobius Software LTD
 * Copyright 2015-2018, Mobius Software LTD
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

#import "Account+CoreDataProperties.h"

@implementation Account (CoreDataProperties)

+ (NSFetchRequest<Account *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Account"];
}

@dynamic cleanSession;
@dynamic clientID;
@dynamic isDefault;
@dynamic isRetain;
@dynamic keepalive;
@dynamic password;
@dynamic port;
@dynamic protocol;
@dynamic qos;
@dynamic serverHost;
@dynamic username;
@dynamic will;
@dynamic willTopic;
@dynamic isSecure;
@dynamic keyPath;
@dynamic keyPass;
@dynamic messages;
@dynamic topics;

@end

@implementation Account (CoreDataValueValidation)

- (BOOL) isValid {
    
    if (self.protocol == IBMqttProtocolType) {
        if (self.username.length == 0 || self.password.length == 0 || self.clientID.length == 0 || self.serverHost.length == 0 || self.port == 0) {
            return false;
        }
    } else if (self.protocol == IBMqttSNProtocolType) {
        if (self.clientID.length == 0 || self.serverHost.length == 0 || self.port == 0) {
            return false;
        }
    } else if (self.protocol == IBCoAPProtocolType) {
        if (self.port == 0) {
            return false;
        }
    } else if (self.protocol == IBAMQPProtocolType) {
        if (self.clientID.length == 0 || self.serverHost.length == 0 || self.port == 0) {
            return false;
        }
    }
    return true;
}

- (BOOL) isValidKeepaliveRange {
    return (self.keepalive >= 0 && self.keepalive <= 65535);
}

@end
