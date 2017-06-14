//
//  IBAMQPTLVFixed.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPTLVFixed.h"

@implementation IBAMQPTLVFixed

@synthesize value = _value;

- (instancetype) initWithType : (IBAMQPType *) type andValue : (NSMutableData *) value {
    self = [super initWithConstructor:[[IBAMQPSimpleConstructor alloc] initWithType:type]];
    if (self != nil) {
        self->_value = [NSMutableData dataWithData:value];
    }
    return self;
}

- (NSMutableData *)data {
    
    NSMutableData *bytes = [NSMutableData data];

    [bytes appendData:self.constructor.data];
    
    if (self->_value.length > 0) {
        [bytes appendData:self->_value];
    }
    
    return bytes;
}

- (NSInteger)length {
    return self->_value.length + self.constructor.length;
}

- (NSMutableData *)value {
    return self->_value;
}

- (NSString *)description {
    NSString *string = [NSString string];
    
    switch (self.constructor.type.value) {
        case IBAMQPBooleanTrueType:
            string = @"1";
            break;
            
        case IBAMQPBooleanFalseType:
            string = @"0";
            break;
            
        case IBAMQPUInt0Type:
        case IBAMQPULong0Type:
            string = @"0";
            break;
            
        case IBAMQPBooleanType:
        case IBAMQPByteType:
        case IBAMQPUByteType:
        case IBAMQPSmallIntType:
        case IBAMQPSmallLongType:
        case IBAMQPSmallUIntType:
        case IBAMQPSmallULongType:
            string = [NSString stringWithFormat:@"%zd", [self->_value readByte]];
            break;
            
        case IBAMQPShortType:
        case IBAMQPUShortType:
            string = [NSString stringWithFormat:@"%zd", [self->_value readShort]];
            break;
            
        case IBAMQPCharType:
        case IBAMQPDecimal32Type:
        case IBAMQPFloatType:
        case IBAMQPIntType:
        case IBAMQPUIntType:
            string = [NSString stringWithFormat:@"%zd", [self->_value readInt]];
            break;
            
        case IBAMQPDecimal64Type:
        case IBAMQPDoubleType:
        case IBAMQPLongType:
        case IBAMQPULongType:
        case IBAMQPTimestampType:
            string = [NSString stringWithFormat:@"%zd", [self->_value numberWithLength:8]];
            break;

        case IBAMQPDecimal128Type:
            string = @"decimal-128";
            break;
            
        case IBAMQPUUIDType:
            string = [[NSString alloc] initWithData:self->_value encoding:NSUTF8StringEncoding];
            break;
            
        default:
            break;
    }
    return string;
}

- (id)copyWithZone:(NSZone *)zone {
    
    IBAMQPType *typeCode = [IBAMQPType enumWithType:self.type];
    IBAMQPTLVFixed *copy = [[IBAMQPTLVFixed alloc] initWithType:typeCode andValue:self->_value];
    copy.constructor = self.constructor;
    
    return copy;
}

@end
