//
//  IBAMQPUnwrapper.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 08.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

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
