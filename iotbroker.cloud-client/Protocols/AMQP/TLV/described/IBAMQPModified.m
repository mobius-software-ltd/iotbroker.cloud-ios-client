//
//  IBAMQPModified.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 08.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPModified.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPSymbol.h"
#import "IBAMQPDescribedConstructor.h"
#import "IBAMQPTLVFixed.h"

@implementation IBAMQPModified

- (IBAMQPTLVList *)list {

    IBAMQPTLVList *list = [[IBAMQPTLVList alloc] init];
    
    if (self->_deliveryFailed != nil) {
        [list addElementWithIndex:0 element:[IBAMQPWrapper wrapBOOL:self->_deliveryFailed]];
    }
    if (self->_undeliverableHere != nil) {
        [list addElementWithIndex:1 element:[IBAMQPWrapper wrapBOOL:self->_undeliverableHere]];

    }
    if (self->_messageAnnotations != nil) {
        [list addElementWithIndex:2 element:[IBAMQPWrapper wrapMap:self->_messageAnnotations withKeyType:0 valueType:0]];
    }
    
    IBAMQPType *type = [[IBAMQPType alloc] initWithType:IBAMQPSmallULongType];
    NSMutableData *data = [NSMutableData data];
    [data appendByte:0x27];
    IBAMQPTLVFixed *fixed = [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
    IBAMQPType *constructorType = [[IBAMQPType alloc] initWithType:list.type];
    IBAMQPDescribedConstructor *constructor = [[IBAMQPDescribedConstructor alloc] initWithType:constructorType andDescriptor:fixed];
    list.constructor = constructor;
    
    return list;
}

- (void)fill:(IBAMQPTLVList *)list {

    if (list.list.count > 0) {
        IBTLVAMQP *element = [list.list objectAtIndex:0];
        if (!element.isNull) {
            self->_deliveryFailed = @([IBAMQPUnwrapper unwrapBOOL:element]);
        }
    }
    if (list.list.count > 1) {
        IBTLVAMQP *element = [list.list objectAtIndex:1];
        if (!element.isNull) {
            self->_undeliverableHere = @([IBAMQPUnwrapper unwrapBOOL:element]);
        }
    }
    if (list.list.count > 2) {
        IBTLVAMQP *element = [list.list objectAtIndex:2];
        if (!element.isNull) {
            self->_messageAnnotations = [NSMutableDictionary dictionaryWithDictionary:[IBAMQPUnwrapper unwrapMap:element]];
        }
    }
}

- (void) addMessageAnnotation : (NSString *) key value : (NSObject *) value {
    
    if (![key hasSuffix:@"x-"]) {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
    if (self->_messageAnnotations == nil) {
        self->_messageAnnotations = [NSMutableDictionary dictionary];
    }
    [self->_messageAnnotations setObject:value forKey:[[IBAMQPSymbol alloc] initWithString:key]];
}

@end
