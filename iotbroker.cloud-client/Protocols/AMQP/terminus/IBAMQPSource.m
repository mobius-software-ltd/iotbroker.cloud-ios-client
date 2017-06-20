//
//  IBAMQPSource.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 08.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPSource.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPSymbol.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPDescribedConstructor.h"
#import "IBAMQPFactory.h"

@implementation IBAMQPSource

- (IBAMQPTLVList *) list {

    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];
    
    if (self->_address != nil) {
        [list addElementWithIndex:0 element:[IBAMQPWrapper wrapString:self.address]];
    }
    if (self->_durable != nil) {
        [list addElementWithIndex:1 element:[IBAMQPWrapper wrapUInt:self->_durable.value]];
    }
    if (self->_expiryPeriod != nil) {
        IBAMQPSymbol *symbol = [[IBAMQPSymbol alloc] initWithString:[self->_expiryPeriod nameByValue]];
        [list addElementWithIndex:2 element:[IBAMQPWrapper wrapObject:symbol]];
    }
    if (self->_timeout != nil) {
        [list addElementWithIndex:3 element:[IBAMQPWrapper wrapUInt:[self->_timeout unsignedIntValue]]];
    }
    if (self->_dynamic != nil) {
        [list addElementWithIndex:4 element:[IBAMQPWrapper wrapBOOL:[self->_dynamic boolValue]]];
    }
    if (self->_dynamicNodeProperties != nil) {
        if (self->_dynamic != nil) {
            if ([self->_dynamic boolValue] == true) {
                [list addElementWithIndex:5 element:[IBAMQPWrapper wrapMap:self->_dynamicNodeProperties]];
            } else {
                @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
            }
        } else {
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
        }
    }
    if (self->_distributionMode != nil) {
        IBAMQPSymbol *symbol = [[IBAMQPSymbol alloc] initWithString:[self->_distributionMode nameByValue]];
        [list addElementWithIndex:6 element:[IBAMQPWrapper wrapObject:symbol]];
    }
    if (self->_filter != nil) {
        [list addElementWithIndex:7 element:[IBAMQPWrapper wrapMap:self->_filter]];
    }
    if (self->_defaultOutcome != nil) {
        [list addElementWithIndex:8 element:self->_defaultOutcome.list];
    }
    if (self->_outcomes != nil) {
        [list addElementWithIndex:9 element:[IBAMQPWrapper wrapArray:self->_outcomes]];
    }
    if (self->_capabilities != nil) {
        [list addElementWithIndex:10 element:[IBAMQPWrapper wrapList:self->_capabilities]];
    }
    
    NSMutableData *data = [NSMutableData data];
    [data appendByte:0x28];
    IBAMQPType *type = [IBAMQPType enumWithType:IBAMQPSmallULongType];
    IBAMQPTLVFixed *fixed = [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
    
    IBAMQPType *constructorType = [[IBAMQPType alloc] initWithType:list.type];
    IBAMQPDescribedConstructor *constructor = [[IBAMQPDescribedConstructor alloc] initWithType:constructorType andDescriptor:fixed];
    
    list.constructor = constructor;
    
    return list;
}

