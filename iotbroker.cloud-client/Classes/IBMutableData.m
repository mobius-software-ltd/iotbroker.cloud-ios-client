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
#import <objc/runtime.h>

static void const *key;

@implementation NSMutableData (MQTT)

//NSInteger byteNumber = 0;

- (NSInteger)byteNumber {
    return [objc_getAssociatedObject(self, key) integerValue];
}

- (void)setByteNumber:(NSInteger)byteNumber {
    objc_setAssociatedObject(self, key, @(byteNumber), OBJC_ASSOCIATION_RETAIN);
}

- (void) appendByte : (Byte) byte {
    [self appendBytes:&byte length:1];
}

- (Byte) readByte {
    
    const Byte *bytes = [self bytes];
    Byte byte = bytes[self.byteNumber];
    self.byteNumber++;
    
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

- (void) appendUInt24 : (int) value {

    int length = 3;
    
    Byte *bytes = malloc(sizeof(Byte) * length);
    
    for (int i = 0, bitShift = 16; i < length; i++, bitShift -= 8) {
        if (bitShift == 0) {
            bytes[i] = (Byte)(value & 0x00FF);
        } else {
            bytes[i] = (Byte)((value >> bitShift) & 0x00FF);
        }
    }
    [self appendBytes:bytes length:length];
}

- (int) readUInt24 {

    int length = 3;
    
    NSInteger value = 0;
    NSData *subData = [self subdataWithRange:NSMakeRange(self.byteNumber, length)];
    Byte *bytes = (Byte *)[subData bytes];

    for (int i = 0; i < length; i++) {
        value <<= 8;
        value |= bytes[i] & 0x00FF;
    }
    self.byteNumber += length;
    
    return (int)value;
}

- (void) appendInt : (NSInteger) value {
    
    int number = (int)value;
    
    value = htonl(number);
    [self appendBytes:&value length:sizeof(int)];
}

- (int) readInt {

    int value = 0;

    value = (int)[self numberWithLength:sizeof(int)];

    return value;
}

- (void) appendLong : (NSInteger) value {
    
    long number = value;
    
    value = htonll(number);
    [self appendBytes:&value length:sizeof(long)];
}

- (NSInteger) readLong {
    
    int value = 0;
    
    value = (int)[self numberWithLength:sizeof(long)];
    
    return value;
}


- (void) appendFloat : (float) value {

    [self appendBytes:&value length:sizeof(float)];
}

- (float) readFloat {

    int length = sizeof(float);
    NSData *data = [self subdataWithRange:NSMakeRange(self.byteNumber, length)];
    self.byteNumber += length;
    return ((float *)[data bytes])[0];
}

- (void) appendDouble : (double) value {

    [self appendBytes:&value length:sizeof(double)];
}

- (double) readDouble {

    int length = sizeof(double);
    NSData *data = [self subdataWithRange:NSMakeRange(self.byteNumber, length)];
    self.byteNumber += length;
    return ((double *)[data bytes])[0];
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

    if (self.byteNumber == self.length) return 0;
    
    NSInteger number = 0;
    NSData *data = [self subdataWithRange:NSMakeRange(self.byteNumber, length)];
    Byte *bytes = (Byte *)[data bytes];
    
    for (int i = 0; i < length; i++) {
        number <<= 8;
        number |= bytes[i] & 0x00FF;
    }
    self.byteNumber += length;
    
    return number;
}

- (NSMutableData *) dataWithLength : (NSInteger) length {

    NSData *data = [self subdataWithRange:NSMakeRange([self getByteNumber], length)];
    self.byteNumber += length;
    
    return [NSMutableData dataWithData:data];
}

- (void) clearNumber {
    self.byteNumber = 0;
}

- (NSInteger) getByteNumber {
    return self.byteNumber;
}


@end
