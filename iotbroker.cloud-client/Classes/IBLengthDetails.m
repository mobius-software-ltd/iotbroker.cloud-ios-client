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

#import "IBLengthDetails.h"

@implementation IBLengthDetails

- (instancetype) initWithLength : (NSInteger) length andSize : (NSInteger) size {

    self = [super init];
    if (self != nil) {
        self.length = length;
        self.size = size;
    }
    return self;
}

+ (instancetype) decodeLength : (NSMutableData *) buffer {
    
    NSInteger length = 0;
    NSInteger multiplier = 1;
    NSInteger byteUsed = 0;
    Byte encodedByte = 0;
    
    do {
        if (!(multiplier > 128 * 128 * 128)) {
            
            encodedByte = [buffer readByte];
            length += (encodedByte & 0x7f) * multiplier;
            multiplier *= 128;
            byteUsed++;
        }
    } while ((encodedByte & 128) != 0);
    
    return [[IBLengthDetails alloc] initWithLength:length andSize:byteUsed];
}

@end
