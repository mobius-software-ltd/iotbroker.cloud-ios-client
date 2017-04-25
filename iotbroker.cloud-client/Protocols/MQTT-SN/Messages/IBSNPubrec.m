//
//  IBSNPubrec.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNPubrec.h"

@implementation IBSNPubrec

- (instancetype)initWithMessageID:(NSInteger)messageID {
    self = [super initWithMessageID:messageID];
    if (self != nil) {
        
    }
    return self;
}

- (IBSNMessages)getMessageType {
    return IBPubrecMessage;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n - messageID = %zd", self.messageID];
}

@end
