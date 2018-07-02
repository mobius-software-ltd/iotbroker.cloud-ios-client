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

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IBTransportState) {
    
    IBTransportCreated  = 0,
    IBTransportOpening  = 1,
    IBTransportOpen     = 2,
    IBTransportClosing  = 3,
    IBTransportClosed   = 4,
};

@protocol IBInternetProtocolDelegate;

#pragma mark - IBInternetProtocol -

@protocol IBInternetProtocol <NSObject>

@property (weak, nonatomic) id<IBInternetProtocolDelegate> delegate;
@property (assign, nonatomic) IBTransportState state;
@property (strong, nonatomic, readonly) NSString *host;
@property (assign, nonatomic, readonly) NSInteger port;


- (instancetype) initWithHost : (NSString *) host andPort : (NSInteger) port;

- (void) start;
- (void) stop;
- (BOOL) sendData : (NSData *) message;

@end

#pragma mark - IBInternetProtocolDelegate -

@protocol IBInternetProtocolDelegate <NSObject>

- (void) internetProtocolDidStart : (id<IBInternetProtocol>) internetProtocol;
- (void) internetProtocolDidStop  : (id<IBInternetProtocol>) internetProtocol;
- (void) internetProtocol : (id<IBInternetProtocol>) internetProtocol didReceiveMessage : (NSData *) message;
- (void) internetProtocol : (id<IBInternetProtocol>) internetProtocol didFailWithError  : (NSError *) error;

@end
