//
//  IBTLVAMQP.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBTLVAMQP.h"

@implementation IBTLVAMQP

@synthesize isNull = _isNull;

- (instancetype) initWithConstructor : (IBAMQPSimpleConstructor *) constructor {
    self = [super init];
    if (self != nil) {
        self->_constructor = constructor;
    }
    return self;
}

- (IBAMQPTypes)type {
    return self->_constructor.type.value;
}

- (void)setType:(IBAMQPTypes)type {
    if (self->_constructor != nil) {
        self->_constructor.type.value = type;
    }
}

- (BOOL)isNull {
    return (self->_constructor.type.value == IBAMQPNullType);
}

- (id)copyWithZone:(NSZone *)zone {

    IBTLVAMQP *copy = [[IBTLVAMQP alloc] initWithConstructor:self.constructor];
    copy.type = self.type;
    copy->_data = self->_data;
    copy->_length = self->_length;
    copy->_isNull = self->_isNull;
    copy->_value = self->_value;

    return copy;
}

@end
