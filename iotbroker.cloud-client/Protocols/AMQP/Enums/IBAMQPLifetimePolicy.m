//
//  IBAMQPLifetimePolicy.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPLifetimePolicy.h"

@implementation IBAMQPLifetimePolicy
{
    NSMutableDictionary *_dictionary;
}

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self->_dictionary = [NSMutableDictionary dictionary];
        [self->_dictionary setValue:@(IBAMQPDeleteOnCloseLifetimePolicy)                forKey:@"Delete on close"];
        [self->_dictionary setValue:@(IBAMQPDeleteOnNoLinksLifetimePolicy)              forKey:@"Delete on no links"];
        [self->_dictionary setValue:@(IBAMQPDeleteOnNoMessagesLifetimePolicy)           forKey:@"Delete on no messages"];
        [self->_dictionary setValue:@(IBAMQPDeleteOnNoLinksOrMessagesLifetimePolicy)    forKey:@"Delete on no links or messages"];
        
    }
    return self;
}

- (instancetype) initWithLifetimePolicies : (IBAMQPLifetimePolicies) type {
    self = [self init];
    if (self != nil) {
        self->_value = type;
    }
    return self;
}

+ (instancetype) enumWithLifetimePolicies : (IBAMQPLifetimePolicies) type {
    return [[IBAMQPLifetimePolicy alloc] initWithLifetimePolicies:type];
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

- (IBAMQPLifetimePolicies) valueByName : (NSString *) name {
    return [[self->_dictionary objectForKey:name] unsignedCharValue];
}

- (NSDictionary *) items {
    return self->_dictionary;
}

@end
