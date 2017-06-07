//
//  IBAMQPTerminusDurability.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPTerminusDurability.h"

@implementation IBAMQPTerminusDurability
{
    NSMutableDictionary *_dictionary;
}

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self->_dictionary = [NSMutableDictionary dictionary];
        [self->_dictionary setValue:@(IBAMQPNoneTerminusDurabilities)           forKey:@"none"];
        [self->_dictionary setValue:@(IBAMQPConfigurationTerminusDurabilities)  forKey:@"configuration"];
        [self->_dictionary setValue:@(IBAMQPUnsettledStateTerminusDurabilities) forKey:@"unsettled-state"];
    }
    return self;
}

- (instancetype) initWithTerminusDurability : (IBAMQPTerminusDurabilities) type {
    self = [self init];
    if (self != nil) {
        self->_value = type;
    }
    return self;
}

+ (instancetype) enumWithTerminusDurability : (IBAMQPTerminusDurabilities) type {
    return [[IBAMQPTerminusDurability alloc] initWithTerminusDurability:type];
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

- (IBAMQPTerminusDurabilities) valueByName : (NSString *) name {
    return [[self->_dictionary objectForKey:name] integerValue];
}

- (NSDictionary *) items {
    return self->_dictionary;
}

@end
