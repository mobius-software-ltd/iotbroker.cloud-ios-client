/**
 * Mobius Software LTD
 * Copyright 2015-2017, Mobius Software LTD
 *
 * This is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 2.1 of
 * the License, or (at your option) any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this software; if not, write to the Free
 * Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA, or see the FSF site: http://www.fsf.org.
 */

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
    return IBAMQPProtocolHeaderCode;
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
