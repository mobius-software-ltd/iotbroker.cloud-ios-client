//
//  IBAMQPFooter.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPFooter.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPWrapper.h"
#import "IBAMQPTLVMap.h"
#import "IBAMQPDescribedConstructor.h"
#import "IBAMQPTLVFixed.h"

@implementation IBAMQPFooter

@synthesize value = _value;
@synthesize code = _code;

- (IBTLVAMQP *)value {

    IBAMQPTLVMap *map = [[IBAMQPTLVMap alloc] init];
    
    if (self->_annotations != nil) {
        map = (IBAMQPTLVMap *)[IBAMQPWrapper wrapMap:self->_annotations];
    }
    
    NSMutableData *data = [NSMutableData data];
    [data appendByte:0x78];
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
    return [[IBAMQPSectionCode alloc] initWithSectionCode:IBAMQPFooterSectionCode];
}

- (void) addAnnotation : (NSString *) key value : (NSObject *) value {
    if (self->_annotations == nil) {
        self->_annotations = [NSMutableDictionary dictionary];
    }
    [self->_annotations setObject:value forKey:[[IBAMQPSymbol alloc] initWithString:key]];
}

@end
