//
//  IBAMQPAttach.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 08.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPAttach.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPDescribedConstructor.h"

@implementation IBAMQPAttach

- (instancetype)init {
    IBAMQPHeaderCode *code = [IBAMQPHeaderCode enumWithHeaderCode:IBAMQPAttachHeaderCode];
    self = [super initWithCode:code];
    return self;
}

- (NSInteger) getLength {
    
    int length = 8;
    IBAMQPTLVList *arguments = [self arguments];
    length += arguments.length;
    
    return length;
}

- (NSInteger) getMessageType {
    return IBAMQPAttachHeaderCode;
}

- (IBAMQPTLVList *)arguments {
 
    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];

    if (self->_name == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    [list addElementWithIndex:0 element:[IBAMQPWrapper wrapString:self->_name]];
    
    if (self->_handle == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    [list addElementWithIndex:1 element:[IBAMQPWrapper wrapUInt:[self->_handle unsignedIntValue]]];
    
    if (self->_role == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    [list addElementWithIndex:2 element:[IBAMQPWrapper wrapBOOL:self->_role.value]];
    
    if (self->_sendCodes != nil) {
        [list addElementWithIndex:3 element:[IBAMQPWrapper wrapUByte:self->_sendCodes.value]];
    }
    if (self->_receivedCodes != nil) {
        [list addElementWithIndex:4 element:[IBAMQPWrapper wrapUByte:self->_receivedCodes.value]];
    }
    if (self->_source != nil) {
        [list addElementWithIndex:5 element:self->_source.list];
    }
    if (self->_target != nil) {
        [list addElementWithIndex:6 element:self->_target.list];
    }
    if (self->_unsettled != nil) {
        [list addElementWithIndex:7 element:[IBAMQPWrapper wrapMap:self->_unsettled]];
    }
    if (self->_incompleteUnsettled != nil) {
        [list addElementWithIndex:8 element:[IBAMQPWrapper wrapBOOL:[self->_incompleteUnsettled boolValue]]];
    }
    if (self->_initialDeliveryCount != nil) {
        [list addElementWithIndex:9 element:[IBAMQPWrapper wrapUInt:[self->_initialDeliveryCount unsignedIntValue]]];
    } else if (self->_role.value == IBAMQPSenderRoleCode) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    if (self->_maxMessageSize != nil) {
        [list addElementWithIndex:10 element:[IBAMQPWrapper wrapULong:[self->_maxMessageSize unsignedLongValue]]];
    }
    if (self->_offeredCapabilities != nil) {
        [list addElementWithIndex:11 element:[IBAMQPWrapper wrapArray:self->_offeredCapabilities]];
    }
    if (self->_desiredCapabilities != nil) {
        [list addElementWithIndex:12 element:[IBAMQPWrapper wrapArray:self->_desiredCapabilities]];
    }
    if (self->_properties != nil) {
        [list addElementWithIndex:13 element:[IBAMQPWrapper wrapMap:self->_properties]];
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
    
    if (size < 3) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    if (size > 14) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    if (size > 0) {
        IBTLVAMQP *element = [list.list objectAtIndex:0];
        if (element.isNull) {
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
        }
        self->_name = [IBAMQPUnwrapper unwrapString:element];
    }
    if (size > 1) {
        IBTLVAMQP *element = [list.list objectAtIndex:1];
        if (element.isNull) {
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
        }
        self->_handle = @([IBAMQPUnwrapper unwrapUInt:element]);
    }
    if (size > 2) {
        IBTLVAMQP *element = [list.list objectAtIndex:2];
        if (element.isNull) {
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
        }
        self->_role = [IBAMQPRoleCode enumWithRoleCode:[IBAMQPUnwrapper unwrapBOOL:element]];
    }
    if (size > 3) {
        IBTLVAMQP *element = [list.list objectAtIndex:3];
        if (!element.isNull) {
            self->_sendCodes = [IBAMQPSendCode enumWithSendCode:[IBAMQPUnwrapper unwrapUByte:element]];
        }
    }
    if (size > 4) {
        IBTLVAMQP *element = [list.list objectAtIndex:4];
        if (!element.isNull) {
            self->_receivedCodes = [IBAMQPReceiverSettleMode enumWithReceiverSettleMode:[IBAMQPUnwrapper unwrapUByte:element]];
        }
    }
    if (size > 5) {
        IBTLVAMQP *element = [list.list objectAtIndex:5];
        if (!element.isNull) {
            if (element.type != IBAMQPList0Type && element.type != IBAMQPList8Type && element.type != IBAMQPList32Type) {
                @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
            }
            self->_source = [[IBAMQPSource alloc] init];
            [self->_source fill:((IBAMQPTLVList *)element)];
        }
    }
    if (size > 6) {
        IBTLVAMQP *element = [list.list objectAtIndex:6];
        if (!element.isNull) {
            if (element.type != IBAMQPList0Type && element.type != IBAMQPList8Type && element.type != IBAMQPList32Type) {
                @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
            }
            self->_target = [[IBAMQPTarget alloc] init];
            [self->_target fill:((IBAMQPTLVList *)element)];
        }
    }
    if (size > 7) {
        IBTLVAMQP *element = [list.list objectAtIndex:7];
        if (!element.isNull) {
            self->_unsettled = [NSMutableDictionary dictionaryWithDictionary:[IBAMQPUnwrapper unwrapMap:element]];
        }
    }
    if (size > 8) {
        IBTLVAMQP *element = [list.list objectAtIndex:8];
        if (!element.isNull) {
            self->_incompleteUnsettled = @([IBAMQPUnwrapper unwrapBOOL:element]);
        }
    }
    if (size > 9) {
        IBTLVAMQP *element = [list.list objectAtIndex:9];
        if (!element.isNull) {
            self->_initialDeliveryCount = @([IBAMQPUnwrapper unwrapUInt:element]);
        } else if (self->_role.value == IBAMQPSenderRoleCode) {
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
        }
    }
    if (size > 10) {
        IBTLVAMQP *element = [list.list objectAtIndex:10];
        if (!element.isNull) {
            self->_maxMessageSize = @([IBAMQPUnwrapper unwrapULong:element]);
        }
    }
    if (size > 11) {
        IBTLVAMQP *element = [list.list objectAtIndex:11];
        if (!element.isNull) {
            self->_offeredCapabilities = [NSMutableArray arrayWithArray:[IBAMQPUnwrapper unwrapArray:element]];
        }
    }
    if (size > 12) {
        IBTLVAMQP *element = [list.list objectAtIndex:12];
        if (!element.isNull) {
            self->_desiredCapabilities = [NSMutableArray arrayWithArray:[IBAMQPUnwrapper unwrapArray:element]];
        }
    }
    if (size > 13) {
        IBTLVAMQP *element = [list.list objectAtIndex:13];
        if (!element.isNull) {
            self->_properties = [NSMutableDictionary dictionaryWithDictionary:[IBAMQPUnwrapper unwrapMap:element]];
        }
    }
}

- (void) addUnsettled : (NSString *) key value : (NSObject *) value {

    if (key == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    if (self->_unsettled == nil) {
        self->_unsettled = [NSMutableDictionary dictionary];
    }
    [self->_unsettled setObject:value forKey:[[IBAMQPSymbol alloc] initWithString:key]];
}

- (void) addOfferedCapability : (NSArray<NSString *> *) array  {
    if (self->_offeredCapabilities == nil) {
        self->_offeredCapabilities = [NSMutableArray array];
    }
    for (NSString *capability in array) {
        [self->_offeredCapabilities addObject:[[IBAMQPSymbol alloc] initWithString:capability]];
    }
}

- (void) addDesiredCapability : (NSArray<NSString *> *) array {
    if (self->_desiredCapabilities == nil) {
        self->_desiredCapabilities = [NSMutableArray array];
    }
    for (NSString *capability in array) {
        [self->_desiredCapabilities addObject:[[IBAMQPSymbol alloc] initWithString:capability]];
    }
}

- (void) addProperty : (NSString *) key value : (NSObject *) value {
    
    if (self->_properties == nil) {
        self->_properties = [NSMutableDictionary dictionary];
    }
    [self->_properties setObject:value forKey:[[IBAMQPSymbol alloc] initWithString:key]];
}

@end
