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

#import <Foundation/Foundation.h>

typedef enum
{
    IBConnectMessage        = 1,
    IBConnackMessage        = 2,
    IBPublishMessage        = 3,
    IBPubackMessage         = 4,
    IBPubrecMessage         = 5,
    IBPubrelMessage         = 6,
    IBPubcompMessage        = 7,
    IBSubscribeMessage      = 8,
    IBSubackMessage         = 9,
    IBUnsubscribeMessage    = 10,
    IBUnsubackMessage       = 11,
    IBPingreqMessage        = 12,
    IBPingrespMessage       = 13,
    IBDisconnectMessage     = 14
    
} IBMessages;

typedef enum
{
    IBAccepted                      = 0,
    IBUnacceptableProtocolVersion   = 1,
    IBIdentifierRejected            = 2,
    IBServerUnavaliable             = 3,
    IBBadUserOrPass                 = 4,
    IBNotAuthorized                 = 5
    
} IBConnectReturnCode;

typedef enum
{
    IBAccepted_QoS0 = 0,
    IBAccepted_QoS1 = 1,
    IBAccepted_QoS2 = 2,
    IBFailure       = 128
    
} IBSubackCode;

@protocol IBMessage <NSObject>

- (NSInteger) getLength;
- (IBMessages) getMessageType;

@end
