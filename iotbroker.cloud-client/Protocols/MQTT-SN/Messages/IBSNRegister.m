//
//  IBSNRegister.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNRegister.h"

@implementation IBSNRegister

- (instancetype) initWithTopicID : (NSInteger) topicID messageID : (NSInteger) messageID andTopicName : (NSString *) topicName {
    self = [super init];
    if (self != nil) {
        self->_topicID = topicID;
        self->_messageID = messageID;
        self->_topicName = topicName;
    }
    return self;
}

- (NSInteger)getLength {
    if (self->_topicName.length == 0) {
        @throw [NSException exceptionWithName:@"Exception" reason:[NSString stringWithFormat:@"%@ must contain a valid topic name", [[self class] description]] userInfo:nil];
    }
    NSInteger length = 6;
    length += self->_topicName.length;
    if (self->_topicName.length > 249) {
        length += 2;
    }
    return length;
}

- (IBSNMessages)getMessageType {
    return IBRegisterMessage;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n - topicID = %zd\n - messageID = %zd\n - topicName = %@", self->_topicID, self->_messageID, self->_topicName];
}

@end
