//
//  IBAMQPProtoHeader.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPProtoHeader.h"

NSString *const IBAMQPProtocolName = @"AMQP";

@implementation IBAMQPProtoHeader

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self->_versionMajor = 1;
        self->_versionMinor = 0;
        self->_versionRevision = 0;
    }
    return self;
}

- (instancetype) initWithProtocolID : (NSInteger) protocolID {
    self = [self init];
    if (self != nil) {
        if (self->_protocolID != 0 && self->_protocolID != 3) {
            @throw [NSException exceptionWithName:[[self class] description] reason:@"wrong protocol id" userInfo:nil];
        }
        self->_protocolID = protocolID;
    }
    return self;
}

- (NSInteger) getLength {
    
    int length = 8;
    return length;
}

- (NSInteger) getMessageType {
    return 0;
}

- (NSMutableData *)bytes {
    
    NSMutableData *data = [NSMutableData data];
    [data appendData:[IBAMQPProtocolName dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendByte:self.protocolID];
    [data appendByte:self.versionMajor];
    [data appendByte:self.versionMinor];
    [data appendByte:self.versionRevision];

    return data;
}

- (IBAMQPTLVList *)arguments {
    return nil;
}

- (void)fillArguments:(IBAMQPTLVList *)list {
}

@end
