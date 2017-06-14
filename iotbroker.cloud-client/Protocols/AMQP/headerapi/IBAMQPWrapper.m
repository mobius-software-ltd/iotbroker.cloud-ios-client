//
//  IBAMQPWrapper.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPWrapper.h"

@implementation IBAMQPWrapper

+ (IBTLVAMQP *) wrapObject : (id) object withType : (IBAMQPTypes) type {

    if (object == nil) {
        return [[IBAMQPTLVNull alloc] init];
    }
    
    IBTLVAMQP *result = nil;
    
    if ([object isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)object;
        
        switch (type) {
            case IBAMQPBooleanType:     result = [self wrapBOOL:[number boolValue]];                break;
            case IBAMQPUByteType:       result = [self wrapUByte:(Byte)[number unsignedCharValue]]; break;
            case IBAMQPUShortType:      result = [self wrapUShort:[number unsignedShortValue]];     break;
            case IBAMQPUIntType:
            case IBAMQPSmallUIntType:
            case IBAMQPUInt0Type:       result = [self wrapUInt:[number unsignedIntValue]];         break;
            case IBAMQPULongType:
            case IBAMQPSmallULongType:
            case IBAMQPULong0Type:      result = [self wrapULong:[number unsignedLongValue]];       break;
            case IBAMQPByteType:        result = [self wrapUByte:(Byte)[number charValue]];         break;
            case IBAMQPShortType:       result = [self wrapShort:[number shortValue]];              break;
            case IBAMQPIntType:
            case IBAMQPSmallIntType:    result = [self wrapInt:[number intValue]];                  break;
            case IBAMQPLongType:
            case IBAMQPSmallLongType:   result = [self wrapLong:[number longValue]];                break;
            case IBAMQPFloatType:       result = [self wrapFloat:[number floatValue]];              break;
            case IBAMQPDoubleType:      result = [self wrapDouble:[number doubleValue]];            break;
            case IBAMQPCharType:        result = [self wrapChar:[number charValue]];                break;
            default: break;
        }
        
    } else if ([object isKindOfClass:[NSDate class]]) {
        NSDate *date = (NSDate *)object;
        result = [self wrapTimestamp:date];
        
    } else if ([object isKindOfClass:[NSString class]]) {
        NSString *string = (NSString *)object;
        result = [self wrapString:string];
        
    } else if ([object isKindOfClass:[IBAMQPSymbol class]]) {
        IBAMQPSymbol *symbol = (IBAMQPSymbol *)object;
        result = [self wrapSymbol:symbol];
        
    } else if ([object isKindOfClass:[NSUUID class]]) {
        NSUUID *uuid = (NSUUID *)object;
        result = [self wrapUUID:uuid];
        
    } else if ([object isKindOfClass:[NSData class]]) {
        NSData *data = (NSData *)object;
        result = [self wrapBinary:data];
        
    } else if ([object isKindOfClass:[IBAMQPDecimal class]]) {
        IBAMQPDecimal *decimal = (IBAMQPDecimal *)object;
        if (decimal.value.length == 4) {
            result = [self wrapDecimal32:decimal];
        } else if (decimal.value.length == 8) {
            result = [self wrapDecimal64:decimal];
        } else if (decimal.value.length == 16) {
            result = [self wrapDecimal128:decimal];
        }
    } else {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    
    return result;
}

+ (IBTLVAMQP *) wrapBOOL : (BOOL) value {
    
    NSMutableData *data = [NSMutableData data];
    IBAMQPType *type = [[IBAMQPType alloc] init];
    type.value = value ? IBAMQPBooleanTrueType : IBAMQPBooleanFalseType;
    return [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
}

+ (IBTLVAMQP *) wrapUByte : (short) value {
    
    if (value < 0) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }

    NSMutableData *data = [NSMutableData data];
    IBAMQPType *type = [[IBAMQPType alloc] initWithType:IBAMQPUByteType];
    [data appendByte:value];
    return [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
}

+ (IBTLVAMQP *) wrapByte : (Byte) value {

    NSMutableData *data = [NSMutableData data];
    IBAMQPType *type = [[IBAMQPType alloc] initWithType:IBAMQPByteType];
    [data appendByte:value];
    return [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
}

+ (IBTLVAMQP *) wrapUInt : (NSInteger) value {

    if (value < 0) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    
    NSMutableData *data = [self convertUInt:value];
    IBAMQPType *type = nil;
    
    if (data.length == 0) {
        type = [[IBAMQPType alloc] initWithType:IBAMQPUInt0Type];
    } else if (data.length == 1) {
        type = [[IBAMQPType alloc] initWithType:IBAMQPSmallUIntType];
    } else if (data.length > 1) {
        type = [[IBAMQPType alloc] initWithType:IBAMQPUIntType];
    }
    return [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
}

+ (IBTLVAMQP *) wrapInt : (NSInteger) value {

    NSMutableData *data = [self convertInt:(int)value];
    IBAMQPType *type = [[IBAMQPType alloc] init];
    type.value = (data.length > 1) ? IBAMQPIntType : IBAMQPSmallIntType;
    return [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
}

+ (IBTLVAMQP *) wrapULong : (long) value {

    if (value < 0) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    
    NSMutableData *data = [self convertULong:value];
    IBAMQPType *type = nil;

    if (data.length == 0) {
        type = [[IBAMQPType alloc] initWithType:IBAMQPULong0Type];
    } else if (data.length == 1) {
        type = [[IBAMQPType alloc] initWithType:IBAMQPSmallULongType];
    } else if (data.length > 1) {
        type = [[IBAMQPType alloc] initWithType:IBAMQPULongType];
    }
    return [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
}

+ (IBTLVAMQP *) wrapLong : (long) value {
    
    NSMutableData *data = [self convertLong:value];
    IBAMQPType *type = [[IBAMQPType alloc] init];
    type.value = (data.length > 1) ? IBAMQPLongType : IBAMQPSmallLongType;
    return [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
}

+ (IBAMQPTLVVariable *) wrapBinary : (NSData *) value {

    if (value == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    IBAMQPType *type = [[IBAMQPType alloc] init];
    type.value = (value.length > 255) ? IBAMQPBinary32Type : IBAMQPBinary8Type;
    return [[IBAMQPTLVVariable alloc] initWithType:type andValue:[NSMutableData dataWithData:value]];
}

+ (IBTLVAMQP *) wrapUUID : (NSUUID *) value {
   
    if (value == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    IBAMQPType *type = [[IBAMQPType alloc] initWithType:IBAMQPUUIDType];
    NSData *data = [[value UUIDString] dataUsingEncoding:NSUTF8StringEncoding];
    return [[IBAMQPTLVFixed alloc] initWithType:type andValue:[NSMutableData dataWithData:data]];
}

+ (IBTLVAMQP *) wrapUShort : (unsigned short) value {
    if (value < 0) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    IBAMQPType *type = [[IBAMQPType alloc] initWithType:IBAMQPUShortType];
    NSMutableData *data = [NSMutableData data];
    [data appendShort:value];
    return [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
}

+ (IBTLVAMQP *) wrapShort : (short) value {
    
    IBAMQPType *type = [[IBAMQPType alloc] initWithType:IBAMQPShortType];
    NSMutableData *data = [NSMutableData data];
    [data appendShort:value];
    return [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
}

+ (IBTLVAMQP *) wrapDouble : (double) value {

    IBAMQPType *type = [[IBAMQPType alloc] initWithType:IBAMQPDoubleType];
    NSMutableData *data = [NSMutableData data];
    [data appendDouble:value];
    return [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
}

+ (IBTLVAMQP *) wrapFloat : (float) value {
    
    IBAMQPType *type = [[IBAMQPType alloc] initWithType:IBAMQPFloatType];
    NSMutableData *data = [NSMutableData data];
    [data appendFloat:value];
    return [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
}

+ (IBTLVAMQP *) wrapChar : (char) value {

    IBAMQPType *type = [[IBAMQPType alloc] initWithType:IBAMQPCharType];
    NSMutableData *data = [NSMutableData data];
    [data appendInt:value];
    return [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
}

+ (IBTLVAMQP *) wrapTimestamp : (NSDate *) value {

    if (value == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    IBAMQPType *type = [[IBAMQPType alloc] initWithType:IBAMQPTimestampType];
    NSMutableData *data = [NSMutableData data];
    [data appendDouble:[value timeIntervalSince1970]];
    return [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
}

+ (IBTLVAMQP *) wrapDecimal32 : (IBAMQPDecimal *) value {

    if (value == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    IBAMQPType *type = [[IBAMQPType alloc] initWithType:IBAMQPDecimal32Type];
    return [[IBAMQPTLVFixed alloc] initWithType:type andValue:value.value];
}

+ (IBTLVAMQP *) wrapDecimal64 : (IBAMQPDecimal *) value {
    
    if (value == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    IBAMQPType *type = [[IBAMQPType alloc] initWithType:IBAMQPDecimal64Type];
    return [[IBAMQPTLVFixed alloc] initWithType:type andValue:value.value];
}

+ (IBTLVAMQP *) wrapDecimal128 : (IBAMQPDecimal *) value {
    
    if (value == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    IBAMQPType *type = [[IBAMQPType alloc] initWithType:IBAMQPDecimal128Type];
    return [[IBAMQPTLVFixed alloc] initWithType:type andValue:value.value];
}

+ (IBAMQPTLVVariable *) wrapString : (NSString *) value {
    
    if (value == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    IBAMQPType *type = [[IBAMQPType alloc] init];

    type.value = (value.length > 255) ? IBAMQPString32Type : IBAMQPString8Type;
    NSMutableData *data = [NSMutableData dataWithData:[value dataUsingEncoding:NSUTF8StringEncoding]];
    return [[IBAMQPTLVVariable alloc] initWithType:type andValue:data];
}

+ (IBAMQPTLVVariable *) wrapSymbol : (IBAMQPSymbol *) value {

    if (value == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    IBAMQPType *type = [[IBAMQPType alloc] init];
    NSMutableData *data = [NSMutableData dataWithData:[value.value dataUsingEncoding:NSUTF8StringEncoding]];
    type.value = (data.length > 255) ? IBAMQPSymbol32Type : IBAMQPSymbol8Type;
    return [[IBAMQPTLVVariable alloc] initWithType:type andValue:data];
}

+ (IBAMQPTLVList *) wrapList : (NSArray *) value withType : (IBAMQPTypes) type {

    if (value == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];
    for (NSObject *object in value) {
        [list addElement:[self wrapObject:object withType:type]];
    }
    return list;
}

+ (IBAMQPTLVMap *) wrapMap : (NSDictionary *) value withKeyType : (IBAMQPTypes) keyType valueType : (IBAMQPTypes) valueType {
    
    if (value == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    IBAMQPTLVMap *map = [[IBAMQPTLVMap alloc] init];
    for (NSObject *key in value.allKeys) {
        NSObject *valueItem = [value objectForKey:key];

        IBTLVAMQP *k = [self wrapObject:key withType:keyType];
        IBTLVAMQP *v = [self wrapObject:valueItem withType:valueType];
        
        [map putElementWithKey:k
                      andValue:v];
    }
    return map;
}

+ (IBAMQPTLVArray *) wrapArray : (NSArray *) value withType : (IBAMQPTypes) type {
    
    if (value == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    IBAMQPTLVArray *array = [[IBAMQPTLVArray alloc] init];
    for (NSObject *object in value) {
        [array addElement:[self wrapObject:object withType:type]];
    }

    return array;
}

#pragma mark - Private methods

+ (NSMutableData *) convertUInt : (NSInteger) number {

    NSMutableData *data = [NSMutableData data];
    
    if (number == 0) {
        return data;
    } else if (number > 0 && number <= 255) {
        [data appendByte:(Byte)number];
        return data;
    } else {
        [data appendInt:number];
        return data;
    }
}

+ (NSMutableData *) convertInt : (int) number {
    
    NSMutableData *data = [NSMutableData data];

    if (number == 0) {
        return data;
    } else if (number >= -128 && number <= 127) {
        [data appendByte:(Byte)number];
        return data;
    } else {
        [data appendInt:number];
        return data;
    }
}

+ (NSMutableData *) convertULong : (long) number {
    
    NSMutableData *data = [NSMutableData data];

    if (number == 0) {
        return data;
    } else if (number >= 0 && number <= 255) {
        [data appendByte:(Byte)number];
        return data;
    } else {
        [data appendLong:number];
        return data;
    }
}

+ (NSMutableData *) convertLong : (long) number {
    
    NSMutableData *data = [NSMutableData data];

    if (number == 0) {
        return data;
    } else if (number >= -128 && number <= 127) {
        [data appendByte:(Byte)number];
        return data;
    } else {
        [data appendLong:number];
        return data;
    }
}

@end
