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
#import "IBTLVAMQP.h"
#import "IBAMQPDecimal.h"
#import "IBAMQPSymbol.h"

@interface IBAMQPUnwrapper : NSObject

+ (id) unwrap : (IBTLVAMQP *) value;

+ (short) unwrapUByte : (IBTLVAMQP *) tlv;
+ (Byte) unwrapByte : (IBTLVAMQP *) tlv;
+ (int) unwrapUShort : (IBTLVAMQP *) tlv;
+ (short) unwrapShort : (IBTLVAMQP *) tlv;
+ (long) unwrapUInt : (IBTLVAMQP *) tlv;
+ (int) unwrapInt : (IBTLVAMQP *) tlv;
+ (unsigned long) unwrapULong : (IBTLVAMQP *) tlv;
+ (long) unwrapLong : (IBTLVAMQP *) tlv;
+ (BOOL) unwrapBOOL : (IBTLVAMQP *) tlv;
+ (double) unwrapDouble : (IBTLVAMQP *) tlv;
+ (float) unwrapFloat : (IBTLVAMQP *) tlv;
+ (NSDate *) unwrapTimestamp : (IBTLVAMQP *) tlv;
+ (IBAMQPDecimal *) unwrapDecimal : (IBTLVAMQP *) tlv;
+ (int) unwrapChar : (IBTLVAMQP *) tlv;
+ (NSString *) unwrapString : (IBTLVAMQP *) tlv;
+ (IBAMQPSymbol *) unwrapSymbol : (IBTLVAMQP *) tlv;
+ (NSData *) unwrapData : (IBTLVAMQP *) tlv;
+ (NSUUID *) unwrapUUID : (IBTLVAMQP *) tlv;
+ (NSArray *) unwrapList : (IBTLVAMQP *) tlv;
+ (NSDictionary *) unwrapMap : (IBTLVAMQP *) tlv;
+ (NSArray *) unwrapArray : (IBTLVAMQP *) tlv;

@end
