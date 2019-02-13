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

#import "IBAMQPDecimal.h"

@implementation IBAMQPDecimal

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self->_value = [NSMutableData data];
    }
    return self;
}

- (instancetype) initWithValue : (NSMutableData *) value {
    self = [super init];
    if (self != nil) {
        self->_value = [NSMutableData dataWithData:value];
    }
    return self;
}

- (instancetype) initWithByte : (Byte) byte {
    self = [self init];
    if (self != nil) {
        [self->_value appendByte:byte];
    }
    return self;
}

- (instancetype) initWithShort : (short) number {
    self = [self init];
    if (self != nil) {
        [self->_value appendShort:number];
    }
    return self;
}

- (instancetype) initWithInt : (int) number {
    self = [self init];
    if (self != nil) {
        [self->_value appendInt:number];
    }
    return self;
}

- (instancetype) initWithLong : (long) number {
    self = [self init];
    if (self != nil) {
        [self->_value appendLong:number];
    }
    return self;
}

- (instancetype) initWithFloat : (float) number {
    self = [self init];
    if (self != nil) {
        [self->_value appendFloat:number];
    }
    return self;
}

- (instancetype) initWithDouble : (double) number {
    self = [self init];
    if (self != nil) {
        [self->_value appendDouble:number];
    }
    return self;
}

- (Byte) byte {
    return [self->_value readByte];
}

- (short) shortNumber {
    return [self->_value readShort];
}

- (int) intNumber {
    return [self->_value readInt];
}

- (long) longNumber {
    return [self->_value readLong];
}

- (float) floatNumber {
    return [self->_value readFloat];
}

- (double) doubleNumber {
    return [self->_value readDouble];
}

@end
