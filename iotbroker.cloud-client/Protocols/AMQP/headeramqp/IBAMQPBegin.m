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

#import "IBAMQPBegin.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPDescribedConstructor.h"

@implementation IBAMQPBegin

- (instancetype)init {
    IBAMQPHeaderCode *code = [IBAMQPHeaderCode enumWithHeaderCode:IBAMQPBeginHeaderCode];
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
    return IBAMQPBeginHeaderCode;
}

- (IBAMQPTLVList *)arguments {

    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];
    
    if (self->_remoteChannel != nil) {
        [list addElementWithIndex:0 element:[IBAMQPWrapper wrapUShort:[self->_remoteChannel unsignedShortValue]]];
    }
    if (self->_nextOutgoingID == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    [list addElementWithIndex:1 element:[IBAMQPWrapper wrapUInt:[self->_nextOutgoingID unsignedIntValue]]];
    
    if (self->_incomingWindow == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    [list addElementWithIndex:2 element:[IBAMQPWrapper wrapUInt:[self->_incomingWindow unsignedIntValue]]];
    
    if (self->_outgoingWindow == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    [list addElementWithIndex:3 element:[IBAMQPWrapper wrapUInt:[self->_outgoingWindow unsignedIntValue]]];
    
    if (self->_handleMax != nil) {
        [list addElementWithIndex:4 element:[IBAMQPWrapper wrapUInt:[self->_handleMax unsignedIntValue]]];
    }
    if (self->_offeredCapabilities != nil) {
        [list addElementWithIndex:5 element:[IBAMQPWrapper wrapArray:self->_offeredCapabilities]];
    }
    if (self->_desiredCapabilities != nil) {
        [list addElementWithIndex:6 element:[IBAMQPWrapper wrapArray:self->_desiredCapabilities]];
    }
    if (self->_properties != nil) {
        [list addElementWithIndex:7 element:[IBAMQPWrapper wrapMap:self->_properties]];
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
    
    if (size > 8) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    
    if (size > 0) {
        IBTLVAMQP *element = [list.list objectAtIndex:0];
        if (!element.isNull) {
            self->_remoteChannel = @([IBAMQPUnwrapper unwrapUShort:element]);
        }
    }
    if (size > 1) {
        IBTLVAMQP *element = [list.list objectAtIndex:1];
        if (element.isNull) {
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
        }
        self->_nextOutgoingID = @([IBAMQPUnwrapper unwrapUInt:element]);
    }
    if (size > 2) {
        IBTLVAMQP *element = [list.list objectAtIndex:2];
        if (element.isNull) {
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
        }
        self->_incomingWindow = @([IBAMQPUnwrapper unwrapUInt:element]);
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
            self->_handleMax = @([IBAMQPUnwrapper unwrapUInt:element]);
        }
    }
    if (size > 5) {
        IBTLVAMQP *element = [list.list objectAtIndex:5];
        if (!element.isNull) {
            self->_offeredCapabilities = [NSMutableArray arrayWithArray:[IBAMQPUnwrapper unwrapArray:element]];
        }
    }
    if (size > 6) {
        IBTLVAMQP *element = [list.list objectAtIndex:6];
        if (!element.isNull) {
            self->_desiredCapabilities = [NSMutableArray arrayWithArray:[IBAMQPUnwrapper unwrapArray:element]];
        }
    }
    if (size > 7) {
        IBTLVAMQP *element = [list.list objectAtIndex:7];
        if (!element.isNull) {
            self->_properties = [NSMutableDictionary dictionaryWithDictionary:[IBAMQPUnwrapper unwrapMap:element]];
        }
    }
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
