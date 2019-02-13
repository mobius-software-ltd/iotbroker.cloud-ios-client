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
#import "IBAMQPTLVList.h"
#import "IBAMQPTLVArray.h"
#import "IBAMQPTLVMap.h"
#import "IBAMQPTLVNull.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPTLVVariable.h"
#import "IBAMQPSimpleType.h"

@interface IBAMQPWrapper : NSObject

+ (IBTLVAMQP *) wrapObject : (id) object;

+ (IBTLVAMQP *) wrapBOOL : (BOOL) value;
+ (IBTLVAMQP *) wrapUByte : (short) value;
+ (IBTLVAMQP *) wrapByte : (Byte) value;
+ (IBTLVAMQP *) wrapUInt : (NSInteger) value;
+ (IBTLVAMQP *) wrapInt : (NSInteger) value;
+ (IBTLVAMQP *) wrapULong : (long) value;
+ (IBTLVAMQP *) wrapLong : (long) value;
+ (IBAMQPTLVVariable *) wrapBinary : (NSData *) value;
+ (IBTLVAMQP *) wrapUUID : (NSUUID *) value;
+ (IBTLVAMQP *) wrapUShort : (unsigned short) value;
+ (IBTLVAMQP *) wrapShort : (short) value;
+ (IBTLVAMQP *) wrapDouble : (double) value;
+ (IBTLVAMQP *) wrapFloat : (float) value;
+ (IBTLVAMQP *) wrapChar : (char) value;
+ (IBTLVAMQP *) wrapTimestamp : (NSDate *) value;
+ (IBTLVAMQP *) wrapDecimal32 : (IBAMQPDecimal *) value;
+ (IBTLVAMQP *) wrapDecimal64 : (IBAMQPDecimal *) value;
+ (IBTLVAMQP *) wrapDecimal128 : (IBAMQPDecimal *) value;
+ (IBAMQPTLVVariable *) wrapString : (NSString *) value;
+ (IBAMQPTLVVariable *) wrapSymbol : (IBAMQPSymbol *) value;
+ (IBAMQPTLVList *) wrapList : (NSArray *) value;
+ (IBAMQPTLVMap *) wrapMap : (NSDictionary *) value;
+ (IBAMQPTLVArray *) wrapArray : (NSArray *) value;

@end
