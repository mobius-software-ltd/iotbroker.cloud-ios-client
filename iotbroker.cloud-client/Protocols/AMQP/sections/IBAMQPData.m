//
//  IBAMQPData.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPData.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPTLVNull.h"
#import "IBAMQPDescribedConstructor.h"
#import "IBAMQPTLVFixed.h"

@implementation IBAMQPData

@synthesize value = _value;
@synthesize code = _code;

- (IBTLVAMQP *)value {

    IBTLVAMQP *bin = nil;
    
    if (self->_data != nil) {
        bin = [IBAMQPWrapper wrapObject:bin];
    } else {
        bin = [[IBAMQPTLVNull alloc] init];
    }
    
    NSMutableData *data = [NSMutableData data];
    [data appendByte:0x75];
    IBAMQPType *type = [IBAMQPType enumWithType:IBAMQPSmallULongType];
    IBAMQPTLVFixed *fixed = [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
    
    IBAMQPType *constructorType = [[IBAMQPType alloc] initWithType:bin.type];
    IBAMQPDescribedConstructor *constructor = [[IBAMQPDescribedConstructor alloc] initWithType:constructorType andDescriptor:fixed];
    
    bin.constructor = constructor;
    
    return bin;
}

- (void)fill:(IBTLVAMQP *)value {
    if (!value.isNull) {
        self->_data = [NSMutableData dataWithData:[IBAMQPUnwrapper unwrapData:value]];
    }
}

- (IBAMQPSectionCode *)code {
    return [IBAMQPSectionCode enumWithSectionCode:IBAMQPDataSectionCode];
}

@end
