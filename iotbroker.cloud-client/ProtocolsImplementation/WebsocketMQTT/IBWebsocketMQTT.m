//
//  IBWebsocketMQTT.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 02.08.2018.
//  Copyright © 2018 MobiusSoftware. All rights reserved.
//

#import "IBWebsocketMQTT.h"
#import "IBParser.h"
#import "IBSocketTransport.h"
#import "IBTimersMap.h"
#import "IBWebsocket.h"
#import "IBMQJsonParser.h"
#import "P12FileExtractor.h"

@interface IBWebsocketMQTT () <IBInternetProtocolDelegate>

@property (strong, nonatomic) NSTimer *timeoutTimer;
@property (strong, nonatomic) IBTimersMap *timers;
@property (assign, nonatomic) NSInteger keepalive;
@property (strong, nonatomic) NSMutableDictionary *publishPackets;

@end

@implementation IBWebsocketMQTT

#pragma mark - Initializers -

- (instancetype) initWithHost : (NSString *) host port : (NSInteger) port andResponseDelegate : (id<IBResponsesDelegate>) delegate {
    self = [super init];
    if (self != nil) {
        self->_timers = [[IBTimersMap alloc] initWithRequest:self];
        self->_internetProtocol = [[IBWebsocket alloc] initWithHost:host andPort:port];
        self->_internetProtocol.delegate = self;
        self->_delegate = delegate;
        self->_publishPackets = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - API's methods -

- (void) secureWithCertificatePath : (NSString *) certificate withPassword : (NSString *) password {
    if (certificate.length > 0 && password.length > 0) {
        [((IBWebsocket *)self->_internetProtocol) setCertificate:[P12FileExtractor certificateFromP12:certificate passphrase:password]];
    }
}

- (void)prepareToSendingRequest {
    [self->_internetProtocol start];
}

- (BOOL) sendMessage : (id<IBMessage>) message {
    
    NSData *data = [IBMQJsonParser json:message];
    if (data != nil) {
        [self->_internetProtocol sendData:data];
        return true;
    }
    return false;
}

- (void)connectWithAccount:(Account *)account {
    IBQoS *QoS = [[IBQoS alloc] initWithValue:account.qos];
    IBMQTTTopic *topic = [[IBMQTTTopic alloc] initWithName:account.willTopic andQoS:QoS];
    IBWill *willObject = [[IBWill alloc] initWithTopic:topic content:[account.will dataUsingEncoding:NSUTF8StringEncoding] andIsRetain:account.isRetain];
    IBConnect *connect = [[IBConnect alloc] initWithUsername:account.username password:account.password clientID:account.clientID
                                                   keepalive:account.keepalive cleanSession:account.cleanSession andWill:willObject];
    self->_keepalive = account.keepalive;
    [self->_timers startConnectTimer:connect];
    [self startTimeoutTimer];
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
    
    id<IBMessage> message = [IBMQJsonParser message:data];
    
    if (message == nil) {
        return;
    }
    
    switch ([message getMessageType]) {
        case IBConnectMessage:      NSLog(@" > Error: Connect message has been received");      break;
        case IBConnackMessage:
        {
            IBConnack *connack = (IBConnack *)message;
            if (connack.returnCode == IBAccepted) {
                [self stopTimeoutTimer];
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
    
}

- (void) internetProtocol : (id<IBInternetProtocol>) internetProtocol didFailWithError  : (NSError *) error {
    
}

#pragma mark - Private methods -

- (void) startTimeoutTimer {
    self->_timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:IBTimeoutTimerValue target:self selector:@selector(timeoutTimerMethod:) userInfo:nil repeats:false];
}

- (void) stopTimeoutTimer {
    [self->_timeoutTimer invalidate];
    self->_timeoutTimer = nil;
}

- (void) timeoutTimerMethod : (NSTimer *) timer {
    [self->_timers stopAllTimers];
    [self.delegate timeout];
}

@end
