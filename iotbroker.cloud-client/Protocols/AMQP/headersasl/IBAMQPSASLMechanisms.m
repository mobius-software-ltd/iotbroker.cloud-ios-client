//
//  IBAMQPSASLMechanisms.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPSASLMechanisms.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPDescribedConstructor.h"

@implementation IBAMQPSASLMechanisms

- (instancetype)init {
    IBAMQPHeaderCode *code = [IBAMQPHeaderCode enumWithHeaderCode:IBAMQPMechanismsHeaderCode];
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
    return IBAMQPMechanismsHeaderCode;
}

- (IBAMQPTLVList *)arguments {

    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];
    
    if (self->_mechanisms == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    
    [list addElementWithIndex:0 element:[IBAMQPWrapper wrapArray:self->_mechanisms withType:0]];
    
    NSMutableData *data = [NSMutableData data];
    [data appendByte:0x40];
    IBAMQPType *type = [IBAMQPType enumWithType:IBAMQPSmallULongType];
    IBAMQPTLVFixed *fixed = [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
    
    IBAMQPType *constructorType = [[IBAMQPType alloc] initWithType:list.type];
    IBAMQPDescribedConstructor *constructor = [[IBAMQPDescribedConstructor alloc] initWithType:constructorType andDescriptor:fixed];
    
    list.constructor = constructor;
    
    return list;
}

- (void)fillArguments:(IBAMQPTLVList *)list {
    if (list.list.count > 0) {
        IBTLVAMQP *element = [list.list objectAtIndex:0];
        if (!element.isNull) {
            self->_mechanisms = [NSMutableArray arrayWithArray:[IBAMQPUnwrapper unwrapArray:element]];
        }
    }
}

- (void) addMechanism : (NSString *) value {
    if (self->_mechanisms == nil) {
        self->_mechanisms = [NSMutableArray array];
    }
    if (value == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    [self->_mechanisms addObject:[[IBAMQPSymbol alloc] initWithString:value]];
}

@end
