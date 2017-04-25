//
//  IBSNAdvertise.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNAdvertise.h"

@implementation IBSNAdvertise

- (instancetype) initWithGatewayID : (NSInteger) gwID andDuration : (NSInteger) duration {
    self = [super init];
    if (self != nil) {
        self->_gwID = gwID;
        self->_duration = duration;
    }
    return self;
}

- (NSInteger)getLength {
    return 5;
}

- (IBSNMessages)getMessageType {
    return IBAdvertiseMessage;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"\n - GatewayID = %zd, \n - Duration = %zd", self->_gwID, self->_duration];
}

@end
