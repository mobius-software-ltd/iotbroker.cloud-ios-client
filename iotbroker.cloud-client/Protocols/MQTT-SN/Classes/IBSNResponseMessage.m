//
//  IBSNResponseMessage.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNResponseMessage.h"

@implementation IBSNResponseMessage

- (instancetype) initWithReturnCode : (IBSNReturnCode) returnCode {
    self = [super init];
    if (self != nil) {
        self->_returnCode = returnCode;
    }
    return self;
}

- (NSInteger)getLength {
    return 3;
}

@end
