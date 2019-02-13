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

#import "IBAMQPTLVVariable.h"

@implementation IBAMQPTLVVariable

@synthesize value = _value;
@synthesize data = _data;
@synthesize length = _length;
@synthesize isNull = _isNull;

- (instancetype) initWithType : (IBAMQPType *) type andValue : (NSMutableData *) value {
    self = [super initWithConstructor:[[IBAMQPSimpleConstructor alloc] initWithType:type]];
    if (self != nil) {
        self->_value = value;
        self.width = (value.length > 255) ? 4 : 1;
    }
    return self;
}

- (NSMutableData *)data {
    
    NSMutableData *widthData = [NSMutableData data];
    
    if (self.width == 1) {
        [widthData appendByte:(Byte)self.value.length];
    } else if (self.width == 4) {
        [widthData appendInt:self.value.length];
    }
    
    NSMutableData *bytes = [NSMutableData data];
    [bytes appendData:self.constructor.data];
    [bytes appendData:widthData];
    
    if (self.value.length > 0) {
        [bytes appendData:self.value];
    }
    
    return bytes;
}

- (NSInteger)length {
    return self->_value.length + [self.constructor length] + self.width;
}

- (NSMutableData *)value {
    return self->_value;
}

- (NSString *)description {
    return [[NSString alloc] initWithData:self->_value encoding:NSUTF8StringEncoding];
}

- (id)copyWithZone:(NSZone *)zone {
    
    IBAMQPType *typeCode = [IBAMQPType enumWithType:self.type];
    IBAMQPTLVVariable *copy = [[IBAMQPTLVVariable alloc] initWithType:typeCode andValue:self->_value];
    copy.constructor = self.constructor;
    copy->_data = self.data;
    copy->_length = self.length;
    copy->_isNull = self.isNull;
    copy->_width = self.width;
    
    return copy;
}

@end
