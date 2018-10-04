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

#import "IBMQTTTopic.h"

static NSString *const IBSeparator = @":";

@implementation IBMQTTTopic

- (instancetype) initWithName : (NSString *) name andQoS : (IBQoS *) qos {
    
    self = [super init];
    if (self != nil) {
        self.name = name;
        self.qos = qos;
    }
    return self;
}

+ (nullable instancetype) mqttTopic:(NSString *)name qos:(NSInteger)qos {
    if (name.length > 0) {
        IBQoS *QoS = [[IBQoS alloc] initWithValue:qos];
        return [[IBMQTTTopic alloc] initWithName:name andQoS:QoS];
    }
    return nil;
}

- (IBSNTopicType *)getType {
    return nil;
}

- (IBQoS *)getQoS {
    return self->_qos;
}

- (NSData *)encode {
    return [self->_name dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSInteger) length {
    return self.name.length ;
}

@end

// JSON Mapping

@interface IBMQTTTopic (JsonMapping)

@property (nonatomic) NSInteger jmQos;

@end

@implementation IBMQTTTopic (JsonMapping)

@dynamic jmQos;

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{ @"jmQos": @"qos" }];
}

- (NSInteger)jmQos {
    return self->_qos.value;
}

- (void)setJmQos:(NSInteger)jmQos {
    self->_qos = [[IBQoS alloc] initWithValue:(IBQualitiesOfService)jmQos];
}

@end
