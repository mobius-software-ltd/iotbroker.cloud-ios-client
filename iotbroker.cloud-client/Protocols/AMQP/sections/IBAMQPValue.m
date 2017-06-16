//
//  IBAMQPValue.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPValue.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPDescribedConstructor.h"
#import "IBAMQPTLVNull.h"

@implementation IBAMQPValue

- (IBTLVAMQP *)value {

    IBTLVAMQP *val = self->_valueObject != nil ? [IBAMQPWrapper wrapObject:self->_valueObject] : [[IBAMQPTLVNull alloc] init];
    
    NSMutableData *data = [NSMutableData data];
    [data appendByte:0x77];
    IBAMQPType *type = [IBAMQPType enumWithType:IBAMQPSmallULongType];
    IBAMQPTLVFixed *fixed = [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
    
    IBAMQPType *constructorType = [[IBAMQPType alloc] initWithType:val.type];
    IBAMQPDescribedConstructor *constructor = [[IBAMQPDescribedConstructor alloc] initWithType:constructorType andDescriptor:fixed];
    
    val.constructor = constructor;
    
    return val;
}

- (void)fill:(IBTLVAMQP *)value {
    if (!value.isNull) {
        self->_valueObject = [IBAMQPUnwrapper unwrapList:value];
    }
}

- (IBAMQPSectionCode *)code {
    return [[IBAMQPSectionCode alloc] initWithSectionCode:IBAMQPValueSectionCode];
}

@end
