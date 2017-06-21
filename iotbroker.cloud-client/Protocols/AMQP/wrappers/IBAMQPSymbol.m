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

#import "IBAMQPSymbol.h"

@implementation IBAMQPSymbol

- (instancetype) initWithString : (NSString *) value {
    self = [super init];
    if (self != nil) {
        self->_value = value;
    }
    return self;
}

- (NSString *)description {
    return self->_value;
}

- (NSUInteger)hash {
    NSInteger prime = 31;
    NSInteger result = 1;
    result = prime * result + ((self->_value == nil) ? 0 : self->_value.hash);
    return result;
}

- (BOOL)isEqual:(id)object {

    if (self == object) {
        return true;
    }
    if (object == nil) {
        return false;
    }
    if ([self class] != [object class]) {
        return false;
    }
    
    IBAMQPSymbol *other = (IBAMQPSymbol *)object;

    if (self->_value == nil) {
        if (other.value != nil) {
            return false;
        }
    } else if (![self->_value isEqual:other.value]) {
        return false;
    }
    return true;
}

- (id)copyWithZone:(NSZone *)zone {

    IBAMQPSymbol *copy = [[IBAMQPSymbol alloc] initWithString:self->_value];
    return copy;
}

@end
