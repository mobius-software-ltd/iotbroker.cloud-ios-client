//
//  IBAMQPStateCode.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPStateCode.h"

@implementation IBAMQPStateCode
{
    NSMutableDictionary *_dictionary;
}

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self->_dictionary = [NSMutableDictionary dictionary];
        [self->_dictionary setValue:@(IBAMQPAcceptedStateCode) forKey:@"accepted"];
        [self->_dictionary setValue:@(IBAMQPRejectedStateCode) forKey:@"rejected"];
        [self->_dictionary setValue:@(IBAMQPReleasedStateCode) forKey:@"released"];
        [self->_dictionary setValue:@(IBAMQPModifiedStateCode) forKey:@"modified"];
        [self->_dictionary setValue:@(IBAMQPReceivedStateCode) forKey:@"received"];
    }
    return self;
}

- (instancetype) initWithStateCode : (IBAMQPStateCodes) type {
    self = [self init];
    if (self != nil) {
        self->_value = type;
    }
    return self;
}

+ (instancetype) enumWithStateCode : (IBAMQPStateCodes) type {
    return [[IBAMQPStateCode alloc] initWithStateCode:type];
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

- (IBAMQPStateCodes) valueByName : (NSString *) name {
    return [[self->_dictionary objectForKey:name] unsignedCharValue];
}

- (NSDictionary *) items {
    return self->_dictionary;
}

@end
