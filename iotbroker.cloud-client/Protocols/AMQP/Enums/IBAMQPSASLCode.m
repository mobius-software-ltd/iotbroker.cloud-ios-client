//
//  IBAMQPSASLCode.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPSASLCode.h"

@implementation IBAMQPSASLCode
{
    NSMutableDictionary *_dictionary;
}

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self->_dictionary = [NSMutableDictionary dictionary];
        [self->_dictionary setValue:@(IBAMQPOkSASLCode)         forKey:@"ok"];
        [self->_dictionary setValue:@(IBAMQPAuthSASLCode)       forKey:@"auth"];
        [self->_dictionary setValue:@(IBAMQPSysSASLCode)        forKey:@"sys"];
        [self->_dictionary setValue:@(IBAMQPSysPermSASLCode)    forKey:@"sys-perm"];
        [self->_dictionary setValue:@(IBAMQPSysTempSASLCode)    forKey:@"sys-temp"];
    }
    return self;
}

- (instancetype) initWithSASLCode : (IBAMQPSASLCodes) type {
    self = [self init];
    if (self != nil) {
        self->_value = type;
    }
    return self;
}

+ (instancetype) enumWithSASLCode : (IBAMQPSASLCodes) type {
    return [[IBAMQPSASLCode alloc] initWithSASLCode:type];
}

- (NSString *) nameByValue {
    for (NSString *key in self->_dictionary.allKeys) {
        NSNumber *number = [self->_dictionary objectForKey:key];
        if ([number shortValue] == self.value) {
            return key;
        }
    }
    return nil;
}

- (IBAMQPSASLCodes) valueByName : (NSString *) name {
    return [[self->_dictionary objectForKey:name] shortValue];
}

- (NSDictionary *) items {
    return self->_dictionary;
}

@end
