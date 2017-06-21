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
