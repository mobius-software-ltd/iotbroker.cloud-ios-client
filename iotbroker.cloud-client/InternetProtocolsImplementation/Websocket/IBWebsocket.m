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

#import "IBWebsocket.h"

@interface IBWebsocket() <SRWebSocketDelegate>

@end

@implementation IBWebsocket
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
        self->_state = IBTransportCreated;
        self->_host = host;
        self->_port = port;
        NSString *type = @"ws";
        NSString *url = [NSString stringWithFormat:@"%@://%@:%zd/%@", type, self->_host, self->_port, type];
        self->_webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:url]];
        self->_webSocket.delegate = self;
    }
    return self;
}

- (void)configureProtocol:(IBProtocolType)protocol security:(BOOL)sec {
    
}

- (void) setCertificate: (char *)certificate {
    NSString *type = @"wss";
    NSString *urlString = [NSString stringWithFormat:@"%@://%@:%zd/%@", type, self->_host, self->_port, type];
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSData *certData = [NSData dataWithBytes:certificate length:strlen(certificate)];
    CFDataRef certDataRef = (__bridge CFDataRef)certData;
    SecCertificateRef certRef = SecCertificateCreateWithData(NULL, certDataRef);
    id cert = (__bridge id)certRef;
    
    [request setSR_SSLPinnedCertificates:@[cert]];
    self->_webSocket = [[SRWebSocket alloc] initWithURLRequest:request];
}

- (void) start {
    self->_state = IBTransportOpening;
    [self->_webSocket open];
}

- (void) stop {
    self->_state = IBTransportClosed;
    [self->_webSocket close];
}

- (void) sendData : (NSData *) message {
    [self->_webSocket send:[[NSString alloc] initWithData:message encoding:NSUTF8StringEncoding]];
}

#pragma mark - SRWebSocketDelegate -

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    if ([message isKindOfClass:[NSData class]]) {
        NSData *data = (NSData *)message;
        [self.delegate internetProtocol:self didReceiveMessage:data];
    } else if ([message isKindOfClass:[NSString class]]) {
        NSData *data = [((NSString *)message) dataUsingEncoding:NSUTF8StringEncoding];
        [self.delegate internetProtocol:self didReceiveMessage:data];
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    self->_state = IBTransportOpen;
    [self.delegate internetProtocolDidStart:self];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    [self.delegate internetProtocol:self didFailWithError:error];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    self->_state = IBTransportClosed;
    NSError *error = [[NSError alloc] initWithDomain:[NSString stringWithFormat:@"%@", [self class]]
                                                code:code
                                            userInfo:@{ NSLocalizedDescriptionKey : NSLocalizedString(reason, nil) }];
    [self.delegate internetProtocol:self didFailWithError:error];
    [self.delegate internetProtocolDidStop:self];
}

@end
