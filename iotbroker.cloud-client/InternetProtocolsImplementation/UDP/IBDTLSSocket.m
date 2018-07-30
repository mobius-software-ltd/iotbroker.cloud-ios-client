//
//  DTLSSocket.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 30.07.2018.
//  Copyright © 2018 MobiusSoftware. All rights reserved.
//

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
                                            userInfo:@{ NSLocalizedDescriptionKey : NSLocalizedString([[NSString alloc] init], nil) }];
    [self.delegate internetProtocol:self didFailWithError:error];

}

@end
