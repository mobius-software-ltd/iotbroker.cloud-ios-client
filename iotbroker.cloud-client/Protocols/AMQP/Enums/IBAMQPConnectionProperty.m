//
//  IBAMQPConnectionProperty.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPConnectionProperty.h"

@implementation IBAMQPConnectionProperty
{
    NSMutableDictionary *_dictionary;
}

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self->_dictionary = [NSMutableDictionary dictionary];
        
        [self->_dictionary setValue:@(IBAMQPPlatformConnectionProperty)         forKey:@"platform"];
        [self->_dictionary setValue:@(IBAMQPProductConnectionProperty)          forKey:@"product"];
        [self->_dictionary setValue:@(IBAMQPQPidClientPidConnectionProperty)    forKey:@"qpid.client_pid"];
        [self->_dictionary setValue:@(IBAMQPQPidClientPpidConnectionProperty)   forKey:@"qpid.client_ppid"];
        [self->_dictionary setValue:@(IBAMQPQPidClientProcessConnectionProperty)forKey:@"qpid.client_process"];
        [self->_dictionary setValue:@(IBAMQPVersionConnectionProperty)          forKey:@"version"];

    }
    return self;
}

- (instancetype) initWithConnectionProperty:(IBAMQPConnectionProperties)type {
    self = [self init];
    if (self != nil) {
        self->_value = type;
    }
    return self;
}

+ (instancetype) enumWithConnectionProperty:(IBAMQPConnectionProperties)type {
    return [[IBAMQPConnectionProperty alloc] initWithConnectionProperty:type];
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

- (IBAMQPConnectionProperties) valueByName : (NSString *) name {
    return [[self->_dictionary objectForKey:name] integerValue];
}

- (NSDictionary *) items {
    return self->_dictionary;
}

@end
