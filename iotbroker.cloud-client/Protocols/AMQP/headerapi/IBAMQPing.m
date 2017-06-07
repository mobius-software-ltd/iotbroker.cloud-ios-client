//
//  IBAMQPing.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPing.h"

@implementation IBAMQPing

- (instancetype)init {
    IBAMQPHeaderCode *headerCode = [[IBAMQPHeaderCode alloc] initWithHeaderCode:IBAMQPPingHeaderCode];
    self = [super initWithCode:headerCode];

    return self;
}

- (IBAMQPTLVList *)arguments {
    return nil;
}

- (void)fillArguments:(IBAMQPTLVList *)list {

}

@end
