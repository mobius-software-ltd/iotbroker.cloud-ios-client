//
//  IBAMQPSASLInit.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPSASLInit.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPDescribedConstructor.h"

@implementation IBAMQPSASLInit

- (instancetype)init {
    IBAMQPHeaderCode *code = [IBAMQPHeaderCode enumWithHeaderCode:IBAMQPInitHeaderCode];
    self = [super initWithCode:code];
    if (self != nil) {
        self->_mechanism = [[IBAMQPSymbol alloc] init];
        self.type = 1;
    }
    return self;
}

- (NSInteger) getLength {
    
    int length = 8;
    IBAMQPTLVList *arguments = [self arguments];
    length += arguments.length;
    
    return length;
}

- (NSInteger) getMessageType {
    return IBAMQPInitHeaderCode;
}

- (IBAMQPTLVList *)arguments {

    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];
    
    if (self->_mechanism == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    
    [list addElementWithIndex:0 element:[IBAMQPWrapper wrapSymbol:self->_mechanism]];
    
    if (self->_initialResponse != nil) {
        [list addElementWithIndex:1 element:[IBAMQPWrapper wrapBinary:self->_initialResponse]];
    }
    if (self->_hostName != nil) {
        [list addElementWithIndex:2 element:[IBAMQPWrapper wrapString:self->_hostName]];
    }
    
    NSMutableData *data = [NSMutableData data];
    [data appendByte:0x41];
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
    
    if (size > 3) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    
    if (size > 0) {
        IBTLVAMQP *element = [list.list objectAtIndex:0];
        if (element.isNull) {
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
        }
        self->_mechanism = [IBAMQPUnwrapper unwrapSymbol:element];
    }
    if (size > 1) {
        IBTLVAMQP *element = [list.list objectAtIndex:1];
        if (!element.isNull) {
            self->_initialResponse = [NSMutableData dataWithData:[IBAMQPUnwrapper unwrapData:element]];
        }
    }
    if (size > 2) {
        IBTLVAMQP *element = [list.list objectAtIndex:2];
        if (!element.isNull) {
            self->_hostName = [IBAMQPUnwrapper unwrapString:element];
        }
    }
}

@end
