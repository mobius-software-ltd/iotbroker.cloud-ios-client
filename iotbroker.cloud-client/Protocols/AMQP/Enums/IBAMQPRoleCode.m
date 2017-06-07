//
//  IBAMQPRoleCode.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPRoleCode.h"

@implementation IBAMQPRoleCode
{
    NSMutableDictionary *_dictionary;
}

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self->_dictionary = [NSMutableDictionary dictionary];
        [self->_dictionary setValue:@(IBAMQPSenderRoleCode)     forKey:@"sender"];
        [self->_dictionary setValue:@(IBAMQPReceiverRoleCode)   forKey:@"receiver"];
    }
    return self;
}

- (instancetype) initWithRoleCode : (IBAMQPRoleCodes) type {
    self = [self init];
    if (self != nil) {
        self->_value = type;
    }
    return self;
}

+ (instancetype) enumWithRoleCode : (IBAMQPRoleCodes) type {
    return [[IBAMQPRoleCode alloc] initWithRoleCode:type];
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

- (IBAMQPRoleCodes) valueByName : (NSString *) name {
    return [[self->_dictionary objectForKey:name] integerValue];
}

- (NSDictionary *) items {
    return self->_dictionary;
}

@end
