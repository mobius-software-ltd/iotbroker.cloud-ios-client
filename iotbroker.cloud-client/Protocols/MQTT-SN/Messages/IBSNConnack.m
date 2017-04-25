//
//  IBSNConnack.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNConnack.h"

@implementation IBSNConnack

- (IBSNMessages)getMessageType {
    return IBConnackMessage;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n - returnCode = %zd", self.returnCode];
}

@end
