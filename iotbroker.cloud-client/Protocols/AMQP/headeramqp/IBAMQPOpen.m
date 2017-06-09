//
//  IBAMQPOpen.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPOpen.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPDescribedConstructor.h"

@implementation IBAMQPOpen

@synthesize code = _code;
@synthesize doff = _doff;
@synthesize type = _type;
@synthesize chanel = _chanel;

- (instancetype)init {
    IBAMQPHeaderCode *code = [IBAMQPHeaderCode enumWithHeaderCode:IBAMQPOpenHeaderCode];
    self = [self initWithCode:code];
    return self;
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
        [list addElementWithIndex:5 element:[IBAMQPWrapper wrapArray:self->_outgoingLocales withType:0]];
    }
    if (self->_incomingLocales != nil) {
        [list addElementWithIndex:6 element:[IBAMQPWrapper wrapArray:self->_incomingLocales withType:0]];
    }
    if (self->_offeredCapabilities != nil) {
        [list addElementWithIndex:7 element:[IBAMQPWrapper wrapArray:self->_offeredCapabilities withType:0]];
    }
    if (self->_desiredCapabilities != nil) {
        [list addElementWithIndex:8 element:[IBAMQPWrapper wrapArray:self->_desiredCapabilities withType:0]];
    }
    if (self->_properties != nil) {
        [list addElementWithIndex:9 element:[IBAMQPWrapper wrapMap:self->_properties withKeyType:0 valueType:0]];
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
