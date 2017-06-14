//
//  IBAMQPReceived.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPReceived.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPDescribedConstructor.h"
#import "IBAMQPTLVFixed.h"

@implementation IBAMQPReceived

- (IBAMQPTLVList *)list {
    
    IBAMQPTLVList *list = [IBAMQPTLVList alloc];
    
    if (self->_sectionNumber != nil) {
        [list addElementWithIndex:0 element:[IBAMQPWrapper wrapUInt:[self->_sectionNumber unsignedIntValue]]];
    }
    if (self->_sectionOffset != nil) {
        [list addElementWithIndex:1 element:[IBAMQPWrapper wrapULong:[self->_sectionOffset unsignedLongValue]]];
    }
    
    NSMutableData *data = [NSMutableData data];
    [data appendByte:0x23];
    IBAMQPType *type = [IBAMQPType enumWithType:IBAMQPSmallULongType];
    IBAMQPTLVFixed *fixed = [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
    
    IBAMQPType *constructorType = [[IBAMQPType alloc] initWithType:list.type];
    IBAMQPDescribedConstructor *constructor = [[IBAMQPDescribedConstructor alloc] initWithType:constructorType andDescriptor:fixed];
    
    list.constructor = constructor;
    
    return list;
}

- (void)fill:(IBAMQPTLVList *)list {

    if (list.list.count > 0) {
        IBTLVAMQP *element = [list.list objectAtIndex:0];
        if (!element.isNull) {
            self->_sectionNumber = @([IBAMQPUnwrapper unwrapUInt:element]);
        }
    }
    
    if (list.list.count > 0) {
        IBTLVAMQP *element = [list.list objectAtIndex:1];
        if (!element.isNull) {
            self->_sectionOffset = @([IBAMQPUnwrapper unwrapULong:element]);
        }
    }
}

@end
