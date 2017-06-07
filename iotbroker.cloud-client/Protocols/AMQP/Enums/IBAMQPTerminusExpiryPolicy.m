//
//  IBAMQPTerminusExpiryPolicy.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPTerminusExpiryPolicy.h"

@implementation IBAMQPTerminusExpiryPolicy
{
    NSMutableDictionary *_dictionary;
}

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self->_dictionary = [NSMutableDictionary dictionary];
        [self->_dictionary setValue:@(IBAMQPLinkDetachTerminusExpiryPolicies)       forKey:@"link-detach"];
        [self->_dictionary setValue:@(IBAMQPSessionEndTerminusExpiryPolicies)       forKey:@"session-end"];
        [self->_dictionary setValue:@(IBAMQPConnectionCloseTerminusExpiryPolicies)  forKey:@"connection-close"];
        [self->_dictionary setValue:@(IBAMQPNeverTerminusExpiryPolicies)            forKey:@"none"];
    }
    return self;
}

- (instancetype) initWithTerminusExpiryPolicy : (IBAMQPTerminusExpiryPolicies) type {
    self = [self init];
    if (self != nil) {
        self->_value = type;
    }
    return self;
}

+ (instancetype) enumWithTerminusExpiryPolicy : (IBAMQPTerminusExpiryPolicies) type {
    return [[IBAMQPTerminusExpiryPolicy alloc] initWithTerminusExpiryPolicy:type];
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

- (IBAMQPTerminusExpiryPolicies) valueByName : (NSString *) name {
    return [[self->_dictionary objectForKey:name] integerValue];
}

- (NSDictionary *) items {
    return self->_dictionary;
}

@end
