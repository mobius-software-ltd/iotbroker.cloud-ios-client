//
//  IBAMQPHeader.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPHeader.h"

@implementation IBAMQPHeader

- (instancetype) initWithCode : (IBAMQPHeaderCode *) code {
    self = [super init];
    if (self != nil) {
        self->_code = code;
        self->_doff = 2;
        self->_type = 0;
        self->_chanel = 0;
    }
    return self;
}

- (NSInteger)getLength {
    return 8;
}

- (NSInteger)type {
    @throw [NSException exceptionWithName:[[self class] description] reason:@"arguments: - abstract" userInfo:nil];
    return 0;
}

- (IBAMQPTLVList *) arguments {
    @throw [NSException exceptionWithName:[[self class] description] reason:@"arguments: - abstract" userInfo:nil];
    return nil;
}

- (void) fillArguments : (IBAMQPTLVList *) list {
    @throw [NSException exceptionWithName:[[self class] description] reason:@"fillArguments: - abstract" userInfo:nil];
}

@end
