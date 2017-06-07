//
//  IBAMQPStringID.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPStringID.h"

@implementation IBAMQPStringID

- (instancetype) initWithStringID : (NSString *) stringID {
    
    self = [super init];
    if (self != nil) {
        self->_iD = stringID;
    }
    return self;
}

- (NSString *)string {
    return self->_iD;
}

- (NSMutableData *)binary {
    return nil;
}

- (NSNumber *)longValue {
    return nil;
}

- (NSUUID *)uuid {
    return nil;
}

@end
