//
//  IBSNSearchGW.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNSearchGW.h"

@implementation IBSNSearchGW

- (instancetype) initWithRadius : (IBSNRadius) radius {
    self = [super init];
    if (self != nil) {
        self->_radius = radius;
    }
    return self;
}

- (NSInteger)getLength {
    return 3;
}

- (IBSNMessages)getMessageType {
    return IBSearchGWMessage;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n - radius = %zd", self->_radius];
}

@end
