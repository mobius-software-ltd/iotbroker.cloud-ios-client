//
//  IBAMQPSimpleConstructor.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPSimpleConstructor.h"

@implementation IBAMQPSimpleConstructor

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self->_type = [[IBAMQPType alloc] init];
    }
    return self;
}

- (instancetype) initWithType : (IBAMQPType *) type {
    self = [self init];
    if (self != nil) {
        self->_type = type;
    }
    return self;
}

- (NSMutableData *)data {
    NSMutableData *data  = [NSMutableData data];
    [data appendByte:self.type.value];
    return data;
}

- (NSInteger)length {
    return 1;
}

- (Byte)descriptorCode {
    return 0;
}

@end
