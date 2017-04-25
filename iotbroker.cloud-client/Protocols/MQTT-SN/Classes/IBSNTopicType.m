//
//  IBSNTopicType.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNTopicType.h"

@implementation IBSNTopicType

- (instancetype) initWithValue : (Byte) value {
    
    self = [super init];
    if (self != nil) {
        self->_value = value;
    }
    return self;
}

- (BOOL) isValid {

    if (self->_value == IBNamedTopicType || self->_value == IBIDTopicType || self->_value == IBShortTopicType) {
        return true;
    }
    return false;
}

@end
