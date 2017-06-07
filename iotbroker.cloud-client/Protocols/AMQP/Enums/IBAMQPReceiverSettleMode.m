//
//  IBAMQPReceiverSettleMode.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPReceiverSettleMode.h"

@implementation IBAMQPReceiverSettleMode
{
    NSMutableDictionary *_dictionary;
}

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self->_dictionary = [NSMutableDictionary dictionary];
        [self->_dictionary setValue:@(IBAMQPFirstReceiverSettleMode)    forKey:@"first"];
        [self->_dictionary setValue:@(IBAMQPSecondReceiverSettleMode)   forKey:@"second"];
    }
    return self;
}

- (instancetype) initWithReceiverSettleMode : (IBAMQPReceiverSettleModes) type {
    self = [self init];
    if (self != nil) {
        self->_value = type;
    }
    return self;
}

+ (instancetype) enumWithReceiverSettleMode : (IBAMQPReceiverSettleModes) type {
    return [[IBAMQPReceiverSettleMode alloc] initWithReceiverSettleMode:type];
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

- (IBAMQPReceiverSettleModes) valueByName : (NSString *) name {
    return [[self->_dictionary objectForKey:name] shortValue];
}

- (NSDictionary *) items {
    return self->_dictionary;
}

@end
