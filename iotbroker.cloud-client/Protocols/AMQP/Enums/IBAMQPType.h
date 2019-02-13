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

typedef NS_ENUM(Byte, IBAMQPTypes)
{
    IBAMQPSourceType        = 0x28,
    IBAMQPTargetType        = 0x29,
    IBAMQPErrorType         = 0x1D,
    IBAMQPNullType          = 0x40,
    IBAMQPBooleanType       = 0x56,
    IBAMQPBooleanTrueType   = 0x41,
    IBAMQPBooleanFalseType  = 0x42,
    IBAMQPUByteType         = 0x50,
    IBAMQPUShortType        = 0x60,
    IBAMQPUIntType          = 0x70,
    IBAMQPSmallUIntType     = 0x52,
    IBAMQPUInt0Type         = 0x43,
    IBAMQPULongType         = 0x80,
    IBAMQPSmallULongType    = 0x53,
    IBAMQPULong0Type        = 0x44,
    IBAMQPByteType          = 0x51,
    IBAMQPShortType         = 0x61,
    IBAMQPIntType           = 0x71,
    IBAMQPSmallIntType      = 0x54,
    IBAMQPLongType          = 0x81,
    IBAMQPSmallLongType     = 0x55,
    IBAMQPFloatType         = 0x72,
    IBAMQPDoubleType        = 0x82,
    IBAMQPDecimal32Type     = 0x74,
    IBAMQPDecimal64Type     = 0x84,
    IBAMQPDecimal128Type    = 0x94,
    IBAMQPCharType          = 0x73,
    IBAMQPTimestampType     = 0x83,
    IBAMQPUUIDType          = 0x98,
    IBAMQPBinary8Type       = 0xA0,
    IBAMQPBinary32Type      = 0xB0,
    IBAMQPString8Type       = 0xA1,
    IBAMQPString32Type      = 0xB1,
    IBAMQPSymbol8Type       = 0xA3,
    IBAMQPSymbol32Type      = 0xB3,
    IBAMQPList0Type         = 0x45,
    IBAMQPList8Type         = 0xC0,
    IBAMQPList32Type        = 0xD0,
    IBAMQPMap8Type          = 0xC1,
    IBAMQPMap32Type         = 0xD1,
    IBAMQPArray8Type        = 0xE0,
    IBAMQPArray32Type       = 0xF0,
};

@interface IBAMQPType : NSObject

@property (assign, nonatomic) IBAMQPTypes value;

- (instancetype) initWithType : (IBAMQPTypes) type;
+ (instancetype) enumWithType : (IBAMQPTypes) type;

- (NSString *) nameByValue;
- (IBAMQPTypes) valueByName : (NSString *) name;

- (NSDictionary *) items;

@end
