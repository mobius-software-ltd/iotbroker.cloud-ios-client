//
//  IBAMQPWrapper.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPWrapper.h"
#import "IBAMQPDecimal.h"
#import "IBAMQPSymbol.h"
#import "IBAMQPTLVList.h"

@implementation IBAMQPWrapper

+ (IBTLVAMQP *) wrapBOOL : (BOOL *) value {
    
    NSMutableData *data = [NSMutableData data];
    IBAMQPType *type = [[IBAMQPType alloc] init];
    type.value = value ? IBAMQPBooleanTrueType : IBAMQPBooleanFalseType;
    return [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
}

+ (IBTLVAMQP *) wrapUByte : (Byte) value {
    
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

+ (IBTLVAMQP *) wrapBinary : (NSData *) value {

    if (value == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    IBAMQPType *type = [[IBAMQPType alloc] init];
    type.value = (value.length > 255) ? IBAMQPBinary32Type : IBAMQPBinary8Type;
    return [[IBAMQPTLVFixed alloc] initWithType:type andValue:[NSMutableData dataWithData:value]];
}

+ (IBTLVAMQP *) wrapUUID : (NSUUID *) value {
   
    if (value == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    IBAMQPType *type = [[IBAMQPType alloc] initWithType:IBAMQPUUIDType];
    NSData *data = [[value UUIDString] dataUsingEncoding:NSUTF8StringEncoding];
    return [[IBAMQPTLVFixed alloc] initWithType:type andValue:[NSMutableData dataWithData:data]];
}

+ (IBTLVAMQP *) wrapUShort : (short) value {

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
    [data appendLong:[value timeIntervalSince1970]];
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

+ (IBTLVAMQP *) wrapString : (NSString *) value {
    
    if (value == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    IBAMQPType *type = [[IBAMQPType alloc] init];
    type.value = (value.length > 255) ? IBAMQPString32Type : IBAMQPString8Type;
    NSMutableData *data = [NSMutableData dataWithData:[value dataUsingEncoding:NSUTF8StringEncoding]];
    return [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
}

+ (IBTLVAMQP *) wrapSymbol : (IBAMQPSymbol *) value {

    if (value == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    IBAMQPType *type = [[IBAMQPType alloc] init];
    NSMutableData *data = [NSMutableData dataWithData:[value.value dataUsingEncoding:NSUTF8StringEncoding]];
    type.value = (data.length > 255) ? IBAMQPSymbol32Type : IBAMQPSymbol8Type;
    return [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
}

+ (IBTLVAMQP *) wrapList : (NSArray *) value {

    if (value == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];
#warning !!!
    return nil;
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
