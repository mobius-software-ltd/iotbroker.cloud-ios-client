//
//  IBSNUnsubscribe.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNUnsubscribe.h"

@implementation IBSNUnsubscribe

- (instancetype) initWithMessageID : (NSInteger) messageID topic : (id<IBSNTopic>) topic {
    self = [super init];
    if (self != nil) {
        self->_messageID = messageID;
        self->_topic = topic;
    }
    return self;
}

- (NSInteger)getLength {
    NSInteger length = 5;
    length += [self->_topic length];
    if ([self->_topic length] > 250) {
        length += 2;
    }
    return length;
}

- (IBSNMessages)getMessageType {
    return IBUnsubscribeMessage;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n - messageID = %zd\n - topic = %@", self->_messageID, self->_topic];
}

@end
