//
//  IBAMQPDecimal.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPDecimal.h"

@implementation IBAMQPDecimal

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self->_value = [NSMutableData data];
    }
    return self;
}

- (instancetype) initWithValue : (NSMutableData *) value {
    self = [super init];
    if (self != nil) {
        self->_value = [NSMutableData dataWithData:value];
    }
    return self;
}

- (instancetype) initWithByte : (Byte) byte {
    self = [self init];
    if (self != nil) {
        [self->_value appendByte:byte];
    }
    return self;
}

- (instancetype) initWithShort : (short) number {
    self = [self init];
    if (self != nil) {
        [self->_value appendShort:number];
    }
    return self;
}

- (instancetype) initWithInt : (int) number {
    self = [self init];
    if (self != nil) {
        [self->_value appendInt:number];
    }
    return self;
}

- (instancetype) initWithLong : (long) number {
    self = [self init];
    if (self != nil) {
        [self->_value appendLong:number];
    }
    return self;
}

- (instancetype) initWithFloat : (float) number {
    self = [self init];
    if (self != nil) {
        [self->_value appendFloat:number];
    }
    return self;
}

- (instancetype) initWithDouble : (double) number {
    self = [self init];
    if (self != nil) {
        [self->_value appendDouble:number];
    }
    return self;
}

- (Byte) byte {
    return [self->_value readByte];
}

- (short) shortNumber {
    return [self->_value readShort];
}

- (int) intNumber {
    return [self->_value readInt];
}

- (long) longNumber {
    return [self->_value readLong];
}

- (float) floatNumber {
    return [self->_value readFloat];
}

- (double) doubleNumber {
    return [self->_value readDouble];
}

@end
