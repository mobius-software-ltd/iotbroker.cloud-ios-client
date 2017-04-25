//
//  IBSNWillMsgReq.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNWillMsgReq.h"

@implementation IBSNWillMsgReq

- (NSInteger)getLength {
    return 2;
}

- (IBSNMessages)getMessageType {
    return IBWillMsgReqMessage;
}

@end
