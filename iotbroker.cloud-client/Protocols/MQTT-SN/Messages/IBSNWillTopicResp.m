//
//  IBSNWillTopicResp.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNWillTopicResp.h"

@implementation IBSNWillTopicResp

- (instancetype)initWithReturnCode:(IBSNReturnCode)returnCode {
    self = [super initWithReturnCode:returnCode];
    if (self != nil) {
    }
    return self;
}

- (IBSNMessages)getMessageType {
    return IBWillTopicRespMessage;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n - returnCode = %zd", self.returnCode];
}

@end
