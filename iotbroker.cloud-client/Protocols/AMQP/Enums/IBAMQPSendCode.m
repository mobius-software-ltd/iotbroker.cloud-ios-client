//
//  IBAMQPSendCode.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPSendCode.h"

@implementation IBAMQPSendCode
{
    NSMutableDictionary *_dictionary;
}

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self->_dictionary = [NSMutableDictionary dictionary];
        [self->_dictionary setValue:@(IBAMQPUnsettledSendCode)  forKey:@"unsettled"];
        [self->_dictionary setValue:@(IBAMQPSettledSendCode)    forKey:@"settled"];
        [self->_dictionary setValue:@(IBAMQPMixedSendCode)      forKey:@"mixed"];
    }
    return self;
}

- (instancetype) initWithSendCode : (IBAMQPSendCodes) type {
    self = [self init];
    if (self != nil) {
        self->_value = type;
    }
    return self;
}

+ (instancetype) enumWithSendCode : (IBAMQPSendCodes) type {
    return [[IBAMQPSendCode alloc] initWithSendCode:type];
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

- (IBAMQPSendCodes) valueByName : (NSString *) name {
    return [[self->_dictionary objectForKey:name] shortValue];
}

- (NSDictionary *) items {
    return self->_dictionary;
}

@end
