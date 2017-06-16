//
//  IBAMQPSimpleType.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 16.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPSimpleType.h"

@implementation IBAMQPSimpleType

- (instancetype) initSimpleType : (IBAMQPTypes) type withValue : (id) value {
    self = [super init];
    if (self != nil) {
        self->_type = type;
        self->_value = value;
    }
    return self;
}

+ (instancetype) simpleType : (IBAMQPTypes) type withValue : (id) value {
    return [[IBAMQPSimpleType alloc] initSimpleType:type withValue:value];
}

@end
