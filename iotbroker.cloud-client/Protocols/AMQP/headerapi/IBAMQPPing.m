//
//  IBAMQPPing.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPPing.h"

@implementation IBAMQPPing

- (instancetype)init {
    IBAMQPHeaderCode *headerCode = [[IBAMQPHeaderCode alloc] initWithHeaderCode:IBAMQPPingHeaderCode];
    self = [super initWithCode:headerCode];

    return self;
}

- (NSInteger) getLength {
    return 8;
}

- (NSInteger) getMessageType {
    return IBAMQPPingHeaderCode;
}

- (IBAMQPTLVList *)arguments {
    return nil;
}

- (void)fillArguments:(IBAMQPTLVList *)list {

}

@end
