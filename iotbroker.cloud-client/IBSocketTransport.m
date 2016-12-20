/**
 * Mobius Software LTD
 * Copyright 2015-2016, Mobius Software LTD
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

- (instancetype) initWithHost : (NSString *) host andPort : (NSInteger) port {

    self = [super init];
    if (self != nil) {
        self.host = host;
        self.port = port;
    }
    return self;
}

- (void)start {
    self.state = IBTransportOpening;
    
    NSError* connectError;
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)self.host, (UInt32)self.port, &readStream, &writeStream);
    
    CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
    CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
  
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

- (BOOL)write:(NSData *)data {
    return [self.encoder write:data];
}

- (void)decoder:(IBSocketDecoder *)sender didReceiveMessage:(NSData *)data {
    
    [self.delegate transport:self didReceiveMessage:data];
}

- (void)decoder:(IBSocketDecoder *)sender didFailWithError:(NSError *)error {
    //self.state = MQTTTransportClosing;
    //[self.delegate mqttTransport:self didFailWithError:error];
}
- (void)encoder:(IBSocketEncoder *)sender didFailWithError:(NSError *)error {
    self.state = IBTransportClosing;
    [self.delegate transport:self didFailWithError:error];
}

- (void)decoderdidClose:(IBSocketDecoder *)sender {
    self.state = IBTransportClosed;
    [self.delegate transportDidClose:self];
}
- (void)encoderdidClose:(IBSocketEncoder *)sender {
    //self.state = MQTTTransportClosed;
    //[self.delegate mqttTransportDidClose:self];
}

- (void)decoderDidOpen:(IBSocketDecoder *)sender {
    //self.state = MQTTTransportOpen;
    //[self.delegate mqttTransportDidOpen:self];
}
- (void)encoderDidOpen:(IBSocketEncoder *)sender {
    self.state = IBTransportOpen;
    [self.delegate transportDidOpen:self];
}

@end
