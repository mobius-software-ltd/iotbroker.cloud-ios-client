//
//  IBSNPublish.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNPublish.h"

@implementation IBSNPublish

- (instancetype) initWithMessageID : (NSInteger) messageID topic : (id<IBSNTopic>) topic content : (NSData *) content dup : (BOOL) dup retainFlag : (BOOL) retainFlag {
    self = [super init];
    if (self != nil) {
        self->_messageID = messageID;
        self->_topic = topic;
        self->_content = content;
        self->_dup = dup;
        self->_retainFlag = retainFlag;
    }
    return self;
}

- (NSInteger)getLength {
    NSInteger length = 7;
    length += self->_content.length;
    if (self->_content.length > 248) {
        length += 2;
    }
    return length;
}

- (IBSNMessages)getMessageType {
    return IBPublishMessage;
}

- (BOOL)isDup {
    return self->_dup;
}

- (BOOL)isRetainFlag {
    return self->_retainFlag;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n - messageID = %zd\n - topic = %@\n - content = %@\n - dup = %@\n - retainFlag = %@", self->_messageID, self->_topic, [[NSString alloc] initWithData:self->_content encoding:NSUTF8StringEncoding], self->_dup?@"yes":@"no", self->_retainFlag?@"yes":@"no"];
}

@end
