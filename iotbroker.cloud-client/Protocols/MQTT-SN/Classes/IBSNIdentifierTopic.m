//
//  IBSNIdentifierTopic.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNIdentifierTopic.h"

@implementation IBSNIdentifierTopic

- (instancetype) initWithValue : (NSInteger) value andQoS : (IBSNQoS *) qos {
    self = [super init];
    if (self != nil) {
        self->_value = value;
        self->_qos = qos;
    }
    return self;
}

- (IBSNTopicType *)getType {
    return [[IBSNTopicType alloc] initWithValue:IBIDTopicType];
}

- (NSData *)encode {
    short number = (short)self->_qos.value;
    return [NSData dataWithBytes:&number length:sizeof(short)];
}

- (NSUInteger)hash {
    NSInteger prime = 31;
    NSInteger result = 1;
    result = prime * result + (([self->_qos isValid] == false) ? 0 : [self->_qos hash]);
    result = prime * result + self->_value;
    return result;
}

- (BOOL)isEqual:(id)object {

    if ([self isEqual:object]) {
        return true;
    }
    if (object == nil) {
        return false;
    }
    if ([self class] != [object class]) {
        return false;
    }
    IBSNIdentifierTopic *other = (IBSNIdentifierTopic *)object;
    if (self->_qos.value != other.qos.value) {
        return false;
    }
    if (self->_value != other.value) {
        return false;
    }
    return true;
}

- (NSInteger)length {
    return 2;
}

- (IBSNQoS *)getQoS {
    return self->_qos;
}

@end
