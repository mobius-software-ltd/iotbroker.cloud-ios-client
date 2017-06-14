//
//  IBAMQPSASLOutcome.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPSASLOutcome.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPDescribedConstructor.h"

@implementation IBAMQPSASLOutcome

- (instancetype)init {
    IBAMQPHeaderCode *code = [IBAMQPHeaderCode enumWithHeaderCode:IBAMQPOutcomeHeaderCode];
    self = [super initWithCode:code];
    self.type = 1;
    return self;
}

- (NSInteger) getLength {
    
    int length = 8;
    IBAMQPTLVList *arguments = [self arguments];
    length += arguments.length;
    
    return length;
}

- (NSInteger) getMessageType {
    return IBAMQPOutcomeHeaderCode;
}

- (IBAMQPTLVList *)arguments {

    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];
    
    if (self->_outcomeCode == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    
    [list addElementWithIndex:0 element:[IBAMQPWrapper wrapUByte:self->_outcomeCode.value]];
    
    if (self->_additionalData != nil) {
        [list addElementWithIndex:1 element:[IBAMQPWrapper wrapBinary:self->_additionalData]];
    }
    
    NSMutableData *data = [NSMutableData data];
    [data appendByte:0x44];
    IBAMQPType *type = [IBAMQPType enumWithType:IBAMQPSmallULongType];
    IBAMQPTLVFixed *fixed = [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
    
    IBAMQPType *constructorType = [[IBAMQPType alloc] initWithType:list.type];
    IBAMQPDescribedConstructor *constructor = [[IBAMQPDescribedConstructor alloc] initWithType:constructorType andDescriptor:fixed];
    
    list.constructor = constructor;
    
    return list;
}

- (void)fillArguments:(IBAMQPTLVList *)list {

    NSInteger size = list.list.count;
    
    if (size == 0) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    
    if (size > 2) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    
    if (size > 0) {
        IBTLVAMQP *element = [list.list objectAtIndex:0];
        if (element.isNull) {
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
        }
        self->_outcomeCode = [IBAMQPSASLCode enumWithSASLCode:[IBAMQPUnwrapper unwrapUByte:element]];
    }
    
    if (size > 1) {
        IBTLVAMQP *element = [list.list objectAtIndex:1];
        if (!element.isNull) {
            self->_additionalData = [NSMutableData dataWithData:[IBAMQPUnwrapper unwrapData:element]];
        }
    }
}

@end
