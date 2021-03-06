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

#import "IBAMQPWrapper.h"

@implementation IBAMQPWrapper

+ (IBTLVAMQP *) wrapObject : (id) object {

    if (object == nil) {
        return [[IBAMQPTLVNull alloc] init];
    }
    
    IBTLVAMQP *result = nil;
    
    if ([object isKindOfClass:[IBAMQPSimpleType class]]) {
        IBAMQPSimpleType *simpleType = (IBAMQPSimpleType *)object;
        
        switch (simpleType.type) {
            case IBAMQPBooleanType:     result = [self wrapBOOL:[simpleType.value boolValue]];                break;
            case IBAMQPUByteType:       result = [self wrapUByte:(Byte)[simpleType.value unsignedCharValue]]; break;
            case IBAMQPUShortType:      result = [self wrapUShort:[simpleType.value unsignedShortValue]];     break;
            case IBAMQPUIntType:
            case IBAMQPSmallUIntType:
            case IBAMQPUInt0Type:       result = [self wrapUInt:[simpleType.value unsignedIntValue]];         break;
            case IBAMQPULongType:
            case IBAMQPSmallULongType:
            case IBAMQPULong0Type:      result = [self wrapULong:[simpleType.value unsignedLongValue]];       break;
            case IBAMQPByteType:        result = [self wrapUByte:(Byte)[simpleType.value charValue]];         break;
            case IBAMQPShortType:       result = [self wrapShort:[simpleType.value shortValue]];              break;
            case IBAMQPIntType:
            case IBAMQPSmallIntType:    result = [self wrapInt:[simpleType.value intValue]];                  break;
            case IBAMQPLongType:
            case IBAMQPSmallLongType:   result = [self wrapLong:[simpleType.value longValue]];                break;
            case IBAMQPFloatType:       result = [self wrapFloat:[simpleType.value floatValue]];              break;
            case IBAMQPDoubleType:      result = [self wrapDouble:[simpleType.value doubleValue]];            break;
            case IBAMQPCharType:        result = [self wrapChar:[simpleType.value charValue]];                break;
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

+ (IBAMQPTLVList *) wrapList : (NSArray *) value {

    if (value == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];
    for (NSObject *object in value) {
        [list addElement:[self wrapObject:object]];
    }
    return list;
}

+ (IBAMQPTLVMap *) wrapMap : (NSDictionary *) value {
    
    if (value == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    IBAMQPTLVMap *map = [[IBAMQPTLVMap alloc] init];
    for (NSObject *key in value.allKeys) {
        NSObject *valueItem = [value objectForKey:key];

        IBTLVAMQP *k = [self wrapObject:key];
        IBTLVAMQP *v = [self wrapObject:valueItem];
                
        [map putElementWithKey:k
                      andValue:v];
    }
    return map;
}

+ (IBAMQPTLVArray *) wrapArray : (NSArray *) value {
    
    if (value == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    IBAMQPTLVArray *array = [[IBAMQPTLVArray alloc] init];
    for (NSObject *object in value) {
        [array addElement:[self wrapObject:object]];
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
