//
//  IBAMQPBinaryID.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPBinaryID.h"

@implementation IBAMQPBinaryID 

- (instancetype) initWithBinaryID : (NSMutableData *) data {
    self = [super init];
    if (self != nil) {
        self->_iD = [NSMutableData dataWithData:data];
    }
    return self;
}

- (NSString *)string {
    return nil;
}

- (NSMutableData *)binary {
    return self->_iD;
}

- (NSNumber *)longValue {
    return nil;
}

- (NSUUID *)uuid {
    return nil;
}

@end
