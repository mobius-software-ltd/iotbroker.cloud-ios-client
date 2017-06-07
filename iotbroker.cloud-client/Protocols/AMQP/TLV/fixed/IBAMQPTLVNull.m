//
//  IBAMQPTLVNull.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPTLVNull.h"

@implementation IBAMQPTLVNull

- (instancetype) init {
    IBAMQPType *type = [IBAMQPType enumWithType:IBAMQPNullType];
    self = [super initWithConstructor:[[IBAMQPSimpleConstructor alloc] initWithType:type]];
    return self;
}

- (NSMutableData *)data {
    return self.constructor.data;
}

- (NSInteger)length {
    return 1;
}

- (NSMutableData *)value {
    return nil;
}

- (NSString *)description {
    return [self.constructor.type nameByValue];
}

@end
