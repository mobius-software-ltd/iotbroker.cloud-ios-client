//
//  IBAMQPLongID.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPLongID.h"

@implementation IBAMQPLongID

- (instancetype) initWithNumberID : (NSNumber *) number {
    self = [super init];
    if (self != nil) {
        self->_iD = number;
    }
    return self;
}

- (NSString *)string {
    return nil;
}

- (NSMutableData *)binary {
    return nil;
}

- (NSNumber *)longValue {
    return self->_iD;
}

- (NSUUID *)uuid {
    return nil;
}

@end
