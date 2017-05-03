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

#import "IBWill.h"
#import "IBMQTTSN.h"
#import "IBSNParser.h"
#import "IBUDPSocket.h"
#import "IBTimersMap.h"
#import "IBMutableData.h"
#import "IBSNWillTopic.h"
#import "IBSNShortTopic.h"

@interface IBMQTTSN () <IBInternetProtocolDelegate>

@property (strong, nonatomic) NSString *clientID;
@property (assign, nonatomic) NSInteger keepalive;
@property (strong, nonatomic) IBWill *connectWill;
@property (strong, nonatomic) IBTimersMap *timers;
@property (strong, nonatomic) IBSNPublish *forPublish;
@property (strong, nonatomic) NSMutableDictionary *publishPackets;

@end

@implementation IBMQTTSN

#pragma mark - Initializers -

- (instancetype) initWithHost : (NSString *) host port : (NSInteger) port andResponseDelegate : (id<IBResponsesDelegate>) delegate {
    self = [super init];
    if (self != nil) {
        self->_internetProtocol = [[IBUDPSocket alloc] initWithHost:host andPort:port];
        self->_timers = [[IBTimersMap alloc] initWithRequest:self];
        self->_internetProtocol.delegate = self;
        self->_delegate = delegate;
        self->_clientID = nil;
    }
    return self;
}

#pragma mark - API's methods -

- (void)prepareToSendingRequest {
    [self->_internetProtocol start];
}

- (BOOL) sendMessage : (id<IBMessage>) message {
    
    NSData *data = [self encodeMessage:message];
    
    if (data != nil) {
        return [self->_internetProtocol sendData:data];
    }
    return false;
}

- (void) connectWithAccount : (Account *) account {
    IBSNConnect *connect = [[IBSNConnect alloc] initWithWillPresent:(account.will != nil) cleanSession:account.cleanSession duration:account.keepalive clientID:account.clientID];
    IBQoS *QoS = [[IBQoS alloc] initWithValue:account.qos];
    IBMQTTTopic *topic = [[IBMQTTTopic alloc] initWithName:account.willTopic andQoS:QoS];
    IBWill *willObject = [[IBWill alloc] initWithTopic:topic content:[account.will dataUsingEncoding:NSUTF8StringEncoding] andIsRetain:account.isRetain];
    self->_keepalive = account.keepalive;
    self->_connectWill = willObject;
    self->_clientID = account.clientID;
    [self->_timers startConnectTimer:connect];
}

- (void) publishMessage : (Message *) message {
    IBQoS *QoS = [[IBQoS alloc] initWithValue:message.qos];
    IBSNFullTopic *topic = [[IBSNFullTopic alloc] initWithValue:message.topicName andQoS:QoS];
    IBSNRegister *registerPacket = [[IBSNRegister alloc] initWithTopicID:0 packetID:0 andTopicName:message.topicName];
    self->_forPublish = [[IBSNPublish alloc] initWithPacketID:0 topic:topic content:message.content dup:message.isDup retainFlag:message.isRetain];
    [self->_timers startMessageTimer:registerPacket];
}

- (void) subscribeToTopic : (Topic *) topic {
    IBQoS *QoS = [[IBQoS alloc] initWithValue:topic.qos];
    id<IBTopic> topicObject = [[IBSNFullTopic alloc] initWithValue:topic.topicName andQoS:QoS];
    
    IBSNSubscribe *subscribe = [[IBSNSubscribe alloc] initWithPacketID:0 topic:topicObject dup:false];
    [self->_timers startMessageTimer:subscribe];
}

- (void) unsubscribeFromTopic : (Topic *) topic {
    IBQoS *QoS = [[IBQoS alloc] initWithValue:topic.qos];
    IBSNFullTopic *fullTopic = [[IBSNFullTopic alloc] initWithValue:topic.topicName andQoS:QoS];
    IBSNUnsubscribe *unsubscribe = [[IBSNUnsubscribe alloc] initWithPacketID:0 topic:fullTopic];
    [self->_timers startMessageTimer:unsubscribe];
}

- (void) pingreq {
    [self->_timers startPingTimerWithKeepAlive:self->_keepalive];
}

- (void) disconnectWithDuration : (NSInteger) duration {
    IBSNDisconnect *disconnect = [[IBSNDisconnect alloc] initWithDuration:duration];
    [self sendMessage:disconnect];
}

- (id<IBMessage>) getPingreqMessage {
    if (self->_clientID != nil) {
        return [[IBSNPingreq alloc] initWithClientID:self->_clientID];
    }
    return nil;
}

#pragma mark - IBInternetProtocolDelegate -

- (void) internetProtocolDidStart : (id<IBInternetProtocol>) internetProtocol {
    [self.delegate ready];
}

- (void) internetProtocolDidStop  : (id<IBInternetProtocol>) internetProtocol {

}

