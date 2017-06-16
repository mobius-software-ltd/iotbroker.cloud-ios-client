//
//  IBAMQPApplicationProperties.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPApplicationProperties.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPTLVMap.h"
#import "IBAMQPTLVFixed.h"
#import "IBAMQPDescribedConstructor.h"

@implementation IBAMQPApplicationProperties

- (IBTLVAMQP *)value {

    IBAMQPTLVMap *map = [[IBAMQPTLVMap alloc] init];
    
    if (self->_properties != nil) {
        map = (IBAMQPTLVMap *)[IBAMQPWrapper wrapMap:self->_properties];
    }
    
    NSMutableData *data = [NSMutableData data];
    [data appendByte:0x74];
    IBAMQPType *type = [IBAMQPType enumWithType:IBAMQPSmallULongType];
    IBAMQPTLVFixed *fixed = [[IBAMQPTLVFixed alloc] initWithType:type andValue:data];
    
    IBAMQPType *constructorType = [[IBAMQPType alloc] initWithType:map.type];
    IBAMQPDescribedConstructor *constructor = [[IBAMQPDescribedConstructor alloc] initWithType:constructorType andDescriptor:fixed];
    
    map.constructor = constructor;

    return map;
}

- (void)fill:(IBTLVAMQP *)value {
    if (!value.isNull) {
        self->_properties = [NSMutableDictionary dictionaryWithDictionary:[IBAMQPUnwrapper unwrapMap:value]];
    }
}

- (IBAMQPSectionCode *)code {
    return [[IBAMQPSectionCode alloc] initWithSectionCode:IBAMQPApplicationPropertiesSectionCode];
}

- (void) addProperty : (NSString *) key value : (NSObject *) value {
    if (self->_properties != nil) {
        self->_properties = [NSMutableDictionary dictionary];
    }
    [self->_properties setObject:value forKey:key];
}

@end
