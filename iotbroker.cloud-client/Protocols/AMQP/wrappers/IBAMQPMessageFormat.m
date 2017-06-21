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

#import "IBAMQPMessageFormat.h"
#import "IBMutableData.h"

@implementation IBAMQPMessageFormat

- (instancetype) initWithValue : (long) value {
    self = [super init];
    if (self != nil) {
        NSMutableData *data = [NSMutableData data];
        [data appendInt:value];
        
        Byte *bytes = (Byte *)[data bytes];
        
        self->_messageFormat = [data readUInt24];
        self->_version = bytes[3] & 0xff;
    }
    return self;
}

- (instancetype) initWithMessageFormat : (NSInteger) format andVersion : (NSInteger) version {
    self = [super init];
    if (self != nil) {
        self->_messageFormat = format;
        self->_version = version;
    }
    return self;
}

- (long) encode {
    NSMutableData *data = [NSMutableData data];
    [data appendUInt24:(int)self.messageFormat];
    [data appendByte:(Byte)self.version];
    return [data readInt];
}

@end
