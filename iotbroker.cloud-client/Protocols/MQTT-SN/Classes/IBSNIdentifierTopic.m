/**
 * Mobius Software LTD
 * Copyright 2015-2017, Mobius Software LTD
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

#import "IBSNIdentifierTopic.h"

@implementation IBSNIdentifierTopic

- (instancetype) initWithValue : (NSInteger) value andQoS : (IBQoS *) qos {
    self = [super init];
    if (self != nil) {
        self->_value = value;
        self->_qos = qos;
    }
    return self;
}

+ (int) topicIdByEncodedValue:(NSData *)data {
    short *array = malloc(sizeof(short));
    [data getBytes:array length:sizeof(short)];
    return htons(array[0]);
}

- (IBSNTopicType *)getType {
    return [[IBSNTopicType alloc] initWithValue:IBIDTopicType];
}

- (NSData *)encode {
    short number = htons(self->_value);
    return [NSData dataWithBytes:&number length:sizeof(short)];
}

- (NSUInteger)hash {
    NSInteger prime = 31;
    NSInteger result = 1;
    result = prime * result + (([self->_qos isValidforMqttSN] == false) ? 0 : [self->_qos hash]);
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

- (IBQoS *)getQoS {
    return self->_qos;
}

@end
