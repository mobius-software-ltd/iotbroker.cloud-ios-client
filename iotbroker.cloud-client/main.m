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

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "IBCoParser.h"
#import "IBCoAP.h"

#import "IBSocketTransport.h"

@interface Test : NSObject <IBInternetProtocolDelegate>

@end

@implementation Test
{
    IBSocketTransport *_tcpSocket;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self->_tcpSocket = [[IBSocketTransport alloc] initWithHost:@"198.41.30.241" andPort:1883];
        self->_tcpSocket.delegate = self;
        [self->_tcpSocket start];
    }
    return self;
}

- (void) internetProtocolDidStart : (id<IBInternetProtocol>) internetProtocol {
    NSLog(@"----------%@---------", internetProtocol);
    
    
    NSMutableData *data = [NSMutableData data];
    
    NSString *protocol = @"AMQP";
    
    Byte m1 = 0xb1;
    [data appendBytes:&m1 length:1];
    Byte size = 4;
    [data appendBytes:&size length:1];
    [data appendBytes:[[protocol dataUsingEncoding:NSUTF8StringEncoding] bytes] length:protocol.length];

    Byte protocolID = 0;
    
    Byte m2 = 0x50;
    [data appendBytes:&m2 length:1];
    [data appendBytes:&protocolID length:1];
    
    Byte major = 1;
    
    [data appendBytes:&m2 length:1];
    [data appendBytes:&major length:1];
    
    Byte minor = 0;
    
    [data appendBytes:&m2 length:1];
    [data appendBytes:&minor length:1];
    
    Byte revision = 0;
    
    [data appendBytes:&m2 length:1];
    [data appendBytes:&revision length:1];
    
    [data appendBytes:[[@"HELLO!!!" dataUsingEncoding:NSUTF8StringEncoding] bytes] length:8];
    
    [internetProtocol sendData:data];
}

- (void) internetProtocolDidStop  : (id<IBInternetProtocol>) internetProtocol {
    
}

- (void) internetProtocol : (id<IBInternetProtocol>) internetProtocol didReceiveMessage : (NSData *) message {
    
}

- (void) internetProtocol : (id<IBInternetProtocol>) internetProtocol didFailWithError  : (NSError *) error {
    
}

@end

int main(int argc, char * argv[]) {
    
    Test *test = [[Test alloc] init];
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
