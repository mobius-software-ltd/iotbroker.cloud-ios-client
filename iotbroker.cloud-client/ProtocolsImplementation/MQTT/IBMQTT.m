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

#import "IBMQTT.h"
#import "IBParser.h"
#import "IBSocketTransport.h"
#import "IBTimersMap.h"

@interface IBMQTT () <IBInternetProtocolDelegate>

@property (strong, nonatomic) IBTimersMap *timers;
@property (assign, nonatomic) NSInteger keepalive;
@property (strong, nonatomic) NSMutableDictionary *publishPackets;

@end

@implementation IBMQTT

#pragma mark - Initializers -

- (instancetype) initWithHost : (NSString *) host port : (NSInteger) port andResponseDelegate : (id<IBResponsesDelegate>) delegate {
    self = [super init];
    if (self != nil) {
        self->_timers = [[IBTimersMap alloc] initWithRequest:self];
        self->_internetProtocol = [[IBSocketTransport alloc] initWithHost:host andPort:1883];
        self->_internetProtocol.delegate = self;
        self->_delegate = delegate;
        self->_publishPackets = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - API's methods -

- (void) secureWithCertificatePath : (NSString *) certificate withPassword : (NSString *) password {
    ((IBSocketTransport *)self->_internetProtocol).tls = true;
    if (certificate.length > 0 && password.length > 0) {
        ((IBSocketTransport *)self->_internetProtocol).certificates = [IBSocketTransport clientCertsFromP12:certificate passphrase:password];
    }
}

- (void)prepareToSendingRequest {
    [self->_internetProtocol start];
}

- (BOOL) sendMessage : (id<IBMessage>) message {
    
    NSData *data = [self encodeMessage:message];
    if (data != nil) {
        [self->_internetProtocol sendData:data];
        return true;
    }
    return false;
}

- (void)connectionTimeout {
    [self.delegate timeout];
}

- (void)connectWithAccount:(Account *)account {
    IBQoS *QoS = [[IBQoS alloc] initWithValue:account.qos];
    IBWill *willObject = nil;
    if (account.will.length > 0 && account.willTopic.length > 0) {
        IBMQTTTopic *topic = [[IBMQTTTopic alloc] initWithName:account.willTopic andQoS:QoS];
        willObject = [[IBWill alloc] initWithTopic:topic content:[account.will dataUsingEncoding:NSUTF8StringEncoding] andIsRetain:account.isRetain];
    }
    IBConnect *connect = [[IBConnect alloc] initWithUsername:account.username password:account.password clientID:account.clientID
                                                   keepalive:account.keepalive cleanSession:account.cleanSession andWill:willObject];
    self->_keepalive = account.keepalive;
    [self->_timers startConnectTimer:connect];
}

- (void) publishMessage:(Message *)message {

    IBQoS *QoS = [[IBQoS alloc] initWithValue:message.qos];
    IBMQTTTopic *topic = [[IBMQTTTopic alloc] initWithName:message.topicName andQoS:QoS];
    
    IBPublish *publish = [[IBPublish alloc] initWithPacketID:0 andTopic:topic andContent:message.content andIsRetain:message.isRetain andDup:message.isDup];
    
    if (message.qos == 0) {
        [self sendMessage:publish];
        return;
    }
    
    [self->_timers startMessageTimer:publish];
}

- (void) subscribeToTopic:(Topic *)topic {
    
    IBQoS *QoS = [[IBQoS alloc] initWithValue:topic.qos];
    IBMQTTTopic *topicObject = [[IBMQTTTopic alloc] initWithName:topic.topicName andQoS:QoS];
    
    IBSubscribe *subscribe = [[IBSubscribe alloc] initWithPacketID:0];
    subscribe.topics = [NSMutableArray<IBMQTTTopic *> <IBMQTTTopic> arrayWithObject:topicObject];
        
    [self->_timers startMessageTimer:subscribe];
}

- (void) unsubscribeFromTopic:(Topic *)topic {

    IBUnsubscribe *unsubscribe = [[IBUnsubscribe alloc] initWithPacketID:0];
    NSMutableArray<NSString *> *topics = [NSMutableArray arrayWithObject:topic.topicName];
    unsubscribe.topics = topics;
    [self->_timers startMessageTimer:unsubscribe];
}

- (void) pingreq {
    [self->_timers startPingTimerWithKeepAlive:self->_keepalive];
}

- (void) disconnectWithDuration : (NSInteger) duration {
    [self->_timers stopAllTimers];
    [self sendMessage:[[IBDisconnect alloc] init]];
}

- (id<IBMessage>) getPingreqMessage {
    return [[IBPingreq alloc] init];
}

#pragma mark - IBInternetProtocolDelegate -

- (void) internetProtocolDidStart : (id<IBInternetProtocol>) internetProtocol {
    [self.delegate ready];
}

- (void) internetProtocolDidStop  : (id<IBInternetProtocol>) internetProtocol {

}

- (void) internetProtocol : (id<IBInternetProtocol>) internetProtocol didReceiveMessage : (NSData *) data {
    
    NSMutableData *packets = [NSMutableData dataWithData:data];
    
    do {
        NSMutableData *packet = [IBParser next:&packets];
        id<IBMessage> message = [self decodeData:packet];
                
        if (message == nil || packet == nil) {
            return;
        }
        
        switch ([message getMessageType]) {
            case IBConnectMessage:      NSLog(@" > Error: Connect message has been received");      break;
            case IBConnackMessage:
            {
                IBConnack *connack = (IBConnack *)message;
                if (connack.returnCode == IBAccepted) {
                    [self->_timers stopConnectTimer];
                    [self.delegate connackWithCode:connack.returnCode];
                    [self->_timers startPingTimerWithKeepAlive:self->_keepalive];
                }
            } break;
            case IBPublishMessage:
            {
                IBPublish *publish = (IBPublish *)message;
                IBQualitiesOfService qos = publish.topic.qos.value;
                
                if (qos == IBAtLeastOnce) {
                    IBPuback *puback = [[IBPuback alloc] initWithPacketID:publish.packetID];
                    [self sendMessage:puback];
                } else if (qos == IBExactlyOnce) {
                    IBPubrec *pubrec = [[IBPubrec alloc] initWithPacketID:publish.packetID];
                    [self->_publishPackets setObject:publish forKey:@(publish.packetID)];
                    [self->_timers startMessageTimer:pubrec];
                }
                [self.delegate publishWithTopicName:publish.topic.name qos:publish.topic.qos.value content:publish.content dup:publish.dup retainFlag:publish.isRetain];
            } break;
            case IBPubackMessage:
            {
                IBPuback *puback = (IBPuback *)message;
                IBPublish *publish = (IBPublish *)[self->_timers removeTimerWithPacketID:@(puback.packetID)];
                [self.delegate pubackForPublishWithTopicName:publish.topic.name qos:publish.topic.qos.value content:publish.content dup:publish.dup retainFlag:publish.isRetain andReturnCode:-1];
                [self->_publishPackets removeObjectForKey:@(puback.packetID)];
            } break;
            case IBPubrecMessage:
            {
                IBPubrec *pubrec = (IBPubrec *)message;
                IBPublish *publish = (IBPublish *)[self->_timers removeTimerWithPacketID:@(pubrec.packetID)];
                [self->_publishPackets setObject:publish forKey:@(publish.packetID)];
                IBPubrel *pubrel = [[IBPubrel alloc] initWithPacketID:pubrec.packetID];
                [self->_timers startMessageTimer:pubrel];
                [self.delegate pubrecForPublishWithTopicName:publish.topic.name qos:publish.topic.qos.value content:publish.content dup:publish.dup retainFlag:publish.isRetain];
            } break;
            case IBPubrelMessage:
            {
                IBPubrel *pubrel = (IBPubrel *)message;
                [self->_timers removeTimerWithPacketID:@(pubrel.packetID)];
                IBPublish *publish = [self->_publishPackets objectForKey:@(pubrel.packetID)];
                IBPubcomp *pubcomp = [[IBPubcomp alloc] initWithPacketID:pubrel.packetID];
                [self sendMessage:pubcomp];
                [self.delegate pubrelForPublishWithTopicName:publish.topic.name qos:publish.topic.qos.value content:publish.content dup:publish.dup retainFlag:publish.isRetain];
            } break;
            case IBPubcompMessage:
            {
                IBPubcomp *pubcomp = (IBPubcomp *)message;
                [self->_timers removeTimerWithPacketID:@(pubcomp.packetID)];

                IBPublish *publish = [self->_publishPackets objectForKey:@(pubcomp.packetID)];

                [self->_publishPackets removeObjectForKey:@(pubcomp.packetID)];
                [self.delegate pubcompForPublishWithTopicName:publish.topic.name qos:publish.topic.qos.value content:publish.content dup:publish.dup retainFlag:publish.isRetain];
            } break;
            case IBSubscribeMessage:    NSLog(@" > Error: Subscribe message has been received");    break;
            case IBSubackMessage:
            {
                IBSuback *suback = (IBSuback *)message;
                IBSubscribe *subscribe = (IBSubscribe *)[self->_timers stopTimerWithPacketID:@(suback.packetID)];
                IBMQTTTopic *topic = [subscribe.topics lastObject];
                [self.delegate subackForSubscribeWithTopicName:topic.name qos:topic.qos.value returnCode:[[suback.returnCodes lastObject] integerValue]];
            } break;
            case IBUnsubscribeMessage:  NSLog(@" > Error: Unsubscribe message has been received");  break;
            case IBUnsubackMessage:
            {
                IBUnsuback *unsuback = (IBUnsuback *)message;
                IBUnsubscribe *unsubscribe = (IBUnsubscribe *)[self->_timers stopTimerWithPacketID:@(unsuback.packetID)];
                [self.delegate unsubackForUnsubscribeWithTopicName:[unsubscribe.topics lastObject]];
            } break;
            case IBPingreqMessage:      NSLog(@" > Error: Pingreq message has been received");      break;
            case IBPingrespMessage:     [self->_delegate pingresp];                                 break;
            case IBDisconnectMessage:   NSLog(@" > Error: Disconnect message has been received");   break;
        }
        
    } while (packets.length > 0);
}

- (void) internetProtocol : (id<IBInternetProtocol>) internetProtocol didFailWithError  : (NSError *) error {

}

#pragma mark - Private methods -

- (NSData *) encodeMessage : (id<IBMessage>) message {
    
    NSData *data = nil;
    
    @try {
        data = [IBParser encode:message];
    } @catch (NSException *exception) {
        NSLog(@" > Exception: in class %@, method encodeMessage:. Description: %@", [[self class] description], exception.description);
    }
    return data;
}

- (id<IBMessage>) decodeData : (NSData *) data {
    
    id<IBMessage> message = nil;
    
    @try {
        message = [IBParser decode:[NSMutableData dataWithData:data]];
    } @catch (NSException *exception) {
        NSLog(@" > Exception: in class %@, method decodeData:. Description: %@", [[self class] description], exception.description);
    }
    return message;
}

- (NSMutableData *) nextPacketsData : (NSMutableData *) data {

    NSMutableData *packets = nil;
    
    @try {
        packets = [IBParser next:&data];
    } @catch (NSException *exception) {
        NSLog(@" > Exception: in class %@, method decodeData:. Description: %@", [[self class] description], exception.description);
    }
    return packets;
}

@end
