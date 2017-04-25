//
//  IBSNCountableMessage.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNCountableMessage.h"

@implementation IBSNCountableMessage

- (instancetype) initWithMessageID : (NSInteger) messageID {
    self = [super init];
    if (self != nil) {
        self->_messageID = messageID;
    }
    return self;
}

- (NSInteger)getLength {
    return 4;
}

@end
