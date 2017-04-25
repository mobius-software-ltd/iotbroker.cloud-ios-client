//
//  IBSNQoS.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNQoS.h"

@implementation IBSNQoS

- (instancetype) initWithValue : (Byte) value {
    
    self = [super init];
    if (self != nil) {
        self->_value = value;
    }
    return self;
}

+ (instancetype) claculateSubscriberQos : (IBSNQoS *) subscriberQos andPublisherQos : (IBSNQoS *) publisherQos {
    
    if (subscriberQos.value == publisherQos.value) {
        return subscriberQos;
    }
    
    if (subscriberQos.value > publisherQos.value) {
        return publisherQos;
    } else {
        return subscriberQos;
    }
}

- (BOOL) isValid {
    
    if (self->_value == IBAtMostOnce || self->_value == IBAtLeastOnce || self->_value == IBExactlyOnce || self->_value == IBLevelOne) {
        return true;
    }
    return false;
}

@end
