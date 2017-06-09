//
//  IBAMQPBegin.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPBegin.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPDescribedConstructor.h"

@implementation IBAMQPBegin

@synthesize code = _code;
@synthesize doff = _doff;
@synthesize type = _type;
@synthesize chanel = _chanel;

- (instancetype)init {
    IBAMQPHeaderCode *code = [IBAMQPHeaderCode enumWithHeaderCode:IBAMQPBeginHeaderCode];
    self = [self initWithCode:code];
    return self;
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
        [list addElementWithIndex:5 element:[IBAMQPWrapper wrapArray:self->_offeredCapabilities withType:0]];
    }
    if (self->_desiredCapabilities != nil) {
        [list addElementWithIndex:6 element:[IBAMQPWrapper wrapArray:self->_desiredCapabilities withType:0]];
    }
    if (self->_properties != nil) {
        [list addElementWithIndex:7 element:[IBAMQPWrapper wrapMap:self->_properties withKeyType:0 valueType:0]];
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
        self->_desiredCapabilities = [NSMutableArray array];
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
