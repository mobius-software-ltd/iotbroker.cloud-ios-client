//
//  IBDeliveryAnnotation.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBDeliveryAnnotation.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPDescribedConstructor.h"

@implementation IBDeliveryAnnotation

- (IBTLVAMQP *)value {

    IBTLVAMQP *map = [[IBTLVAMQP alloc] init];
    
    if (self->_annotations != nil) {
        map = [IBAMQPWrapper wrapMap:self->_annotations withKeyType:0 valueType:0];
    }
    
    NSMutableData *data = [NSMutableData data];
    [data appendByte:0x71];
    IBAMQPType *type = [IBAMQPType enumWithType:IBAMQPSmallULongType];
    IBAMQPTLVFixed *fixed = [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
    
    IBAMQPType *constructorType = [[IBAMQPType alloc] initWithType:map.type];
    IBAMQPDescribedConstructor *constructor = [[IBAMQPDescribedConstructor alloc] initWithType:constructorType andDescriptor:fixed];
    
    map.constructor = constructor;

    return map;
}

- (void)fill:(IBTLVAMQP *)value {
    if (!value.isNull) {
        self->_annotations = [NSMutableDictionary dictionaryWithDictionary:[IBAMQPUnwrapper unwrapMap:value]];
    }
}

- (IBAMQPSectionCode *)code {
    return [[IBAMQPSectionCode alloc] initWithSectionCode:IBAMQPDeliveryAnnotationsSectionCode];
}

- (void) addAnnotation : (id) key value : (NSObject *) object {
    if (self->_annotations != nil) {
        self->_annotations = [NSMutableDictionary dictionary];
    }
    if ([key isKindOfClass:[NSString class]]) {
        [self->_annotations setObject:object forKey:[[IBAMQPSymbol alloc] initWithString:key]];
    } else if ([key isKindOfClass:[NSNumber class]]) {
        [self->_annotations setObject:object forKey:key];
    } else {
        @throw [NSException exceptionWithName:[[self class] description] reason:NSStringFromSelector(_cmd) userInfo:nil];
    }
}

@end
