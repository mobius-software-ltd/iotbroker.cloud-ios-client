//
//  IBSNPingreq.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNPingreq.h"

@implementation IBSNPingreq

- (instancetype) initWithClientID : (NSString *) clientID {
    self = [super init];
    if (self != nil) {
        self->_clientID = clientID;
    }
    return self;
}

- (NSInteger)getLength {
    NSInteger length = 2;
    if (self->_clientID.length != 0) {
        length += self->_clientID.length;
    }
    return length;
}

- (IBSNMessages)getMessageType {
    return IBPingreqMessage;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n - clientID = %@", self->_clientID];
}

@end
