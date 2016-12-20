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
#import "IBSocketTransport.h"
#import "IBParser.h"
#import "Account+CoreDataClass.h"

@class IBMQTT;

@protocol IBMQTTConnectionMessageDelegate <NSObject>

- (void) connectionAcknowledgmentReceivedWithCode : (IBConnectReturnCode) code andSessionPresent : (BOOL) sessionPresent;

@end

@protocol IBMQTTSubscribeMessageDelegate  <NSObject>

- (void) subscribeAcknowledgmentReceivedWithPacketID : (NSInteger) packetID andSubscribe : (IBSubscribe *) subscribe;
- (void) usubscribeAcknowledgmentReceivedWithPacketID : (NSInteger) packetID fromTopics : (NSArray<NSString *> *) topics;

@end

@protocol IBMQTTPublishInMessageDelegate  <NSObject>

- (void) publishRequestWithPacketID : (NSInteger) packetID topic : (IBTopic *) topic content : (NSData *) content isRetain : (BOOL) isRetain andIsDup : (BOOL) isDup;
- (void) publishReleaseReceivedWithPacketID : (NSInteger) packetID;

@end

@protocol IBMQTTPublishOutMessageDelegate  <NSObject>

- (void) publishAcknowledgmentReceivedWithPacketID : (NSInteger) packetID;
- (void) publishReceivedWithPacketID : (NSInteger) packetID;
- (void) publishCompleteReceivedWithPacketID : (NSInteger) packetID;

@end

/*
@protocol IBMQTTPublishMessageDelegate  <NSObject>

- (void) publishRequestWithPacketID : (NSInteger) packetID topic : (IBTopic *) topic content : (NSData *) content isRetain : (BOOL) isRetain andIsDup : (BOOL) isDup;
- (void) publishAcknowledgmentReceivedWithPacketID : (NSInteger) packetID;
- (void) publishReceivedWithPacketID : (NSInteger) packetID;            // 0
- (void) publishReleaseReceivedWithPacketID : (NSInteger) packetID;     // 1
- (void) publishCompleteReceivedWithPacketID : (NSInteger) packetID;    // 2

@end
*/

@protocol IBMQTTPingMessageDelegate  <NSObject>

- (void) pingResponseReceived;

@end

@protocol IBMQTTDelegate <NSObject>

@optional
- (void) mqttDidOpen : (IBMQTT *) mqtt;

@required
- (void) mqttDidDisconnect : (IBMQTT *) mqtt;
- (void) mqtt : (IBMQTT *) mqtt didFailWithError : (NSError *)error;

@end

@interface IBMQTT : NSObject <IBTransportDelegate>
{
    IBSocketTransport *_socket;
    IBParser *_parser;
}

@property (weak, nonatomic) id<IBMQTTDelegate> delegate;
@property (weak, nonatomic) id<IBMQTTConnectionMessageDelegate> connectDelegate;
@property (weak, nonatomic) id<IBMQTTSubscribeMessageDelegate> subscribeDelegate;
@property (weak, nonatomic) id<IBMQTTPublishInMessageDelegate> publishInDelegate;
@property (weak, nonatomic) id<IBMQTTPublishOutMessageDelegate> publishOutDelegate;
@property (weak, nonatomic) id<IBMQTTPingMessageDelegate> pingDelegate;

+ (instancetype) sharedInstance;

- (void) startWithHost : (NSString *) host port : (NSInteger) port;

- (BOOL) connectWithAccount : (Account *) account;
- (void) connectWithUserInfo : (id) userInfo;

- (void) disconnect;

- (BOOL) ping;

- (BOOL) publish : (IBPublish *) publish;
- (void) publishWithUserInfo : (id) userInfo;

- (BOOL) pubackWithPacketID : (NSInteger) packetID;
- (BOOL) pubrecWithPacketID : (NSInteger) packetID;
- (void) pubrecWithUserInfo : (id) userInfo;
- (BOOL) pubrelWithPacketID : (NSInteger) packetID;
- (void) pubrelWithUserInfo : (id) userInfo;
- (BOOL) pubcompWithPacketID : (NSInteger) packetID;

- (BOOL) subscribeToTopics : (NSArray<IBTopic *> *) topics;
- (void) subscribeWithUserInfo : (id) userInfo;

- (BOOL) unsubscribeFromTopics : (NSArray<NSString *> *) topics;
- (void) unsubscribeWithUserInfo : (id) userInfo;

- (NSInteger) generateNextID;

@end
