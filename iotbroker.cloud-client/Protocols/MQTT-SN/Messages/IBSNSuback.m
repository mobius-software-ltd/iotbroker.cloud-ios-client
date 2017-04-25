//
//  IBSNSuback.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNSuback.h"

@implementation IBSNSuback

- (instancetype) initWithTopicID : (NSInteger) topicID messageID : (NSInteger) messageID returnCode : (IBSNReturnCode) returnCode lowedQos : (IBSNQoS *) allowedQos {
    self = [super initWithMessageID:messageID];
    if (self != nil) {
        self->_topicID = topicID;
        self->_returnCode = returnCode;
        self->_allowedQos = allowedQos;
    }
    return self;
}

- (NSInteger)getLength {
    return 8;
}

- (IBSNMessages)getMessageType {
    return IBSubackMessage;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n - messageID = %zd\n - topicID = %zd\n - returnCode = %zd\n - allowedQos = %zd", self.messageID, self->_topicID, self->_returnCode, self->_allowedQos.value];
}

@end
