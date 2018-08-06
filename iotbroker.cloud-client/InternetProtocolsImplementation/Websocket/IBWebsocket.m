//
//  IBWebsocket.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 02.08.2018.
//  Copyright © 2018 MobiusSoftware. All rights reserved.
//

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
        NSString *url = [NSString stringWithFormat:@"ws://%@:%zd", self->_host, self->_port];
        self->_webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:url]];
        self->_webSocket.delegate = self;
    }
    return self;
}

- (void) setCertificate: (char *)certificate {
    NSString *urlString = [NSString stringWithFormat:@"wss://%@:%zd", self->_host, self->_port];
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

- (BOOL) sendData : (NSData *) message {
    [self->_webSocket send:message];
    return true;
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