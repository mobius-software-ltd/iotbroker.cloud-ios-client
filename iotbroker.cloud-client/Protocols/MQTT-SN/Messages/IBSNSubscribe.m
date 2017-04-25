//
//  IBSNSubscribe.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNSubscribe.h"

@implementation IBSNSubscribe

- (instancetype) initWithMessageID : (NSInteger) messageID topic : (id<IBSNTopic>) topic dup : (BOOL) dup {
    self = [super init];
    if (self != nil) {
        self->_messageID = messageID;
        self->_topic = topic;
        self->_dup = dup;
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
    return IBSubscribeMessage;
}

- (BOOL)isDup {
    return self->_dup;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n - messageID = %zd\n - topic = %@\n - dup = %@", self->_messageID, self->_topic, self->_dup?@"yes":@"no"];
}

@end
