//
//  IBAMQPTLVArray.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPTLVArray.h"

@implementation IBAMQPTLVArray

- (instancetype)init {
    IBAMQPType *type = [IBAMQPType enumWithType:IBAMQPArray8Type];
    self = [super initWithConstructor:[[IBAMQPSimpleConstructor alloc] initWithType:type]];
    if (self != nil) {
        self->_width = 1;
        self->_count = 0;
        self->_size = 0;
    }
    return self;
}

- (instancetype) initWithType : (IBAMQPType *) type andElements : (NSArray<IBTLVAMQP *> *) elements {
    self = [super initWithConstructor:[[IBAMQPSimpleConstructor alloc] initWithType:type]];
    if (self != nil) {
        self->_elements = [NSMutableArray arrayWithArray:elements];
        self->_width = (type.value == IBAMQPArray8Type) ? 1 : 4;
        self->_size += self->_width;
        for (IBTLVAMQP *element in self->_elements) {
            self->_size += element.length - element.constructor.length;
            if (self->_elementContructor == nil && element != nil) {
                self->_elementContructor = element.constructor;
            }
        }
        self->_size = self->_elementContructor.length;
        self->_count = self->_elements.count;
    }
    return self;
}

- (void) addElement : (IBTLVAMQP *) element {
    if (element.length == 0) {
        self->_elementContructor = element.constructor;
        self->_size += self->_width;
        self->_size += self->_elementContructor.length;
    }
    [self->_elements addObject:element];
    self->_count++;
    self->_size += element.length - self->_elementContructor.length;
    if (self->_width == 1 && self->_size > 255) {
        self.constructor.type.value = IBAMQPArray32Type;
        self->_width = 4;
        self->_size += 3;
    }
}

- (NSMutableData *)data {
    
    NSMutableData *sizeData = [NSMutableData data];
    
    if (self->_width == 1) {
        [sizeData appendByte:(Byte)self->_size];
    } else if (self->_width == 4) {
        [sizeData appendInt:self->_size];
    }
    
    NSMutableData *countData = [NSMutableData data];

    if (self->_width == 1) {
        [countData appendByte:(Byte)self->_count];
    } else if (self->_width == 4) {
        [countData appendInt:self->_count];
    }
    
    NSMutableData *elementConstructorData = self->_elementContructor.data;
    NSMutableData *valueData = [NSMutableData data];
    NSMutableData *tlvData = [NSMutableData data];
    
    for (IBTLVAMQP *item in self->_elements) {
        tlvData = item.data;
        [valueData appendData:tlvData];
    }
    
    NSMutableData *bytes = [NSMutableData data];
    
    [bytes appendData:self.constructor.data];
    
    if (self->_size > 0) {
        [bytes appendData:sizeData];
        [bytes appendData:countData];
        [bytes appendData:elementConstructorData];
        [bytes appendData:valueData];
    }
    return bytes;
}

- (NSString *)description {
    NSMutableString *string = [NSMutableString string];
    for (IBTLVAMQP *element in self->_elements) {
        [string appendFormat:@"%@\n", [element description]];
    }
    return string;
}

- (NSInteger)length {
    return self.constructor.length + self->_size + self->_width;
}

- (NSMutableData *)value {
    return nil;
}

- (BOOL)isNull {
    IBAMQPType *type = self.constructor.type;
    if (type.value == IBAMQPNullType) {
        return true;
    }
    if (type.value == IBAMQPArray8Type || type.value == IBAMQPArray32Type) {
        if (self->_elements.count == 0) {
            return true;
        }
    }
    return false;
}

@end
