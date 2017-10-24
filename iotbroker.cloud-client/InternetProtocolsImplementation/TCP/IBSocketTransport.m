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

#import "IBSocketTransport.h"

@interface IBSocketTransport()
@property (strong, nonatomic) IBSocketEncoder *encoder;
@property (strong, nonatomic) IBSocketDecoder *decoder;
@end

@implementation IBSocketTransport

@synthesize state;
@synthesize delegate;
@synthesize runLoop;
@synthesize runLoopMode;
@synthesize host = _host;
@synthesize port = _port;
@synthesize tls = _tls;

- (instancetype) initWithHost : (NSString *) host andPort : (NSInteger) port {

    self = [super init];
    if (self != nil) {
        self.state = IBTransportCreated;
        self.runLoop = [NSRunLoop currentRunLoop];
        self.runLoopMode = NSRunLoopCommonModes;
        self->_host = host;
        self->_port = port;
        self->_tls = false;
    }
    return self;
}

- (void)start {
    self.state = IBTransportOpening;
    
    NSError *connectError = nil;
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)self.host, (UInt32)self.port, &readStream, &writeStream);
    
    CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
    CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);

    if (self.tls) {
        NSMutableDictionary *sslOptions = [[NSMutableDictionary alloc] init];
        
        [sslOptions setObject:(NSString *)kCFStreamSocketSecurityLevelNegotiatedSSL forKey:(NSString*)kCFStreamSSLLevel];
        
        if (self.certificates) {
            [sslOptions setObject:self.certificates forKey:(NSString *)kCFStreamSSLCertificates];
        }
        
        if(!CFReadStreamSetProperty(readStream, kCFStreamPropertySSLSettings, (__bridge CFDictionaryRef)(sslOptions))){
            connectError = [NSError errorWithDomain:@"TCP start"
                                               code:errSSLInternal
                                           userInfo:@{NSLocalizedDescriptionKey : @"Fail to set ssl for read stream"}];
        }
        if(!CFWriteStreamSetProperty(writeStream, kCFStreamPropertySSLSettings, (__bridge CFDictionaryRef)(sslOptions))){
            connectError = [NSError errorWithDomain:@"TCP start"
                                               code:errSSLInternal
                                           userInfo:@{NSLocalizedDescriptionKey : @"Fail to set ssl for write stream"}];
        }
    }
    
    if(!connectError){
        self.encoder.delegate = nil;
        self.encoder = [[IBSocketEncoder alloc] init];
        self.encoder.stream = CFBridgingRelease(writeStream);
        self.encoder.runLoop = self.runLoop;
        self.encoder.runLoopMode = self.runLoopMode;
        self.encoder.delegate = self;
        [self.encoder start];
        
        self.decoder.delegate = nil;
        self.decoder = [[IBSocketDecoder alloc] init];
        self.decoder.stream =  CFBridgingRelease(readStream);
        self.decoder.runLoop = self.runLoop;
        self.decoder.runLoopMode = self.runLoopMode;
        self.decoder.delegate = self;
        [self.decoder start];
        
    } else {
        [self stop];
    }
}

- (void)stop {
    self.state = IBTransportClosing;
    
    if (self.encoder) {
        [self.encoder stop];
        self.encoder.delegate = nil;
    }
    
    if (self.decoder) {
        [self.decoder stop];
        self.decoder.delegate = nil;
    }
}

- (BOOL)sendData:(NSData *)message {
    return [self.encoder write:message];
}

- (void)decoder:(IBSocketDecoder *)sender didReceiveMessage:(NSData *)data {
    [self.delegate internetProtocol:self didReceiveMessage:data];
}

- (void)decoder:(IBSocketDecoder *)sender didFailWithError:(NSError *)error {
    self.state = IBTransportClosing;
    [self.delegate internetProtocol:self didFailWithError:error];
}

- (void)encoder:(IBSocketEncoder *)sender didFailWithError:(NSError *)error {
    self.state = IBTransportClosing;
    [self.delegate internetProtocol:self didFailWithError:error];
}

- (void)decoderdidClose:(IBSocketDecoder *)sender {
    self.state = IBTransportClosed;
    [self.delegate internetProtocolDidStop:self];
}

- (void)encoderdidClose:(IBSocketEncoder *)sender {
    self.state = IBTransportClosed;
    [self.delegate internetProtocolDidStop:self];
}

- (void)decoderDidOpen:(IBSocketDecoder *)sender {
    self.state = IBTransportOpening;
    //[self.delegate internetProtocolDidStart:self];
}

- (void)encoderDidOpen:(IBSocketEncoder *)sender {
    self.state = IBTransportOpen;
    [self.delegate internetProtocolDidStart:self];
}

+ (NSArray *)clientCertsFromP12:(NSString *)path passphrase:(NSString *)passphrase {
    if (!path) {
        return nil;
    }
    
    NSData *pkcs12data = [[NSData alloc] initWithContentsOfFile:path];
    if (!pkcs12data) {
        return nil;
    }
    
    if (!passphrase) {
        return nil;
    }
    CFArrayRef keyref = NULL;
    OSStatus importStatus = SecPKCS12Import((__bridge CFDataRef)pkcs12data,
                                            (__bridge CFDictionaryRef)[NSDictionary dictionaryWithObject:passphrase forKey:(__bridge id)kSecImportExportPassphrase],
                                            &keyref);
    if (importStatus != noErr) {
        return nil;
    }
    
    CFDictionaryRef identityDict = CFArrayGetValueAtIndex(keyref, 0);
    if (!identityDict) {
        return nil;
    }
    
    SecIdentityRef identityRef = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
    if (!identityRef) {
        return nil;
    };
    
    SecCertificateRef cert = NULL;
    OSStatus status = SecIdentityCopyCertificate(identityRef, &cert);
    if (status != noErr) {
        return nil;
    }
    
    NSArray *clientCerts = [[NSArray alloc] initWithObjects:(__bridge id)identityRef, (__bridge id)cert, nil];
    return clientCerts;
}

@end
