//
//  IBAMQPError.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 08.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPError.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPSymbol.h"
#import "IBAMQPDescribedConstructor.h"
#import "IBAMQPTLVFixed.h"

@implementation IBAMQPError

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self->_condition = [[IBAMQPErrorCode alloc] init];
        self->_descriptionString = [NSString string];
        self->_info = [NSMutableDictionary dictionary];
    }
    return self;
}

- (IBAMQPTLVList *) list {

    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];
    
    if (self.condition != nil) {
        IBAMQPSymbol *symbol = [[IBAMQPSymbol alloc] initWithString:[self.condition nameByValue]];
        [list addElementWithIndex:0 element:[IBAMQPWrapper wrapObject:symbol]];
    }
    if (self.descriptionString != nil) {
        [list addElementWithIndex:1 element:[IBAMQPWrapper wrapObject:self.descriptionString]];
    }
    if (self.info != nil) {
        [list addElementWithIndex:2 element:[IBAMQPWrapper wrapMap:self.info]];
    }
    
    IBAMQPType *type = [[IBAMQPType alloc] initWithType:IBAMQPSmallULongType];
    NSMutableData *data = [NSMutableData data];
    [data appendByte:0x1D];
    IBAMQPTLVFixed *fixed = [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
    IBAMQPType *constructorType = [[IBAMQPType alloc] initWithType:list.type];
    IBAMQPDescribedConstructor *constructor = [[IBAMQPDescribedConstructor alloc] initWithType:constructorType andDescriptor:fixed];
    list.constructor = constructor;
    
    return list;
}

- (void) fill:(IBAMQPTLVList *)list {

    if (list.list.count > 0) {
        IBTLVAMQP *element = [list.list objectAtIndex:0];
        if (!element.isNull) {
            NSString *name = [IBAMQPUnwrapper unwrapSymbol:element].value;
            IBAMQPErrorCode *code = [[IBAMQPErrorCode alloc] init];
            self->_condition.value = [code valueByName:name];
        }
    }
    
    if (list.list.count > 1) {
        IBTLVAMQP *element = [list.list objectAtIndex:1];
        if (!element.isNull) {
            self->_descriptionString = [IBAMQPUnwrapper unwrapString:element];
        }
    }
    
    if (list.list.count > 2) {
        IBTLVAMQP *element = [list.list objectAtIndex:2];
        if (!element.isNull) {
            self->_info = [NSMutableDictionary dictionaryWithDictionary:[IBAMQPUnwrapper unwrapMap:element]];
        }
    }
}

- (void) addInfo : (NSString *) key value : (NSObject *) value {
    if (self->_info == nil) {
        self->_info = [NSMutableDictionary dictionary];
    }
    [self->_info setObject:value forKey:[[IBAMQPSymbol alloc] initWithString:key]];
}

@end
