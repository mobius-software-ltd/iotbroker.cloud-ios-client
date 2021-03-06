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

#import "IBQoS.h"

@implementation IBQoS

- (instancetype) initWithValue : (Byte) value {
    
    self = [super init];
    if (self != nil) {
        self->_value = value;
    }
    return self;
}

+ (instancetype) claculateSubscriberQos : (IBQoS *) subscriberQos andPublisherQos : (IBQoS *) publisherQos {
    
    if (subscriberQos.value == publisherQos.value) {
        return subscriberQos;
    }
    
    if (subscriberQos.value > publisherQos.value) {
        return publisherQos;
    } else {
        return subscriberQos;
    }
}

- (BOOL) isValidForMqtt {
    
    if (self->_value == IBAtMostOnce || self->_value == IBAtLeastOnce || self->_value == IBExactlyOnce) {
        return true;
    }
    return false;
}

- (BOOL) isValidforMqttSN {
    
    if (self->_value == IBAtMostOnce || self->_value == IBAtLeastOnce || self->_value == IBExactlyOnce || self->_value == IBLevelOne) {
        return true;
    }
    return false;
}

@end
