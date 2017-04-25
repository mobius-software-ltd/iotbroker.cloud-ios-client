//
//  IBSNWillMsg.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNWillMsg.h"

@implementation IBSNWillMsg

- (instancetype) initWithContent : (NSData *) content {
    self = [super init];
    if (self != nil) {
        self->_content = content;
    }
    return self;
}

- (NSInteger)getLength {
    NSInteger length = 2;
    length += self->_content.length;
    if (self->_content.length > 253) {
        length += 2;
    }
    return length;
}

- (IBSNMessages)getMessageType {
    return IBWillMsgMessage;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n - content = %@", [[NSString alloc] initWithData:self->_content encoding:NSUTF8StringEncoding]];
}

@end
