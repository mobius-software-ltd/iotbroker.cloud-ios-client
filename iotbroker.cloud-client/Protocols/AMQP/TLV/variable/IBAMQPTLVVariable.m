//
//  IBAMQPTLVVariable.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPTLVVariable.h"

@implementation IBAMQPTLVVariable

@synthesize value = _value;

- (instancetype) initWithType : (IBAMQPType *) type andValue : (NSMutableData *) value {
    self = [super initWithConstructor:[[IBAMQPSimpleConstructor alloc] initWithType:type]];
    if (self != nil) {
        self->_value = value;
        self.width = (value.length > 255) ? 4 : 1;
    }
    return self;
}

- (NSMutableData *)data {
    
    NSMutableData *widthData = [NSMutableData data];
    
    if (self.width == 1) {
        [widthData appendByte:(Byte)self.value.length];
    } else if (self.width == 4) {
        [widthData appendInt:self.value.length];
    }
    
    NSMutableData *bytes = [NSMutableData data];
    [bytes appendData:self.constructor.data];
    [bytes appendData:widthData];
    
    if (self.value.length > 0) {
        [bytes appendData:self.value];
    }
    
    return bytes;
}

- (NSInteger)length {
    return self->_value.length + [self.constructor length] + self.width;
}

- (NSMutableData *)value {
    return self->_value;
}

- (id)copyWithZone:(NSZone *)zone {
    
    IBAMQPType *typeCode = [IBAMQPType enumWithType:self.type];
    IBAMQPTLVVariable *copy = [[IBAMQPTLVVariable alloc] initWithType:typeCode andValue:self->_value];
    copy.width = self->_width;
    copy.constructor = self.constructor;
    
    return copy;
}

@end
