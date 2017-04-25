//
//  IBSNGWInfo.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNGWInfo.h"

@implementation IBSNGWInfo

- (instancetype) initWithGatewayID : (NSInteger) gwID andGatewayAddress : (NSString *) gwAddress {
    self = [super init];
    if (self != nil) {
        self->_gwID = gwID;
        self->_gwAddress = gwAddress;
    }
    return self;
}

- (NSInteger)getLength {
    NSInteger length = 3;
    if (self->_gwAddress.length != 0) {
        length += self->_gwAddress.length;
    }
    return length;
}

- (IBSNMessages)getMessageType {
    return IBGWInfoMessage;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n - GatewayID = %zd \n - gwAddress = %@", self->_gwID, self->_gwAddress];
}

@end
