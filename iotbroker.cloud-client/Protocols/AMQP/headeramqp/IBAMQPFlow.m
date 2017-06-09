//
//  IBAMQPFlow.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPFlow.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPDescribedConstructor.h"

@implementation IBAMQPFlow

@synthesize code = _code;
@synthesize doff = _doff;
@synthesize type = _type;
@synthesize chanel = _chanel;

- (instancetype)init {
    IBAMQPHeaderCode *code = [IBAMQPHeaderCode enumWithHeaderCode:IBAMQPFlowHeaderCode];
    self = [self initWithCode:code];
    return self;
}

- (IBAMQPTLVList *)arguments {
    
    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];
    
    if (self->_nextIncomingId != nil) {
        [list addElementWithIndex:0 element:[IBAMQPWrapper wrapObject:self->_nextIncomingId withType:IBAMQPUIntType]];
    }
    
    if (self->_incomingWindow == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    [list addElementWithIndex:1 element:[IBAMQPWrapper wrapObject:self->_incomingWindow withType:IBAMQPUIntType]];
    
    if (self->_nextOutgoingId == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    [list addElementWithIndex:2 element:[IBAMQPWrapper wrapObject:self->_nextOutgoingId withType:IBAMQPUIntType]];
    
    if (self->_outgoingWindow == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    [list addElementWithIndex:3 element:[IBAMQPWrapper wrapObject:self->_outgoingWindow withType:IBAMQPUIntType]];
    
    if (self->_handle != nil) {
        [list addElementWithIndex:4 element:[IBAMQPWrapper wrapObject:self->_handle withType:IBAMQPUIntType]];
    }
    
    if (self->_deliveryCount != nil) {
        if (self->_handle != nil) {
            [list addElementWithIndex:5 element:[IBAMQPWrapper wrapObject:self->_deliveryCount withType:IBAMQPUIntType]];
        } else {
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
        }
    }
    
    if (self->_linkCredit != nil) {
        if (self->_handle != nil) {
            [list addElementWithIndex:6 element:[IBAMQPWrapper wrapObject:self->_linkCredit withType:IBAMQPUIntType]];
        } else {
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
        }
    }
    
    if (self->_avaliable != nil) {
        if (self->_handle != nil) {
            [list addElementWithIndex:7 element:[IBAMQPWrapper wrapObject:self->_avaliable withType:IBAMQPUIntType]];
        } else {
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
        }
    }
    
    if (self->_drain != nil) {
        if (self->_handle != nil) {
            [list addElementWithIndex:8 element:[IBAMQPWrapper wrapObject:self->_drain withType:IBAMQPBooleanType]];
        } else {
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
        }
    }
    
    if (self->_echo != nil) {
        [list addElementWithIndex:9 element:[IBAMQPWrapper wrapObject:self->_drain withType:IBAMQPBooleanType]];
    }
    if (self->_properties != nil) {
        [list addElementWithIndex:10 element:[IBAMQPWrapper wrapMap:self->_properties withKeyType:0 valueType:0]];
    }
    
    NSMutableData *data = [NSMutableData data];
    [data appendByte:self.code.value];
    IBAMQPType *type = [IBAMQPType enumWithType:IBAMQPSmallULongType];
    IBAMQPTLVFixed *fixed = [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
    
    IBAMQPType *constructorType = [[IBAMQPType alloc] initWithType:list.type];
    IBAMQPDescribedConstructor *constructor = [[IBAMQPDescribedConstructor alloc] initWithType:constructorType andDescriptor:fixed];
    
    list.constructor = constructor;
    
    return list;
}

- (void)fillArguments:(IBAMQPTLVList *)list {

    NSInteger size = list.list.count;

    if (size < 4) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    
    if (size > 11) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    
    if (size > 0) {
        IBTLVAMQP *element = [list.list objectAtIndex:0];
        if (!element.isNull) {
            self->_nextIncomingId = @([IBAMQPUnwrapper unwrapUInt:element]);
        }
    }
    if (size > 1) {
        IBTLVAMQP *element = [list.list objectAtIndex:1];
        if (!element.isNull) {
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
        }
        self->_incomingWindow = @([IBAMQPUnwrapper unwrapUInt:element]);
    }
    if (size > 2) {
        IBTLVAMQP *element = [list.list objectAtIndex:2];
        if (!element.isNull) {
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
        }
        self->_nextOutgoingId = @([IBAMQPUnwrapper unwrapUInt:element]);
    }
    if (size > 3) {
        IBTLVAMQP *element = [list.list objectAtIndex:3];
        if (!element.isNull) {
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
        }
        self->_outgoingWindow = @([IBAMQPUnwrapper unwrapUInt:element]);
    }
    if (size > 4) {
        IBTLVAMQP *element = [list.list objectAtIndex:4];
        if (!element.isNull) {
            self->_handle = @([IBAMQPUnwrapper unwrapUInt:element]);
        }
    }
    if (size > 5) {
        IBTLVAMQP *element = [list.list objectAtIndex:5];
        if (!element.isNull) {
            if (self->_handle != nil) {
                self->_deliveryCount = @([IBAMQPUnwrapper unwrapUInt:element]);
            } else {
                @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
            }
        }
    }
    if (size > 6) {
        IBTLVAMQP *element = [list.list objectAtIndex:6];
        if (!element.isNull) {
            if (self->_handle != nil) {
                self->_linkCredit = @([IBAMQPUnwrapper unwrapUInt:element]);
            } else {
                @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
            }
        }
    }
    if (size > 7) {
        IBTLVAMQP *element = [list.list objectAtIndex:7];
        if (!element.isNull) {
            if (self->_handle != nil) {
                self->_avaliable = @([IBAMQPUnwrapper unwrapUInt:element]);
            } else {
                @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
            }
        }
    }
    if (size > 8) {
        IBTLVAMQP *element = [list.list objectAtIndex:8];
        if (!element.isNull) {
            if (self->_handle != nil) {
                self->_drain = @([IBAMQPUnwrapper unwrapBOOL:element]);
            } else {
                @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
            }
        }
    }
    if (size > 9) {
        IBTLVAMQP *element = [list.list objectAtIndex:9];
        if (!element.isNull) {
            self->_echo = @([IBAMQPUnwrapper unwrapBOOL:element]);
        }
    }
    if (size > 10) {
        IBTLVAMQP *element = [list.list objectAtIndex:10];
        if (!element.isNull) {
            self->_properties = [NSMutableDictionary dictionaryWithDictionary:[IBAMQPUnwrapper unwrapMap:element]];
        }
    }
}

- (void) addProperty : (NSString *) key value : (NSObject *) value {
    
    if (self->_properties == nil) {
        self->_properties = [NSMutableDictionary dictionary];
    }
    [self->_properties setObject:value forKey:[[IBAMQPSymbol alloc] initWithString:key]];
}

@end
