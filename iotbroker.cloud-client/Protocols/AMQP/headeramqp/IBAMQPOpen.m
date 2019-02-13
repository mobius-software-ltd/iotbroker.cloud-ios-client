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

#import "IBAMQPOpen.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPDescribedConstructor.h"

@implementation IBAMQPOpen

- (instancetype)init {
    IBAMQPHeaderCode *code = [IBAMQPHeaderCode enumWithHeaderCode:IBAMQPOpenHeaderCode];
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
    return IBAMQPOpenHeaderCode;
}

- (IBAMQPTLVList *)arguments {

    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];

    if (self->_containerId == nil) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    [list addElementWithIndex:0 element:[IBAMQPWrapper wrapString:self->_containerId]];
    
    if (self->_hostname != nil) {
        [list addElementWithIndex:1 element:[IBAMQPWrapper wrapString:self->_hostname]];
    }
    if (self->_maxFrameSize != nil) {
        [list addElementWithIndex:2 element:[IBAMQPWrapper wrapUInt:[self->_maxFrameSize unsignedIntValue]]];
    }
    if (self->_channelMax != nil) {
        [list addElementWithIndex:3 element:[IBAMQPWrapper wrapUShort:[self->_channelMax unsignedShortValue]]];
    }
    if (self->_idleTimeout != nil) {
        [list addElementWithIndex:4 element:[IBAMQPWrapper wrapUInt:[self->_idleTimeout unsignedIntValue]]];
    }
    if (self->_outgoingLocales != nil) {
        [list addElementWithIndex:5 element:[IBAMQPWrapper wrapArray:self->_outgoingLocales]];
    }
    if (self->_incomingLocales != nil) {
        [list addElementWithIndex:6 element:[IBAMQPWrapper wrapArray:self->_incomingLocales]];
    }
    if (self->_offeredCapabilities != nil) {
        [list addElementWithIndex:7 element:[IBAMQPWrapper wrapArray:self->_offeredCapabilities]];
    }
    if (self->_desiredCapabilities != nil) {
        [list addElementWithIndex:8 element:[IBAMQPWrapper wrapArray:self->_desiredCapabilities]];
    }
    if (self->_properties != nil) {
        [list addElementWithIndex:9 element:[IBAMQPWrapper wrapMap:self->_properties]];
    }

    NSMutableData *data = [NSMutableData data];

    [data appendByte:(Byte)self.code.value];
    
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
    
    if (size > 10) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    
    IBTLVAMQP *element = [list.list objectAtIndex:0];
    if (element.isNull) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    self->_containerId = [IBAMQPUnwrapper unwrapString:element];
    
    if (size > 1) {
        element = [list.list objectAtIndex:1];
        if (!element.isNull) {
            self->_hostname = [IBAMQPUnwrapper unwrapString:element];
        }
    }
    if (size > 2) {
        element = [list.list objectAtIndex:2];
        if (!element.isNull) {
            self->_maxFrameSize = @([IBAMQPUnwrapper unwrapUInt:element]);
        }
    }
    if (size > 3) {
        element = [list.list objectAtIndex:3];
        if (!element.isNull) {
            self->_channelMax = @([IBAMQPUnwrapper unwrapUShort:element]);
        }
    }
    if (size > 4) {
        element = [list.list objectAtIndex:4];
        if (!element.isNull) {
            self->_idleTimeout = @([IBAMQPUnwrapper unwrapUInt:element]);
        }
    }
    if (size > 5) {
        element = [list.list objectAtIndex:5];
        if (!element.isNull) {
            self->_outgoingLocales = [NSMutableArray arrayWithArray:[IBAMQPUnwrapper unwrapArray:element]];
        }
    }
    if (size > 6) {
        element = [list.list objectAtIndex:6];
        if (!element.isNull) {
            self->_incomingLocales = [NSMutableArray arrayWithArray:[IBAMQPUnwrapper unwrapArray:element]];
        }
    }
    if (size > 7) {
        element = [list.list objectAtIndex:7];
        if (!element.isNull) {
            self->_offeredCapabilities = [NSMutableArray arrayWithArray:[IBAMQPUnwrapper unwrapArray:element]];
        }
    }
    if (size > 8) {
        element = [list.list objectAtIndex:8];
        if (!element.isNull) {
            self->_desiredCapabilities = [NSMutableArray arrayWithArray:[IBAMQPUnwrapper unwrapArray:element]];
        }
    }
    if (size > 9) {
        element = [list.list objectAtIndex:9];
        if (!element.isNull) {
            self->_properties = [NSMutableDictionary dictionaryWithDictionary:[IBAMQPUnwrapper unwrapMap:element]];
        }
    }
}

- (void) addOutgoingLocale : (NSArray<NSString *> *) array {
    if (self->_outgoingLocales == nil) {
        self->_outgoingLocales = [NSMutableArray array];
    }
    for (NSString *item in array) {
        [self->_outgoingLocales addObject:[[IBAMQPSymbol alloc] initWithString:item]];
    }
}

- (void) addIncomingLocale : (NSArray<NSString *> *) array {
    if (self->_incomingLocales == nil) {
        self->_incomingLocales = [NSMutableArray array];
    }
    for (NSString *item in array) {
        [self->_incomingLocales addObject:[[IBAMQPSymbol alloc] initWithString:item]];
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

- (NSString *)description {

    NSMutableString *string = [NSMutableString string];
    
    [string appendString:[NSString stringWithFormat:@"\nDoff: %zd", self.doff]];
    [string appendString:[NSString stringWithFormat:@"\nType: %zd", self.type]];
    [string appendString:[NSString stringWithFormat:@"\nChannel: %zd", self.chanel]];
    
    [string appendString:[NSString stringWithFormat:@"\nArguments"]];
    
    [string appendString:[NSString stringWithFormat:@"\nContainer-id: %@", self->_containerId]];
    [string appendString:[NSString stringWithFormat:@"\nHostname: %@", self->_hostname]];
    [string appendString:[NSString stringWithFormat:@"\nMax-frame-size: %@", [self->_maxFrameSize description]]];
    [string appendString:[NSString stringWithFormat:@"\nChannel max: %@", [self->_channelMax description]]];
    [string appendString:[NSString stringWithFormat:@"\nIdle-timeout: %@", [self->_idleTimeout description]]];
    
    [string appendString:[NSString stringWithFormat:@"\nOutgoing-locales (array of %zd elements)", self->_outgoingLocales.count]];
    [string appendString:[NSString stringWithFormat:@"\n%@", self->_outgoingLocales]];
    
    [string appendString:[NSString stringWithFormat:@"\nIncoming-locales (array of %zd elements)", self->_incomingLocales.count]];
    [string appendString:[NSString stringWithFormat:@"\n%@", self->_incomingLocales]];
    
    [string appendString:[NSString stringWithFormat:@"\nOffered capabilities (array of %zd elements)", self->_offeredCapabilities.count]];
    [string appendString:[NSString stringWithFormat:@"\n%@", self->_offeredCapabilities]];
    
    [string appendString:[NSString stringWithFormat:@"\nDesired capabilities (array of %zd elements)", self->_desiredCapabilities.count]];
    [string appendString:[NSString stringWithFormat:@"\n%@", self->_desiredCapabilities]];
    
    [string appendString:[NSString stringWithFormat:@"\nProperties (map of %zd elements)", self->_properties.count]];
    [string appendString:[NSString stringWithFormat:@"\n%@", self->_properties]];
    
    return string;
}

@end
