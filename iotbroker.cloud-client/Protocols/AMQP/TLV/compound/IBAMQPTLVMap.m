//
//  IBAMQPTLVMap.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPTLVMap.h"

@implementation IBAMQPTLVMap

- (instancetype)init {
    IBAMQPType *type = [IBAMQPType enumWithType:IBAMQPList8Type];
    self = [super initWithConstructor:[[IBAMQPSimpleConstructor alloc] initWithType:type]];
    if (self != nil) {
        self->_width = 1;
        self->_count = 1;
        self->_size = 0;
    }
    return self;
}

- (instancetype)initWithType : (IBAMQPType *) type andMap : (NSDictionary<IBTLVAMQP *, IBTLVAMQP *> *) map {
    self = [super initWithConstructor:[[IBAMQPSimpleConstructor alloc] initWithType:type]];
    if (self != nil) {
        self->_map = [NSMutableDictionary dictionaryWithDictionary:map];
        self->_width = (type.value == IBAMQPMap8Type) ? 1 : 4;
        self->_size += self->_width;
        for (IBTLVAMQP *key in self->_map.allKeys) {
            self->_size += key.length;
            self->_size += [self->_map objectForKey:key].length;
        }
        self->_count = self->_map.count;
    }
    return self;
}

- (void) putElementWithKey : (IBTLVAMQP *) key andValue : (IBTLVAMQP *) value {
    [self->_map setObject:value forKey:key];
    self->_size += key.length + value.length;
    self->_count++;
    [self update];
}

- (NSString *)description {
    NSMutableString *string = [NSMutableString string];
    for (IBTLVAMQP *key in self->_map.allKeys) {
        [string appendString:[key description]];
        [string appendString:@" : "];
        [string appendString:[[self->_map objectForKey:key] description]];
        [string appendString:@"\n"];
    }
    return string;
}

- (void) update {
    if (self->_width == 1 && self->_size > 255) {
        self.constructor.type.value = IBAMQPMap32Type;
        self->_width = 4;
        self->_size += 3;
    }
}

- (NSMutableData *)data {
    
    NSMutableData *sizeData = [NSMutableData data];
    
    if (self->_width == 1) {
        [sizeData appendByte:(Byte)self->_size];
    } else {
        [sizeData appendInt:self->_size];
    }
    
    NSMutableData *countData = [NSMutableData data];
    
    if (self->_width == 1) {
        [countData appendByte:(Byte)(self->_count * 2)];
    } else {
        [countData appendInt:(self->_count * 2)];
    }
    
    NSMutableData *valueData = [NSMutableData data];
    
    NSMutableData *keyData = [NSMutableData data];
    NSMutableData *valData = [NSMutableData data];
    
    for (IBTLVAMQP *key in self->_map.allKeys) {
        keyData = key.data;
        valData = [self->_map objectForKey:key].data;
        [valueData appendData:keyData];
        [valueData appendData:valData];
    }
    
    NSMutableData *bytes = [NSMutableData data];
    
    [bytes appendData:self.constructor.data];
    
    if (self->_size > 0) {
        [bytes appendData:sizeData];
        [bytes appendData:countData];
        [bytes appendData:valueData];
    }
    return bytes;
}

- (NSMutableData *)value {
    return nil;
}

@end
