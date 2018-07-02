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

#import <Foundation/Foundation.h>

@interface NSMutableData (MQTT)

@property (assign, nonatomic) NSInteger byteNumber;

- (void) appendByte : (Byte) byte;
- (Byte) readByte;
- (void) appendShort : (short) value;
- (short) readShort;

- (void) appendInt : (NSInteger) value;
- (int) readInt;

- (void) appendUInt24 : (int) value;
- (int) readUInt24;

- (void) appendLong : (NSInteger) value;
- (NSInteger) readLong;

- (void) appendFloat : (float) value;
- (float) readFloat;
- (void) appendDouble : (double) value;
- (double) readDouble;

- (NSString *) readStringWithLength : (NSInteger) length;
- (NSInteger) numberWithLength : (NSInteger) length;
- (NSMutableData *) dataWithLength : (NSInteger) length;

- (void) clearNumber;
- (NSInteger) getByteNumber;

@end