- (void) fill : (IBAMQPTLVList *) list {

    if (list.list.count > 0) {
        IBTLVAMQP *element = [list.list objectAtIndex:0];
        if (!element.isNull) {
            self->_address = [IBAMQPUnwrapper unwrapString:element];
        }
    }
    if (list.list.count > 1) {
        IBTLVAMQP *element = [list.list objectAtIndex:1];
        if (!element.isNull) {
            NSInteger number = [IBAMQPUnwrapper unwrapUInt:element];
            self->_durable = [IBAMQPTerminusDurability enumWithTerminusDurability:number];
        }
    }
    if (list.list.count > 2) {
        IBTLVAMQP *element = [list.list objectAtIndex:2];
        if (!element.isNull) {
            IBAMQPSymbol *symbol = [IBAMQPUnwrapper unwrapSymbol:element];
            IBAMQPTerminusExpiryPolicy *policy = [[IBAMQPTerminusExpiryPolicy alloc] init];
            policy.value = [policy valueByName:symbol.value];
            self->_expiryPeriod = policy;
        }
    }
    if (list.list.count > 3) {
        IBTLVAMQP *element = [list.list objectAtIndex:3];
        if (!element.isNull) {
            NSInteger number = [IBAMQPUnwrapper unwrapUInt:element];
            self->_timeout = @(number);
        }
    }
    if (list.list.count > 4) {
        IBTLVAMQP *element = [list.list objectAtIndex:4];
        if (!element.isNull) {
            NSInteger number = [IBAMQPUnwrapper unwrapBOOL:element];
            self->_dynamic = @(number);
        }
    }
    if (list.list.count > 5) {
        IBTLVAMQP *element = [list.list objectAtIndex:5];
        if (!element.isNull) {
            if (self->_dynamic != nil) {
                if ([self->_dynamic boolValue]) {
                    self->_dynamicNodeProperties = [NSMutableDictionary dictionaryWithDictionary:[IBAMQPUnwrapper unwrapMap:element]];
                } else {
                    @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
                }
            } else {
                @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
            }
        }
    }
    if (list.list.count > 6) {
        IBTLVAMQP *element = [list.list objectAtIndex:6];
        if (!element.isNull) {
            IBAMQPSymbol *symbol = [IBAMQPUnwrapper unwrapSymbol:element];
            IBAMQPDistributionMode *mode = [[IBAMQPDistributionMode alloc] init];
            mode.value = [mode valueByName:symbol.value];
            self->_distributionMode = mode;
        }
    }
    if (list.list.count > 7) {
        IBTLVAMQP *element = [list.list objectAtIndex:7];
        if (!element.isNull) {
            self->_filter = [NSMutableDictionary dictionaryWithDictionary:[IBAMQPUnwrapper unwrapMap:element]];
        }
    }
    if (list.list.count > 8) {
        IBTLVAMQP *element = [list.list objectAtIndex:8];
        if (!element.isNull) {
            IBAMQPType *code = [IBAMQPType enumWithType:element.type];
            if (code.value != IBAMQPList0Type && code.value != IBAMQPList8Type && code.value != IBAMQPList32Type) {
                @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
            }
            self->_defaultOutcome = [IBAMQPFactory outcome:((IBAMQPTLVList *)element)];
            [self->_defaultOutcome fill:((IBAMQPTLVList *)element)];
        }
    }
    if (list.list.count > 9) {
        IBTLVAMQP *element = [list.list objectAtIndex:9];
        if (!element.isNull) {
            self->_outcomes = [NSMutableArray arrayWithArray:[IBAMQPUnwrapper unwrapArray:element]];
        }
    }
    if (list.list.count > 10) {
        IBTLVAMQP *element = [list.list objectAtIndex:10];
        if (!element.isNull) {
            self->_capabilities = [NSMutableArray arrayWithArray:[IBAMQPUnwrapper unwrapList:element]];
        }
    }
}

- (void) addDynamicNodeProperties : (NSString *) key value : (NSObject *) value {
    if (self->_dynamicNodeProperties == nil) {
        self->_dynamicNodeProperties = [NSMutableDictionary dictionary];
    }
    [self->_dynamicNodeProperties setObject:value forKey:[[IBAMQPSymbol alloc] initWithString:key]];
}

- (void) addFilter : (NSString *) key value : (NSObject *) value {
    if (self->_filter == nil) {
        self->_filter = [NSMutableDictionary dictionary];
    }
    [self->_filter setObject:value forKey:[[IBAMQPSymbol alloc] initWithString:key]];
}

- (void) addOutcomes : (NSArray<NSString *> *) array {
    if (self->_outcomes == nil) {
        self->_outcomes = [NSMutableArray array];
    }
    for (NSString *item in array) {
        [self->_outcomes addObject:[[IBAMQPSymbol alloc] initWithString:item]];
    }
}

- (void) addCapabilities : (NSArray<NSString *> *) array {
    if (self->_capabilities == nil) {
        self->_capabilities = [NSMutableArray array];
    }
    for (NSString *item in array) {
        [self->_capabilities addObject:[[IBAMQPSymbol alloc] initWithString:item]];
    }
}

@end
