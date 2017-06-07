//
//  IBAMQPDescribedConstructor.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPDescribedConstructor.h"

@implementation IBAMQPDescribedConstructor

- (instancetype) initWithType:(IBAMQPType *)type andDescriptor:(IBTLVAMQP *)descriptor {
    self = [super initWithType:type];
    if (self != nil) {
        self->_descriptor = descriptor;
    }
    return self;
}

- (NSMutableData *)data {

    NSMutableData *constructorData = [NSMutableData data];
    [constructorData appendByte:0];
    [constructorData appendData:self.descriptor.data];
    [constructorData appendByte:self.type.value];
    return constructorData;
}

- (NSInteger)length {
    return self.descriptor.data.length + 2;
}

- (Byte)descriptorCode {
    Byte *bytes = (Byte *)[self.descriptor.data bytes];
    return bytes[0];
}

@end
