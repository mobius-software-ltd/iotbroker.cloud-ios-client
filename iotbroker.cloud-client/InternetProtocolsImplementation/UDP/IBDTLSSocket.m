/**
 * Mobius Software LTD
 * Copyright 2015-2018, Mobius Software LTD
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

#import "IBDTLSSocket.h"

@interface IBDTLSSocket() <IBDtlsDelegate>

@end

@implementation IBDTLSSocket 
{
    IBTransportState _state;
    NSString *_host;
    NSInteger _port;
}

@synthesize delegate;
@synthesize state = _state;
@synthesize host = _host;
@synthesize port = _port;

- (instancetype)initWithHost:(NSString *)host andPort:(NSInteger)port {
    self = [super init];
    if (self != nil) {
        self->_dtlsSocket = [[IBDtls alloc] init];
        self->_dtlsSocket.delegate = self;
        self->_state = IBTransportCreated;
        self->_host = host;
        self->_port = port;
        [self->_dtlsSocket setHost:(char *)[self->_host cStringUsingEncoding:NSUTF8StringEncoding] andPort:(int)self->_port];
    }
    return self;
}

- (void) setCertificate: (char *)certificate {
    [self->_dtlsSocket setCaCertificate:certificate andCertificate:certificate];
}

- (void) start {
    self->_state = IBTransportOpening;
    [self->_dtlsSocket start];
}

- (void) stop {
    [self->_dtlsSocket stop];
}

- (BOOL) sendData : (NSData *) message {
    [self->_dtlsSocket send: (char *)[message bytes]];
    return true;
}

#pragma mark - DtlsDelegate -

- (void) didConnect {
    self->_state = IBTransportOpen;
    [self.delegate internetProtocolDidStart:self];
}

- (void) didDisconnect {
    self->_state = IBTransportClosed;
    [self.delegate internetProtocolDidStop:self];
}

- (void) received: (char *)message {
    NSData *data = [[NSData alloc] initWithBytesNoCopy:message length:strlen(message)];
    [self.delegate internetProtocol:self didReceiveMessage:data];
}

- (void) error: (char *)message {
    self->_state = IBTransportClosed;
    NSError *error = [[NSError alloc] initWithDomain:[NSString stringWithFormat:@"%@", [self class]]
                                                code:-435
                                            userInfo:@{ NSLocalizedDescriptionKey : NSLocalizedString([[NSString alloc] initWithUTF8String:message], nil) }];
    [self.delegate internetProtocol:self didFailWithError:error];

}

@end
