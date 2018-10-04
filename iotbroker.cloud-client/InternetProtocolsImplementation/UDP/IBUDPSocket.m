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

#import "IBUDPSocket.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@interface IBUDPSocket () <GCDAsyncUdpSocketDelegate>

@end

@implementation IBUDPSocket
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
        self->_udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        self->_state = IBTransportCreated;
        self->_host = host;
        self->_port = port;
    }
    return self;
}

- (void) start {
    
    self->_state = IBTransportOpening;
    
    NSError *error = nil;
    
    if (![self->_udpSocket bindToPort:0 error:&error]) {
        self->_state = IBTransportClosed;
        NSLog(@"Error binding: %@", error);
        return;
    }
    
    if (![self->_udpSocket beginReceiving:&error]) {
        self->_state = IBTransportClosed;
        [self.udpSocket close];
        NSLog(@"Error receiving: %@", error);
        return;
    }
    
    self->_state = IBTransportOpen;
    [self.delegate internetProtocolDidStart:self];
}

- (void) stop {
    [self->_udpSocket closeAfterSending];
}

- (BOOL) sendData : (NSData *) message {
    [self->_udpSocket sendData:message toHost:self->_host port:self->_port withTimeout:-1 tag:1];
    return true;
}

#pragma mark - GCDAsyncUdpSocketDelegate -

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address {
    self->_state = IBTransportOpen;
    [self.delegate internetProtocolDidStart:self];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error {
    self->_state = IBTransportClosed;
    [self.delegate internetProtocol:self didFailWithError:error];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    NSLog(@"Did send message via udp protocol");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    [self.delegate internetProtocol:self didFailWithError:error];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(nullable id)filterContext {
    [self.delegate internetProtocol:self didReceiveMessage:[self addLastCCharacter:data]];
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error {
    self->_state = IBTransportClosed;
    [self.delegate internetProtocolDidStop:self];
}

- (NSData *)addLastCCharacter:(NSData *) data {
    char *bytes = (char *)[data bytes];
    bytes[data.length] = '\0';
    return [NSData dataWithBytes:bytes length:data.length];
}

@end
