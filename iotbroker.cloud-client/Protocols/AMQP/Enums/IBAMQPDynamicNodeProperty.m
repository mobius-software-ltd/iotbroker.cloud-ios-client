//
//  IBAMQPDynamicNodeProperty.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPDynamicNodeProperty.h"

@implementation IBAMQPDynamicNodeProperty
{
    NSMutableDictionary *_dictionary;
}

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self->_dictionary = [NSMutableDictionary dictionary];
        
        [self->_dictionary setValue:@(IBAMQPSupportedDistModesDynamicNodeProperty)  forKey:@"supported-dist-modes"];
        [self->_dictionary setValue:@(IBAMQPDurableDynamicNodeProperty)             forKey:@"durable"];
        [self->_dictionary setValue:@(IBAMQPAutoDeleteDynamicNodeProperty)          forKey:@"auto-delete"];
        [self->_dictionary setValue:@(IBAMQPAlternateExchangeDynamicNodeProperty)   forKey:@"alternate-exchange"];
        [self->_dictionary setValue:@(IBAMQPExchangeTypeDynamicNodeProperty)        forKey:@"exchange-type"];
        
    }
    return self;
}

- (instancetype) initWithDynamicNodeProperties:(IBAMQPDynamicNodeProperties)type {
    self = [self init];
    if (self != nil) {
        self->_value = type;
    }
    return self;
}

+ (instancetype) enumWithDynamicNodeProperties:(IBAMQPDynamicNodeProperties)type {
    return [[IBAMQPDynamicNodeProperty alloc] initWithDynamicNodeProperties:type];
}

- (NSString *) nameByValue {
    for (NSString *key in self->_dictionary.allKeys) {
        NSNumber *number = [self->_dictionary objectForKey:key];
        if ([number integerValue] == self.value) {
            return key;
        }
    }
    return nil;
}

- (IBAMQPDynamicNodeProperties) valueByName : (NSString *) name {
    return [[self->_dictionary objectForKey:name] integerValue];
}

- (NSDictionary *) items {
    return self->_dictionary;
}

@end