- (void) internetProtocol : (id<IBInternetProtocol>) internetProtocol didReceiveMessage : (NSData *) data {

    @synchronized (self) {
     
        id<IBMessage> message = [self decodeData:data];
        
        if (message == nil) {
            return;
        }
        
        switch ([message getMessageType]) {
            case IBAdvertiseMessage:        NSLog(@" > Error: SNAdvertise message has been received");      break;
            case IBSearchGWMessage:         NSLog(@" > Error: SNSearch message has been received");         break;
            case IBGWInfoMessage:           NSLog(@" > Error: SNGWInfo message has been received");         break;
            case IBConnectMessage:          NSLog(@" > Error: SNConnect message has been received");        break;
            case IBConnackMessage:
            {
                IBSNConnack *connack = (IBSNConnack *)message;
                [self.delegate connackWithCode:connack.returnCode];
            } break;
            case IBWillTopicReqMessage:
            {
                [self->_timers stopConnectTimer];
                id<IBTopic> fullTopic = self->_connectWill.topic;
                IBSNWillTopic *willTopic = [[IBSNWillTopic alloc] initWithTopic:fullTopic andRetainFlag:self->_connectWill.isRetain];
                [self sendMessage:willTopic];
            } break;
            case IBWillTopicMessage:        NSLog(@" > Error: SNWillTopic message has been received");      break;
            case IBWillMsgReqMessage:
            {
                IBSNWillMsg *willMsg = [[IBSNWillMsg alloc] initWithContent:self->_connectWill.content];
                [self sendMessage:willMsg];
            } break;
            case IBWillMsgMessage:          NSLog(@" > Error: SNWillMsg message has been received");        break;
            case IBRegisterMessage:
            {
                IBSNRegister *registerPacket = (IBSNRegister *)message;
                IBSNRegack *regack = [[IBSNRegack alloc] initWithTopicID:registerPacket.topicID packetID:registerPacket.packetID returnCode:IBAcceptedReturnCode];
                [self sendMessage:regack];
            } break;
            case IBRegackMessage:
            {
                IBSNRegack *regack = (IBSNRegack *)message;
                IBSNRegister *registerPacket = [self->_timers removeTimerWithPacketID:@(regack.topicID)];
                if (registerPacket.topicID != regack.topicID) {
                    return;
                }
                if (regack.returnCode == IBAcceptedReturnCode) {
                    IBSNShortTopic *topic = [[IBSNShortTopic alloc] initWithValue:[@(regack.topicID) stringValue] andQoS:[self->_forPublish.topic getQoS]];
                    self->_forPublish.packetID = regack.packetID;
                    self->_forPublish.topic = topic;
                    [self->_timers startMessageTimer:self->_forPublish];
                }
            } break;
            case IBPublishMessage:
            {
                IBSNPublish *publish = (IBSNPublish *)message;
                if ([publish.topic getQoS].value == 1) {
                    NSString *topicIDString = [[NSString alloc] initWithData:[publish.topic encode] encoding:NSUTF8StringEncoding];
                    NSInteger topicID = [topicIDString integerValue];
                    IBSNPuback *puback = [[IBSNPuback alloc] initWithTopicID:topicID packetID:publish.packetID andReturnCode:IBAcceptedReturnCode];
                    [self sendMessage:puback];
                } else if ([publish.topic getQoS].value == 2) {
                    IBSNPubrec *pubrec = [[IBSNPubrec alloc] initWithPacketID:publish.packetID];
                    [self->_publishPackets setObject:publish forKey:@(publish.packetID)];
                    [self->_timers startMessageTimer:pubrec];
                }
                NSString *name = [[NSString alloc] initWithData:[publish.topic encode] encoding:NSUTF8StringEncoding];
                [self.delegate publishWithTopicName:name qos:[publish.topic getQoS].value content:publish.content dup:publish.dup retainFlag:publish.retainFlag];
            } break;
            case IBPubackMessage:
            {
                IBSNPuback *puback = (IBSNPuback *)message;
                IBSNPublish *publish = [self->_timers removeTimerWithPacketID:@(puback.packetID)];
                NSString *name = [[NSString alloc] initWithData:[publish.topic encode] encoding:NSUTF8StringEncoding];
                [self.delegate pubackForPublishWithTopicName:name qos:[publish.topic getQoS].value content:publish.content dup:publish.dup retainFlag:publish.retainFlag andReturnCode:puback.returnCode];
                [self->_publishPackets removeObjectForKey:@(puback.packetID)];
            } break;
            case IBPubrecMessage:
            {
                IBSNPubrec *pubrec = (IBSNPubrec *)message;
                IBSNPublish *publish = [self->_timers removeTimerWithPacketID:@(pubrec.packetID)];
                [self->_publishPackets setObject:publish forKey:@(publish.packetID)];
                IBSNPubrel *pubrel = [[IBSNPubrel alloc] initWithPacketID:pubrec.packetID];
                [self->_timers startMessageTimer:pubrel];
                NSString *name = [[NSString alloc] initWithData:[publish.topic encode] encoding:NSUTF8StringEncoding];
                [self.delegate pubrecForPublishWithTopicName:name qos:[publish.topic getQoS].value content:publish.content dup:publish.dup retainFlag:publish.retainFlag];
            } break;
            case IBPubrelMessage:
            {
                IBSNPubrel *pubrel = (IBSNPubrel *)message;
                [self->_timers removeTimerWithPacketID:@(pubrel.packetID)];
                IBSNPublish *publish = [self->_publishPackets objectForKey:@(pubrel.packetID)];
                IBSNPubcomp *pubcomp = [[IBSNPubcomp alloc] initWithPacketID:pubrel.packetID];
                [self sendMessage:pubcomp];
                NSString *name = [[NSString alloc] initWithData:[publish.topic encode] encoding:NSUTF8StringEncoding];
                [self.delegate pubrelForPublishWithTopicName:name qos:[publish.topic getQoS].value content:publish.content dup:publish.dup retainFlag:publish.retainFlag];
            } break;
            case IBPubcompMessage:
            {
                IBSNPubcomp *pubcomp = (IBSNPubcomp *)message;
                [self->_timers removeTimerWithPacketID:@(pubcomp.packetID)];
                IBSNPublish *publish = [self->_publishPackets objectForKey:@(pubcomp.packetID)];
                NSString *name = [[NSString alloc] initWithData:[publish.topic encode] encoding:NSUTF8StringEncoding];
                [self.delegate pubcompForPublishWithTopicName:name qos:[publish.topic getQoS].value content:publish.content dup:publish.dup retainFlag:publish.retainFlag];
                [self->_publishPackets removeObjectForKey:@(pubcomp.packetID)];
            } break;
            case IBSubscribeMessage:        NSLog(@" > Error: SNUNSubscribe message has been received");    break;
            case IBSubackMessage:
            {
                IBSNSuback *suback = (IBSNSuback *)message;
                IBSNSubscribe *subscribe = [self->_timers removeTimerWithPacketID:@(suback.packetID)];
                NSString *name = [[NSString alloc] initWithData:[subscribe.topic encode] encoding:NSUTF8StringEncoding];
                [self.delegate subackForSubscribeWithTopicName:name qos:[subscribe.topic getQoS].value returnCode:suback.returnCode];
            } break;
            case IBUnsubscribeMessage:
            {
                IBSNUnsuback *unsuback = (IBSNUnsuback *)message;
                IBSNUnsubscribe *unsubscribe = [self->_timers removeTimerWithPacketID:@(unsuback.packetID)];
                NSString *name = [[NSString alloc] initWithData:[unsubscribe.topic encode] encoding:NSUTF8StringEncoding];
                [self.delegate unsubackForUnsubscribeWithTopicName:name];
            } break;
            case IBUnsubackMessage:         NSLog(@" > Error: SNUnsubscribe message has been received");    break;
            case IBPingreqMessage:          NSLog(@" > Error: SNPingreq message has been received");        break;
            case IBPingrespMessage:
            {
                [self.delegate pingresp];
            } break;
            case IBDisconnectMessage:
            {
                IBSNDisconnect *disconnect = (IBSNDisconnect *)message;
                [self.delegate disconnectWithDuration:disconnect.duration];
            } break;
            case IBWillTopicUpdMessage:     NSLog(@" > Error: SNWillTopicUpd message has been received");   break;
            case IBWillMsgUpdMessage:       NSLog(@" > Error: SNWillMsgUpd message has been received");     break;
            case IBWillTopicRespMessage:    NSLog(@" > Error: SNWillTopicResp message has been received");  break;
            case IBWillMsgRespMessage:      NSLog(@" > Error: SNWillMsgResp message has been received");    break;
            case IBEncapsulatedMessage:     NSLog(@" > Error: SNEncapsulated message has been received");   break;
        }
    }
}

- (void) internetProtocol : (id<IBInternetProtocol>) internetProtocol didFailWithError  : (NSError *) error {

}

#pragma mark - Private methods -

- (NSData *) encodeMessage : (id<IBMessage>) message {
    
    NSData *data = nil;
    
    @try {
        data = [IBSNParser encode:message];
    } @catch (NSException *exception) {
        NSLog(@" > Exception: in class %@, method encodeMessage:. Description: %@", [[self class] description], exception.description);
    }
    return data;
}

- (id<IBMessage>) decodeData : (NSData *) data {
    
    id<IBMessage> message = nil;
    
    @try {
        message = [IBSNParser decode:[NSMutableData dataWithData:data]];
    } @catch (NSException *exception) {
        NSLog(@" > Exception: in class %@, method decodeData:. Description: %@", [[self class] description], exception.description);
    }
    return message;
}

- (void)dealloc {
    self->_clientID = nil;
}

@end
