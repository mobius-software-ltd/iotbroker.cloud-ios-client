//
//  IBAMQPTarget.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPTarget.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPDescribedConstructor.h"

@implementation IBAMQPTarget

- (IBAMQPTLVList *) list {
    
    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];
    
    if (self->_address != nil) {
        [list addElementWithIndex:0 element:[IBAMQPWrapper wrapString:self->_address]];
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
            if ([self->_dynamic boolValue]) {
                [list addElementWithIndex:5 element:[IBAMQPWrapper wrapMap:self->_dynamicNodeProperties]];
            } else {
                @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
            }
        } else {
            @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
        }
    }
    if (self->_capabilities != nil) {
        [list addElementWithIndex:6 element:[IBAMQPWrapper wrapList:self->_capabilities]];
    }
    
    NSMutableData *data = [NSMutableData data];
    [data appendByte:0x29];
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
            self->_durable = [[IBAMQPTerminusDurability alloc] initWithTerminusDurability:number];
        }
    }
    if (list.list.count > 2) {
        IBTLVAMQP *element = [list.list objectAtIndex:2];
        if (!element.isNull) {
            IBAMQPSymbol *symbol = [IBAMQPUnwrapper unwrapSymbol:element];
            IBAMQPTerminusExpiryPolicy *expiryPolicy = [[IBAMQPTerminusExpiryPolicy alloc] init];
            expiryPolicy.value = [expiryPolicy valueByName:symbol.value];
            self->_expiryPeriod = expiryPolicy;
        }
    }
    if (list.list.count > 3) {
        IBTLVAMQP *element = [list.list objectAtIndex:3];
        if (!element.isNull) {
            self->_timeout = @([IBAMQPUnwrapper unwrapUInt:element]);
        }
    }
    if (list.list.count > 4) {
        IBTLVAMQP *element = [list.list objectAtIndex:4];
        if (!element.isNull) {
            self->_dynamic = @([IBAMQPUnwrapper unwrapBOOL:element]);
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

- (void) addCapabilities : (NSArray<NSString *> *) array {
    if (self->_capabilities == nil) {
        self->_capabilities = [NSMutableArray array];
    }
    for (NSString *item in array) {
        [self->_capabilities addObject:[[IBAMQPSymbol alloc] initWithString:item]];
    }
}

@end
