//
//  IBAMQPRejected.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPRejected.h"
#import "IBAMQPDescribedConstructor.h"
#import "IBAMQPTLVFixed.h"

@implementation IBAMQPRejected

- (IBAMQPTLVList *)list {

    IBAMQPTLVList *list = [IBAMQPTLVList alloc];
    
    if (self->_error != nil) {
        [list addElementWithIndex:0 element:self->_error.list];
    }
    
    NSMutableData *data = [NSMutableData data];
    [data appendByte:0x25];
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
            IBAMQPType *type = [[IBAMQPType alloc] initWithType:element.type];
            if (type.value != IBAMQPList0Type && type.value != IBAMQPList8Type && type.value != IBAMQPList32Type) {
                @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
            }
            self->_error = [[IBAMQPError alloc] init];
            [self->_error fill:(IBAMQPTLVList *)element];
        }
    }
}

@end
