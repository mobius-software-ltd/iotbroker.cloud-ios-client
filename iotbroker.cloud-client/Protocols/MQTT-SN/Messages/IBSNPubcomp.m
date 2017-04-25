//
//  IBSNPubcomp.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNPubcomp.h"

@implementation IBSNPubcomp

- (instancetype)initWithMessageID:(NSInteger)messageID {
    self = [super initWithMessageID:messageID];
    if (self != nil) {
    
    }
    return self;
}

- (IBSNMessages)getMessageType {
    return IBPubcompMessage;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n - messageID = %zd", self.messageID];
}

@end
