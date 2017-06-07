//
//  IBAMQPUUID.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPUUID.h"

@implementation IBAMQPUUID

- (instancetype) initWithUUID : (NSUUID *) uuid {
    self = [super init];
    if (self != nil) {
        self->_iD = uuid;
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
    return nil;
}

- (NSUUID *)uuid {
    return self->_iD;
}

@end
