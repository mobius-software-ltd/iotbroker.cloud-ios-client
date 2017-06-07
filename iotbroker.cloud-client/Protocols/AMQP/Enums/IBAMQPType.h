//
//  IBAMQPType.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

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
