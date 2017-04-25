//
//  IBSNWillTopicUpd.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNWillTopicUpd.h"

@implementation IBSNWillTopicUpd

- (instancetype) initWithTopic : (IBSNFullTopic *) topic andRetainFlag : (BOOL) retainFlag {
    self = [super init];
    if (self != nil) {
        self->_topic = topic;
        self->_retainFlag = retainFlag;
    }
    return self;
}

- (NSInteger)getLength {
    NSInteger length = 2;
    if (self->_topic != nil) {
        length += self->_topic.length + 1;
        if (self->_topic.length > 252) {
            length += 2;
        }
    }
    return length;
}

- (IBSNMessages)getMessageType {
    return IBWillTopicUpdMessage;
}

- (BOOL)isRetainFlag {
    return self->_retainFlag;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n - topic = %@\n retainFlag = %@", self->_topic, self->_retainFlag?@"yes":@"no"];
}

@end
