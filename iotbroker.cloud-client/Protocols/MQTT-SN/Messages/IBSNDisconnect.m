//
//  IBSNDisconnect.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNDisconnect.h"

@implementation IBSNDisconnect

- (instancetype) initWithDuration : (NSInteger) duration {
    self = [super init];
    if (self != nil) {
        self->_duration = duration;
    }
    return self;
}

- (NSInteger)getLength {
    NSInteger length = 2;
    if (self->_duration > 0) {
        length += 2;
    }
    return length;
}

- (IBSNMessages)getMessageType {
    return IBDisconnectMessage;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n - duration = %zd", self->_duration];
}

@end
