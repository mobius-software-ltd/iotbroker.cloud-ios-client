//
//  IBSNPuback.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNPuback.h"

@implementation IBSNPuback

- (instancetype) initWithTopicID : (NSInteger) topicID messageID : (NSInteger) messageID andReturnCode : (IBSNReturnCode) returnCode {
    self = [super initWithMessageID:messageID];
    if (self != nil) {
        self->_topicID = topicID;
        self->_returnCode = returnCode;
    }
    return self;
}

- (NSInteger)getLength {
    return 7;
}

- (IBSNMessages)getMessageType {
    return IBPubackMessage;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n - messageID = %zd\n - topicID = %zd\n - returnCode = %zd", self.messageID, self->_topicID, self->_returnCode];
}

@end
