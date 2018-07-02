//
//  IBCoOption.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 02.07.2018.
//  Copyright © 2018 MobiusSoftware. All rights reserved.
//

#import "IBCoOption.h"

@implementation IBCoOption

- (instancetype) initWithNumber: (int) number length: (int) length value: (NSData *) value {
    self = [super init];
    if (self != nil) {
        self->_number = number;
        self->_length = length;
        self->_value = value;
    }
    return self;
}

- (NSString *) stringValue {
    return [[NSString alloc] initWithData:self->_value encoding:NSUTF8StringEncoding];
}

@end
