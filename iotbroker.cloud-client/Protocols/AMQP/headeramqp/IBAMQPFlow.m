/**
 * Mobius Software LTD
 * Copyright 2015-2017, Mobius Software LTD
 *
 * This is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 2.1 of
 * the License, or (at your option) any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this software; if not, write to the Free
 * Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA, or see the FSF site: http://www.fsf.org.
 */

#import "IBAMQPFlow.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPDescribedConstructor.h"

@implementation IBAMQPFlow

- (instancetype)init {
    IBAMQPHeaderCode *code = [IBAMQPHeaderCode enumWithHeaderCode:IBAMQPFlowHeaderCode];
    self = [self initWithCode:code];
    return self;
}

- (NSInteger) getLength {
    
    int length = 8;
    IBAMQPTLVList *arguments = [self arguments];
    length += arguments.length;
    
    return length;
}

- (NSInteger) getMessageType {
    return IBAMQPFlowHeaderCode;
}

- (IBAMQPTLVList *)arguments {
    
    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];
    
    if (self->_nextIncomingId != nil) {
        [list addElementWithIndex:0 element:[IBAMQPWrapper wrapUInt:[self->_nextIncomingId unsignedIntValue]]];
    }
    
    if (self->_incomingWindow == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    [list addElementWithIndex:1 element:[IBAMQPWrapper wrapUInt:[self->_incomingWindow unsignedIntValue]]];
    
    if (self->_nextOutgoingId == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    [list addElementWithIndex:2 element:[IBAMQPWrapper wrapUInt:[self->_nextOutgoingId unsignedIntValue]]];
    
    if (self->_outgoingWindow == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    [list addElementWithIndex:3 element:[IBAMQPWrapper wrapUInt:[self->_outgoingWindow unsignedIntValue]]];
    
    if (self->_handle != nil) {
        [list addElementWithIndex:4 element:[IBAMQPWrapper wrapUInt:[self->_handle unsignedIntValue]]];
    }
    
    if (self->_deliveryCount != nil) {
        if (self->_handle != nil) {
            [list addElementWithIndex:5 element:[IBAMQPWrapper wrapUInt:[self->_deliveryCount unsignedIntValue]]];
        } else {
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
        }
    }
    
    if (self->_linkCredit != nil) {
        if (self->_handle != nil) {
            [list addElementWithIndex:6 element:[IBAMQPWrapper wrapUInt:[self->_linkCredit unsignedIntValue]]];
        } else {
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
        }
    }
    
    if (self->_avaliable != nil) {
        if (self->_handle != nil) {
            [list addElementWithIndex:7 element:[IBAMQPWrapper wrapUInt:[self->_avaliable unsignedIntValue]]];
        } else {
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
        }
    }
    
    if (self->_drain != nil) {
        if (self->_handle != nil) {
            [list addElementWithIndex:8 element:[IBAMQPWrapper wrapBOOL:[self->_drain boolValue]]];
        } else {
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
        }
    }
    
    if (self->_echo != nil) {
        [list addElementWithIndex:9 element:[IBAMQPWrapper wrapBOOL:[self->_drain boolValue]]];
    }
    if (self->_properties != nil) {
        [list addElementWithIndex:10 element:[IBAMQPWrapper wrapMap:self->_properties]];
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
        if (element.isNull) {
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
        }
        self->_incomingWindow = @([IBAMQPUnwrapper unwrapUInt:element]);
    }
    if (size > 2) {
        IBTLVAMQP *element = [list.list objectAtIndex:2];
        if (element.isNull) {
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
        }
        self->_nextOutgoingId = @([IBAMQPUnwrapper unwrapUInt:element]);
    }
    if (size > 3) {
        IBTLVAMQP *element = [list.list objectAtIndex:3];
        if (element.isNull) {
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
