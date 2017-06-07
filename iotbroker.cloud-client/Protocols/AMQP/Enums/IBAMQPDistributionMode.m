//
//  IBAMQPDistributionMode.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPDistributionMode.h"

@implementation IBAMQPDistributionMode
{
    NSMutableDictionary *_dictionary;
}

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self->_dictionary = [NSMutableDictionary dictionary];
        [self->_dictionary setValue:@(IBAMQPMoveDistributionMode)   forKey:@"move"];
        [self->_dictionary setValue:@(IBAMQPCopyDistributionMode)   forKey:@"copy"];

    }
    return self;
}


- (instancetype) initWithDistributionMode:(IBAMQPDistributionModes)type {
    self = [self init];
    if (self != nil) {
        self->_value = type;
    }
    return self;
}

+ (instancetype) enumWithDistributionMode:(IBAMQPDistributionModes)type {
    return [[IBAMQPDistributionMode alloc] initWithDistributionMode:type];
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

- (IBAMQPDistributionModes) valueByName : (NSString *) name {
    return [[self->_dictionary objectForKey:name] integerValue];
}

- (NSDictionary *) items {
    return self->_dictionary;
}

@end
