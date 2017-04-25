//
//  IBSNEncapsulated.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNEncapsulated.h"

@implementation IBSNEncapsulated

- (instancetype) initWithRadius : (IBSNRadius) radius wirelessNodeID : (NSString *) wirelessNodeID andMessage : (id<IBSNMessage>) message {
    self = [super init];
    if (self != nil) {
        self->_radius = radius;
        self->_wirelessNodeID = wirelessNodeID;
        self->_message = message;
    }
    return self;
}

- (NSInteger)getLength {
    NSInteger length = 3;
    if (self->_wirelessNodeID.length != 0) {
        length += self->_wirelessNodeID.length;
    }
    return length;
}

- (IBSNMessages)getMessageType {
    return IBEncapsulatedMessage;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n - radius = %zd\n - wirelessNodeID = %@\n - message = %@", self->_radius, self->_wirelessNodeID, self->_message];
}

@end
