//
//  IBAMQPSectionCode.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPSectionCode.h"

@implementation IBAMQPSectionCode
{
    NSMutableDictionary *_dictionary;
}

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self->_dictionary = [NSMutableDictionary dictionary];
        [self->_dictionary setValue:@(IBAMQPHeaderSectionCode)                  forKey:@"header"];
        [self->_dictionary setValue:@(IBAMQPDeliveryAnnotationsSectionCode)     forKey:@"delivery-annotations"];
        [self->_dictionary setValue:@(IBAMQPMessageAnnotationsSectionCode)      forKey:@"message-annotations"];
        [self->_dictionary setValue:@(IBAMQPPropertiesSectionCode)              forKey:@"properties"];
        [self->_dictionary setValue:@(IBAMQPApplicationPropertiesSectionCode)   forKey:@"application-properties"];
        [self->_dictionary setValue:@(IBAMQPDataSectionCode)                    forKey:@"data"];
        [self->_dictionary setValue:@(IBAMQPSequenceSectionCode)                forKey:@"amqp-sequence"];
        [self->_dictionary setValue:@(IBAMQPValueSectionCode)                   forKey:@"amqp-value"];
        [self->_dictionary setValue:@(IBAMQPFooterSectionCode)                  forKey:@"footer"];
    }
    return self;
}

- (instancetype) initWithSectionCode : (IBAMQPSectionCodes) type {
    self = [self init];
    if (self != nil) {
        self->_value = type;
    }
    return self;
}

+ (instancetype) enumWithSectionCode : (IBAMQPSectionCodes) type {
    return [[IBAMQPSectionCode alloc] initWithSectionCode:type];
}

- (NSString *) nameByValue {
    for (NSString *key in self->_dictionary.allKeys) {
        NSNumber *number = [self->_dictionary objectForKey:key];
        if ([number unsignedCharValue] == self.value) {
            return key;
        }
    }
    return nil;
}

- (IBAMQPSectionCodes) valueByName : (NSString *) name {
    return [[self->_dictionary objectForKey:name] unsignedCharValue];
}

- (NSDictionary *) items {
    return self->_dictionary;
}

- (id)copyWithZone:(NSZone *)zone {
    
    IBAMQPSectionCode *copy = [IBAMQPSectionCode enumWithSectionCode:self.value];
    return copy;
}

@end
