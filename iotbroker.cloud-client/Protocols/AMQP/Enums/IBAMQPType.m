//
//  IBAMQPType.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPType.h"

@implementation IBAMQPType
{
    NSMutableDictionary *_dictionary;
}

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self->_dictionary = [NSMutableDictionary dictionary];
        [self->_dictionary setValue:@(IBAMQPSourceType)         forKey:@"Source"];
        [self->_dictionary setValue:@(IBAMQPTargetType)         forKey:@"Target"];
        [self->_dictionary setValue:@(IBAMQPErrorType)          forKey:@"Error"];
        [self->_dictionary setValue:@(IBAMQPNullType)           forKey:@"Null"];
        [self->_dictionary setValue:@(IBAMQPBooleanType)        forKey:@"Boolean"];
        [self->_dictionary setValue:@(IBAMQPBooleanTrueType)    forKey:@"True"];
        [self->_dictionary setValue:@(IBAMQPBooleanFalseType)   forKey:@"False"];
        [self->_dictionary setValue:@(IBAMQPUByteType)          forKey:@"UByte"];
        [self->_dictionary setValue:@(IBAMQPUShortType)         forKey:@"UShort"];
        [self->_dictionary setValue:@(IBAMQPUIntType)           forKey:@"UInt"];
        [self->_dictionary setValue:@(IBAMQPSmallUIntType)      forKey:@"SmallUint"];
        [self->_dictionary setValue:@(IBAMQPUInt0Type)          forKey:@"UInt0"];
        [self->_dictionary setValue:@(IBAMQPULongType)          forKey:@"ULong"];
        [self->_dictionary setValue:@(IBAMQPSmallULongType)     forKey:@"SmallULong"];
        [self->_dictionary setValue:@(IBAMQPULong0Type)         forKey:@"ULong0"];
        [self->_dictionary setValue:@(IBAMQPByteType)           forKey:@"Byte"];
        [self->_dictionary setValue:@(IBAMQPShortType)          forKey:@"Short"];
        [self->_dictionary setValue:@(IBAMQPIntType)            forKey:@"Int"];
        [self->_dictionary setValue:@(IBAMQPSmallIntType)       forKey:@"SmallInt"];
        [self->_dictionary setValue:@(IBAMQPLongType)           forKey:@"Long"];
        [self->_dictionary setValue:@(IBAMQPSmallLongType)      forKey:@"SmallLong"];
        [self->_dictionary setValue:@(IBAMQPFloatType)          forKey:@"Float"];
        [self->_dictionary setValue:@(IBAMQPDoubleType)         forKey:@"Double"];
        [self->_dictionary setValue:@(IBAMQPDecimal32Type)      forKey:@"Decimal32"];
        [self->_dictionary setValue:@(IBAMQPDecimal64Type)      forKey:@"Decimal64"];
        [self->_dictionary setValue:@(IBAMQPDecimal128Type)     forKey:@"Decimal128"];
        [self->_dictionary setValue:@(IBAMQPCharType)           forKey:@"Chart"];
        [self->_dictionary setValue:@(IBAMQPTimestampType)      forKey:@"Timestamp"];
        [self->_dictionary setValue:@(IBAMQPUUIDType)           forKey:@"UUID"];
        [self->_dictionary setValue:@(IBAMQPBinary8Type)        forKey:@"Binary8"];
        [self->_dictionary setValue:@(IBAMQPBinary32Type)       forKey:@"Binary32"];
        [self->_dictionary setValue:@(IBAMQPString8Type)        forKey:@"String8"];
        [self->_dictionary setValue:@(IBAMQPString32Type)       forKey:@"String32"];
        [self->_dictionary setValue:@(IBAMQPSymbol8Type)        forKey:@"Symbol8"];
        [self->_dictionary setValue:@(IBAMQPSymbol32Type)       forKey:@"Symbol32"];
        [self->_dictionary setValue:@(IBAMQPList0Type)          forKey:@"List0"];
        [self->_dictionary setValue:@(IBAMQPList8Type)          forKey:@"List8"];
        [self->_dictionary setValue:@(IBAMQPList32Type)         forKey:@"List32"];
        [self->_dictionary setValue:@(IBAMQPMap8Type)           forKey:@"Map8"];
        [self->_dictionary setValue:@(IBAMQPMap32Type)          forKey:@"Map32"];
        [self->_dictionary setValue:@(IBAMQPArray8Type)         forKey:@"Array8"];
        [self->_dictionary setValue:@(IBAMQPArray32Type)        forKey:@"Array32"];
    }
    return self;
}

- (instancetype) initWithType : (IBAMQPTypes) type {
    self = [self init];
    if (self != nil) {
        self->_value = type;
    }
    return self;
}

+ (instancetype) enumWithType : (IBAMQPTypes) type {
    return [[IBAMQPType alloc] initWithType:type];
}

- (NSString *) nameByValue {
    for (NSString *key in self->_dictionary.allKeys) {
        NSNumber *number = [self->_dictionary objectForKey:key];
        if ([number unsignedCharValue] == self.value) {
            return key;
        }
    }
    return nil;
}

- (IBAMQPTypes) valueByName : (NSString *) name {
    return [[self->_dictionary objectForKey:name] unsignedCharValue];
}

- (NSDictionary *) items {
    return self->_dictionary;
}

@end
