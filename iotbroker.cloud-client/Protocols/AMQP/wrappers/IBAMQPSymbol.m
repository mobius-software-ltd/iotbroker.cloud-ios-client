//
//  IBAMQPSymbol.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPSymbol.h"

@implementation IBAMQPSymbol

- (instancetype) initWithString : (NSString *) value {
    self = [super init];
    if (self != nil) {
        self->_value = value;
    }
    return self;
}

- (NSString *)description {
    return self->_value;
}

- (NSUInteger)hash {
    NSInteger prime = 31;
    NSInteger result = 1;
    result = prime * result + ((self->_value == nil) ? 0 : self->_value.hash);
    return result;
}

- (BOOL)isEqual:(id)object {

    if (self == object) {
        return true;
    }
    if (object == nil) {
        return false;
    }
    if ([self class] != [object class]) {
        return false;
    }
    
    IBAMQPSymbol *other = (IBAMQPSymbol *)object;

    if (self->_value == nil) {
        if (other.value != nil) {
            return false;
        }
    } else if (![self->_value isEqual:other.value]) {
        return false;
    }
    return true;
}

- (id)copyWithZone:(NSZone *)zone {

    IBAMQPSymbol *copy = [[IBAMQPSymbol alloc] initWithString:self.value];
    return copy;
}

@end
