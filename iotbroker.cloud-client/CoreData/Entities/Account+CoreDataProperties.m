//
//  Account+CoreDataProperties.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 14.06.2018.
//  Copyright © 2018 MobiusSoftware. All rights reserved.
//
//

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
        if (self.username.length == 0 || self.password.length == 0 || self.clientID.length == 0 || self.serverHost.length == 0 || self.port == 0 || self.keepalive == 0 || self.will.length == 0 || self.willTopic.length == 0) {
            return false;
        }
    } else if (self.protocol == IBMqttSNProtocolType) {
        if (self.clientID.length == 0 || self.serverHost.length == 0 || self.port == 0 || self.keepalive == 0) {
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

@end
