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

#import "IBMutableData.h"

@implementation NSMutableData (MQTT)

NSInteger byteNumber = 0;

- (void) appendByte : (Byte) byte {
    [self appendBytes:&byte length:1];
}

- (Byte) readByte {
    
    const Byte *bytes = [self bytes];
    Byte byte = bytes[byteNumber];
    byteNumber++;
    
    return byte;
}

- (void) appendShort : (short) value {
   
    value = htons(value);
    [self appendBytes:&value length:2];
}

- (NSInteger) readShort {
    
    short value = 0;

    value += [self readByte];
    value += [self readByte];
    
    return value;
}

- (NSString *) readStringWithLength : (NSInteger) length {
    
    NSMutableString *string = [NSMutableString string];
    
    for (int i = 0; i < length; i++) {
        
        char chr = (char)[self readByte];
        [string appendFormat:@"%c", chr];
    }
    return string;
}

- (NSInteger) numberWithLength : (NSInteger) length {
    
    NSInteger number = 0;
    NSData *data = [self subdataWithRange:NSMakeRange([self getByteNumber], length)];
    Byte *bytes = (Byte *)[data bytes];
    
    for (int i = 0; i < length; i++) {
        number <<= 8;
        number |= bytes[i] & 0x00FF;
    }
    byteNumber += length;
    
    return number;
}

- (void) clearNumber {
    byteNumber = 0;
}

- (NSInteger) getByteNumber {
    return byteNumber;
}


@end
