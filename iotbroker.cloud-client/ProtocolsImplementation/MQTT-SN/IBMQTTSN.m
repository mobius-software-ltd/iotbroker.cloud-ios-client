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
#import "IBSNIdentifierTopic.h"
#import "IBDTLSSocket.h"
#import "P12FileExtractor.h"

@interface IBMQTTSN () <IBInternetProtocolDelegate>

@property (strong, nonatomic) NSString *clientID;
@property (assign, nonatomic) NSInteger keepalive;
@property (strong, nonatomic) IBWill *connectWill;
@property (strong, nonatomic) IBTimersMap *timers;
@property (strong, nonatomic) NSMutableDictionary<NSNumber *, IBSNPublish *> *forPublish;
@property (strong, nonatomic) NSMutableDictionary<NSNumber *, IBSNPublish *> *publishPackets;
@property (strong, nonatomic) NSMutableDictionary<NSNumber *, NSString *> *topics;
@property (strong, nonatomic) NSString *host;
@property (assign, nonatomic) int port;

@end

@implementation IBMQTTSN

#pragma mark - Initializers -

- (instancetype) initWithHost : (NSString *) host port : (NSInteger) port andResponseDelegate : (id<IBResponsesDelegate>) delegate {
    self = [super init];
    if (self != nil) {
        self->_host = host;
        self->_port = (int)port;
        self->_internetProtocol = nil;
        self->_timers = [[IBTimersMap alloc] initWithRequest:self];
        self->_delegate = delegate;
        self->_clientID = nil;
        self->_forPublish = [NSMutableDictionary dictionary];
        self->_publishPackets = [NSMutableDictionary dictionary];
        self->_topics = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - API's methods -

- (void) secureWithCertificatePath : (NSString *) certificate withPassword : (NSString *) password {
    self->_internetProtocol = [[IBDTLSSocket alloc] initWithHost:self->_host andPort:self->_port];
    self->_internetProtocol.delegate = self;
    [((IBDTLSSocket *)self->_internetProtocol) setCertificate:[P12FileExtractor certificateFromP12:certificate passphrase:password]];
}

- (void)prepareToSendingRequest {
    if (self->_internetProtocol == nil) {
        self->_internetProtocol = [[IBUDPSocket alloc] initWithHost:self->_host andPort:self->_port];
        self->_internetProtocol.delegate = self;
    }
    [self->_internetProtocol start];
}

- (BOOL) sendMessage : (id<IBMessage>) message {
    
    NSData *data = [self encodeMessage:message];
    if (data != nil) {
        return [self->_internetProtocol sendData:data];
    }
    return false;
}

- (void)connectionTimeout {
    [self.delegate timeout];
}

- (void) connectWithAccount : (Account *) account {

    IBMQTTTopic *topic = [IBMQTTTopic mqttTopic:account.willTopic qos:account.qos];
    if (topic != nil) {
        IBWill *willObject = [[IBWill alloc] initWithTopic:topic content:[account.will dataUsingEncoding:NSUTF8StringEncoding] andIsRetain:account.isRetain];
        self->_connectWill = willObject;
    } else {
        self->_connectWill = nil;
    }
    
    IBSNConnect *connect = [[IBSNConnect alloc] initWithWillPresent:(self->_connectWill != nil) cleanSession:account.cleanSession duration:account.keepalive clientID:account.clientID];
    self->_keepalive = account.keepalive;
    self->_clientID = account.clientID;
    [self->_timers startConnectTimer:connect];
}

- (void) publishMessage : (Message *) message {
    IBQoS *QoS = [[IBQoS alloc] initWithValue:message.qos];
    IBSNFullTopic *topic = [[IBSNFullTopic alloc] initWithValue:message.topicName andQoS:QoS];
    IBSNRegister *registerPacket = [[IBSNRegister alloc] initWithTopicID:0 packetID:0 andTopicName:message.topicName];
    IBSNPublish *publish = [[IBSNPublish alloc] initWithPacketID:0 topic:topic content:message.content dup:message.isDup retainFlag:message.isRetain];
    NSInteger packetId = [self->_timers startRegisterTimer:registerPacket];
    [self->_forPublish setObject:[publish copy] forKey:@(packetId)];
    [self->_publishPackets setObject:[publish copy] forKey:@(packetId)];
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
    [self.timers stopAllTimers];
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
                [self->_timers stopConnectTimer];
                [self.delegate connackWithCode:connack.returnCode];
                [self->_timers startPingTimerWithKeepAlive:self->_keepalive];
            } break;
            case IBWillTopicReqMessage:
            {
                [self->_timers stopConnectTimer];
                IBSNFullTopic *fullTopic = [[IBSNFullTopic alloc] initWithValue:self->_connectWill.topic.name andQoS:self->_connectWill.topic.qos];
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
                [self->_topics setObject:registerPacket.topicName forKey:@(registerPacket.topicID)];
                [self sendMessage:regack];
            } break;
            case IBRegackMessage:
            {
                IBSNRegack *regack = (IBSNRegack *)message;
                [self->_timers stopRegisterTimer];
                
                if (regack.returnCode == IBAcceptedReturnCode) {
                    IBSNPublish *publish = [self->_forPublish objectForKey:@(regack.packetID)];
                    [self->_topics setObject:[[NSString alloc] initWithData:[publish.topic encode] encoding:NSUTF8StringEncoding] forKey:@(regack.topicID)];
                    IBSNIdentifierTopic *topic = [[IBSNIdentifierTopic alloc] initWithValue:regack.topicID andQoS:[publish.topic getQoS]];
                    publish.packetID = regack.packetID;
                    publish.topic = topic;
                    if ([publish.topic getQoS].value == IBAtMostOnce) {
                        [self sendMessage:publish];
                    } else {
                        [self->_timers startMessageTimer:publish];
                    }
                }
            } break;
            case IBPublishMessage:
            {
                IBSNPublish *publish = (IBSNPublish *)message;
                if ([publish.topic getQoS].value == 1) {
                    if ([publish.topic isKindOfClass:[IBSNIdentifierTopic class]]) {
                        NSInteger topicID = [IBSNIdentifierTopic topicIdByEncodedValue:[publish.topic encode]];
                        IBSNPuback *puback = [[IBSNPuback alloc] initWithTopicID:topicID packetID:publish.packetID andReturnCode:IBAcceptedReturnCode];
                        [self sendMessage:puback];
                    }
                } else if ([publish.topic getQoS].value == 2) {
                    IBSNPubrec *pubrec = [[IBSNPubrec alloc] initWithPacketID:publish.packetID];
                    [self->_publishPackets setObject:publish forKey:@(publish.packetID)];
                    [self->_timers startMessageTimer:pubrec];
                }
                NSInteger topicID = [IBSNIdentifierTopic topicIdByEncodedValue:[publish.topic encode]];
                NSString *name =  [self->_topics objectForKey:@(topicID)];
                [self.delegate publishWithTopicName:name qos:[publish.topic getQoS].value content:publish.content dup:publish.dup retainFlag:publish.retainFlag];
            } break;
            case IBPubackMessage:
            {
                IBSNPuback *puback = (IBSNPuback *)message;
                [self->_timers removeTimerWithPacketID:@(puback.packetID)];
                IBSNPublish *publish = [self->_publishPackets objectForKey:@(puback.packetID)];
                NSString *name = [[NSString alloc] initWithData:[publish.topic encode] encoding:NSUTF8StringEncoding];
                [self.delegate pubackForPublishWithTopicName:name qos:[publish.topic getQoS].value content:publish.content dup:publish.dup retainFlag:publish.retainFlag andReturnCode:puback.returnCode];
                [self->_forPublish removeObjectForKey:@(puback.packetID)];
                [self->_publishPackets removeObjectForKey:@(puback.packetID)];
            } break;
            case IBPubrecMessage:
            {
                IBSNPubrec *pubrec = (IBSNPubrec *)message;
                [self->_timers removeTimerWithPacketID:@(pubrec.packetID)];
                IBSNPublish *publish = [self->_publishPackets objectForKey:@(pubrec.packetID)];
                IBSNPubrel *pubrel = [[IBSNPubrel alloc] initWithPacketID:pubrec.packetID];
                [self->_timers startMessageTimer:pubrel];
                NSInteger topicID = [IBSNIdentifierTopic topicIdByEncodedValue:[publish.topic encode]];
                NSString *name =  [self->_topics objectForKey:@(topicID)];
                [self.delegate pubrecForPublishWithTopicName:name qos:[publish.topic getQoS].value content:publish.content dup:publish.dup retainFlag:publish.retainFlag];
            } break;
            case IBPubrelMessage:
            {
                IBSNPubrel *pubrel = (IBSNPubrel *)message;
                [self->_timers removeTimerWithPacketID:@(pubrel.packetID)];
                IBSNPublish *publish = [self->_publishPackets objectForKey:@(pubrel.packetID)];
                IBSNPubcomp *pubcomp = [[IBSNPubcomp alloc] initWithPacketID:pubrel.packetID];
                [self sendMessage:pubcomp];
                NSInteger topicID = [IBSNIdentifierTopic topicIdByEncodedValue:[publish.topic encode]];
                NSString *name = [self->_topics objectForKey:@(topicID)];
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
            case IBSubscribeMessage:        NSLog(@" > Error: SNSubscribe message has been received");      break;
            case IBSubackMessage:
            {
                IBSNSuback *suback = (IBSNSuback *)message;
                IBSNSubscribe *subscribe = (IBSNSubscribe *)[self->_timers removeTimerWithPacketID:@(suback.packetID)];
                NSString *name = [[NSString alloc] initWithData:[subscribe.topic encode] encoding:NSUTF8StringEncoding];
                [self->_topics setObject:name forKey:@(suback.topicID)];
                [self.delegate subackForSubscribeWithTopicName:name qos:[subscribe.topic getQoS].value returnCode:suback.returnCode];
            } break;
            case IBUnsubscribeMessage:      NSLog(@" > Error: SNUnsubscribe message has been received");    break;
            case IBUnsubackMessage:
            {
                IBSNUnsuback *unsuback = (IBSNUnsuback *)message;
                IBSNUnsubscribe *unsubscribe = (IBSNUnsubscribe *)[self->_timers removeTimerWithPacketID:@(unsuback.packetID)];
                NSString *name = [[NSString alloc] initWithData:[unsubscribe.topic encode] encoding:NSUTF8StringEncoding];
                [self.delegate unsubackForUnsubscribeWithTopicName:name];
            } break;
            case IBPingreqMessage:          NSLog(@" > Error: SNPingreq message has been received");        break;
            case IBPingrespMessage:
            {
                [self.delegate pingresp];
            } break;
            case IBDisconnectMessage:
            {
                [self.timers stopAllTimers];
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
