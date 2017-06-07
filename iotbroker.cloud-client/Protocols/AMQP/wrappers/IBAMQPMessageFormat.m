//
//  IBAMQPMessageFormat.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPMessageFormat.h"
#import "IBMutableData.h"

@implementation IBAMQPMessageFormat

- (instancetype) initWithValue : (long) value {
    self = [super init];
    if (self != nil) {
    
    }
    return self;
}

- (instancetype) initWithMessageFormat : (NSInteger) format andVersion : (NSInteger) version {
    self = [super init];
    if (self != nil) {
        self->_messageFormat = format;
        self->_version = version;
    }
    return self;
}

- (long) encode {
    NSMutableData *data = [NSMutableData data];
    [data appendUInt24:(int)self.messageFormat];
    [data appendByte:(Byte)self.version];
    return [data readInt];
}

@end
