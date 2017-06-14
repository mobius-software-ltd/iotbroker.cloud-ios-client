//
//  IBAMQPWrapper.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

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

@interface IBAMQPWrapper : NSObject

+ (IBTLVAMQP *) wrapObject : (id) object withType : (IBAMQPTypes) type;

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
+ (IBAMQPTLVList *) wrapList : (NSArray *) value withType : (IBAMQPTypes) type;
+ (IBAMQPTLVMap *) wrapMap : (NSDictionary *) value withKeyType : (IBAMQPTypes) keyType valueType : (IBAMQPTypes) valueType;
+ (IBAMQPTLVArray *) wrapArray : (NSArray *) value withType : (IBAMQPTypes) type;

@end
