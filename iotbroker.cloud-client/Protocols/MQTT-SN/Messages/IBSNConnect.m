//
//  IBSNConnect.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNConnect.h"

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

- (IBSNMessages)getMessageType {
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

