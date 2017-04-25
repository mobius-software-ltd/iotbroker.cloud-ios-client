//
//  IBSNShortTopic.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNShortTopic.h"

@implementation IBSNShortTopic

- (instancetype) initWithValue : (NSString *) value andQoS : (IBSNQoS *) qos {
    self = [super init];
    if (self != nil) {
        self->_value = value;
        self->_qos = qos;
    }
    return self;
}

- (IBSNTopicType *)getType {
    return [[IBSNTopicType alloc] initWithValue:IBShortTopicType];
}

- (NSData *)encode {
    return [self->_value dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSUInteger)hash {
    NSInteger prime = 31;
    NSInteger result = 1;
    result = prime * result + (([self->_qos isValid] == false) ? 0 : [self->_qos hash]);
    result = prime * result + ((self->_value.length == 0) ? 0 : [self->_value hash]);
    return result;
}

- (BOOL)isEqual:(id)object {
    if ([self isEqual:object]) {
        return true;
    }
    if (self == nil) {
        return false;
    }
    if ([self class] != [object class]) {
        return false;
    }
    IBSNShortTopic *other = (IBSNShortTopic *)object;
    if (self->_qos.value != other.qos.value) {
        return false;
    }
    if (self->_value == nil) {
        if (other.value != nil) {
            return false;
        }
    }
    else if (![self->_value isEqualToString:other.value]) {
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
