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

#import "IBMQTT.h"

@implementation IBMQTT
{
    NSMutableArray<NSNumber *> *_arrayOfGenerationID;
    NSInteger _currentID;
    NSMutableDictionary *_subTopics;
    NSMutableDictionary *_unsubTopics;
}

- (instancetype) init {
    
    self = [super init];
    if (self != nil) {
        self->_parser = [[IBParser alloc] init];
        self->_socket = [[IBSocketTransport alloc] init];
        self->_arrayOfGenerationID = [NSMutableArray array];
        self->_subTopics = [NSMutableDictionary dictionary];
        self->_unsubTopics = [NSMutableDictionary dictionary];
        self->_currentID = 0;
    }
    return self;
}

+ (instancetype) sharedInstance {
    
    static IBMQTT *settings = nil;
    @synchronized (self) {
        if (settings == nil) {
            settings = [[self alloc] init];
        }
    }
    return settings;
}

- (void) startWithHost : (NSString *) host port : (NSInteger) port {

    if (self->_socket != nil) {
        [self stop];
    }
    
    self->_socket = [[IBSocketTransport alloc] initWithHost:host andPort:port];
    self->_socket.delegate = self;
    [self->_socket start];
}

- (void) stop {
    [self->_socket stop];
}

- (void)transport:(nonnull id<IBTransport>)transport didReceiveMessage:(NSData *)message {
    NSLog(@"didReceiveMessage");
    
    id<IBMessage> messageReceive = [self decodeObjcet:message];
    
    switch ([messageReceive getMessageType]) {
        case IBConnectMessage: NSLog(@" >> R : IBConnectMessage"); break;
            
        case IBConnackMessage: {
            NSLog(@" >> R : IBConnackMessage");
            IBConnack *connack = (IBConnack *)messageReceive;
            [self.connectDelegate connectionAcknowledgmentReceivedWithCode:connack.returnCode andSessionPresent:connack.sessionPresentValue];
        } break;
        case IBPublishMessage: {
            NSLog(@" >> R : IBPublishMessage");
            IBPublish *publish = (IBPublish *)messageReceive;
            [self.publishInDelegate publishRequestWithPacketID:publish.packetID topic:publish.topic content:publish.content isRetain:publish.isRetain andIsDup:publish.dup];
        } break;
        case IBPubackMessage: {
            NSLog(@" >> R : IBPubackMessage");
            IBPuback *puback = (IBPuback *)messageReceive;
            [self.publishOutDelegate publishAcknowledgmentReceivedWithPacketID:puback.packetID];
        } break;
        case IBPubrecMessage: {
            NSLog(@" >> R : IBPubrecMessage");
            IBPubrec *pubrec = (IBPubrec *)messageReceive;
            [self.publishOutDelegate publishReceivedWithPacketID:pubrec.packetID];
        } break;
        case IBPubrelMessage: {
            NSLog(@" >> R : IBPubrelMessage");
            IBPubrel *pubrel = (IBPubrel *)messageReceive;
            [self.publishInDelegate publishReleaseReceivedWithPacketID:pubrel.packetID];
        } break;
        case IBPubcompMessage: {
            NSLog(@" >> R : IBPubcompMessage");
            IBPubcomp *pubcomp = (IBPubcomp *)messageReceive;
            [self.publishOutDelegate publishCompleteReceivedWithPacketID:pubcomp.packetID];
        } break;
        case IBSubscribeMessage:    NSLog(@" >> R : IBSubscribeMessage");   break;
        case IBSubackMessage: {
            NSLog(@" >> R : IBSubackMessage");
            IBSuback *suback = (IBSuback*)messageReceive;
            [self->_arrayOfGenerationID removeObject:@(suback.packetID)];
            IBSubscribe *topics = [self checkSuback:suback withPacketID:suback.packetID];
            [self.subscribeDelegate subscribeAcknowledgmentReceivedWithPacketID:suback.packetID andSubscribe:topics];
        
        } break;
        case IBUnsubscribeMessage:  NSLog(@" >> R : IBUnsubscribeMessage"); break;
        case IBUnsubackMessage: {
            NSLog(@" >> R : IBUnsubackMessage");
            IBUnsuback *unsuback = (IBUnsuback*)messageReceive;
            [self->_arrayOfGenerationID removeObject:@(unsuback.packetID)];
            NSArray *topics = [self->_unsubTopics objectForKey:@(unsuback.packetID)];
            [self.subscribeDelegate usubscribeAcknowledgmentReceivedWithPacketID:unsuback.packetID fromTopics:topics];
        } break;
        case IBPingreqMessage:      NSLog(@" >> R : IBPingreqMessage");     break;
        case IBPingrespMessage: {
            NSLog(@" >> R : IBPingrespMessage");
            [self.pingDelegate pingResponseReceived];
        } break;
        case IBDisconnectMessage:   NSLog(@" >> R : IBDisconnectMessage");  break;
        default: break;
    }
}

- (IBSubscribe *) checkSuback : (IBSuback *) result withPacketID : (NSInteger) packetID {
    
    IBSubscribe *topics = [self->_subTopics objectForKey:@(packetID)];
    
    IBSubscribe *returnValue = [[IBSubscribe alloc] initWithPacketID:packetID];
    
    if (result.returnCodes.count == topics.topics.count) {
    
        for (int i = 0; i < result.returnCodes.count; i++) {
            NSInteger returnQosValue = [[result.returnCodes objectAtIndex:i] integerValue];
            NSInteger qosValue = [[topics.topics objectAtIndex:i].qos getValue];
            if (returnQosValue == qosValue) {
                [returnValue.topics addObject:[topics.topics objectAtIndex:i]];
            }
        }
        return returnValue;
    }
    return nil;
}

- (void)transportDidOpen:(_Nonnull id<IBTransport>)transport {
    NSLog(@"mqttTransportDidOpen");
    [self.delegate mqttDidOpen:self];    
}

- (void)transport:(_Nonnull id<IBTransport>)transport didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    [self.delegate mqtt:self didFailWithError:error];
    
}

- (void)transportDidClose:(_Nonnull id<IBTransport>)transport {
    NSLog(@"mqttTransportDidClose");
    [self.delegate mqttDidDisconnect:self];
    
}

//// MQTT API ----------------------------------------------------------

- (BOOL) connectWithAccount : (Account *) account {
        
    NSData *content = [account.will dataUsingEncoding:NSUTF8StringEncoding];
    
    IBQoS *qos = [[IBQoS alloc] initWithValue:account.qos];
    IBTopic *topic = [[IBTopic alloc] initWithName:account.willTopic andQoS:qos];
    IBWill *will = [[IBWill alloc] initWithTopic:topic content:content andIsRetain:account.isRetain];
    IBConnect *connect = [[IBConnect alloc] initWithUsername:account.username andPassword:account.password andClientID:account.clientID andCleanSession:account.cleanSession andWill:will];
    connect.keepalive = account.keepalive;
    
    NSData *data = [self encodeObject:connect];
    
    if (data != nil) {
        return [self->_socket write:data];
    }
    
    return false;
}

- (void) connectWithUserInfo : (id) userInfo {

    if ([userInfo isKindOfClass:[NSTimer class]]) {
        [self connectWithAccount:((NSTimer *)userInfo).userInfo];
    }
}

- (void) disconnect {

    IBDisconnect *disconnect = [[IBDisconnect alloc] init];
    NSData *data = [self encodeObject:disconnect];
    [self->_socket write:data];
}

- (BOOL) ping {

    IBPingreq *ping = [[IBPingreq alloc] init];
    NSData *data = [self encodeObject:ping];
    
    if (data != nil) {
        return [self->_socket write:data];
    }
    
    return false;
}

- (BOOL) publish : (IBPublish *) publish  {
    
    NSData *data = [self encodeObject:publish];
    
    if (data != nil) {
        return [self->_socket write:data];
    }
    
    return false;
}

- (void) publishWithUserInfo : (id) userInfo {

    if ([userInfo isKindOfClass:[NSTimer class]]) {
        [self publish:((NSTimer *)userInfo).userInfo];
    }
}

- (BOOL) pubackWithPacketID : (NSInteger) packetID {

    IBPuback *puback = [[IBPuback alloc] initWithPacketID:packetID];
    NSData *data = [self encodeObject:puback];
    
    if (data != nil) {
        return [self->_socket write:data];
    }
    
    return false;
}

- (BOOL) pubrecWithPacketID : (NSInteger) packetID {

    IBPubrec *pubrec = [[IBPubrec alloc] initWithPacketID:packetID];
    NSData *data = [self encodeObject:pubrec];
    
    if (data != nil) {
        return [self->_socket write:data];
    }
    
    return false;
}

- (void) pubrecWithUserInfo : (id) userInfo {

    if ([userInfo isKindOfClass:[NSTimer class]]) {
        NSTimer *timer = (NSTimer *)userInfo;
        if ([timer.userInfo isKindOfClass:[NSNumber class]]) {
            [self pubrecWithPacketID:[timer.userInfo integerValue]];
        }
    }
}

- (BOOL) pubrelWithPacketID : (NSInteger) packetID {
    
    IBPubrel *pubrel = [[IBPubrel alloc] initWithPacketID:packetID];
    NSData *data = [self encodeObject:pubrel];
    
    if (data != nil) {
        return [self->_socket write:data];
    }
    
    return false;
}

- (void) pubrelWithUserInfo : (id) userInfo {
    
    if ([userInfo isKindOfClass:[NSTimer class]]) {
        NSTimer *timer = (NSTimer *)userInfo;
        if ([timer.userInfo isKindOfClass:[NSNumber class]]) {
            [self pubrelWithPacketID:[timer.userInfo integerValue]];
        }
    }
}

- (BOOL) pubcompWithPacketID : (NSInteger) packetID {
    
    IBPubcomp *pubrel = [[IBPubcomp alloc] initWithPacketID:packetID];
    NSData *data = [self encodeObject:pubrel];
    
    if (data != nil) {
        return [self->_socket write:data];
    }
    
    return false;
}

- (BOOL) subscribeToTopics : (NSArray<IBTopic *> *) topics {

    IBSubscribe *subscribe = [[IBSubscribe alloc] initWithPacketID:[self generateNextID]];
    subscribe.topics = [NSMutableArray arrayWithArray:topics];
    
    NSData *data = [self encodeObject:subscribe];
    
    if (data != nil) {
        [self->_subTopics setObject:subscribe forKey:@(self->_currentID)];
        return [self->_socket write:data];
    }
    
    return false;
}

- (void) subscribeWithUserInfo : (id) userInfo {

    if ([userInfo isKindOfClass:[NSTimer class]]) {
        [self subscribeToTopics:((NSTimer *)userInfo).userInfo];
    }
}

- (BOOL) unsubscribeFromTopics : (NSArray<NSString *> *) topics {

    IBUnsubscribe *unsubscribe = [[IBUnsubscribe alloc] initWithPacketID:[self generateNextID]];
    unsubscribe.topics = [NSMutableArray arrayWithArray:topics];
    
    NSData *data = [self encodeObject:unsubscribe];
    
    if (data != nil) {
        [self->_unsubTopics setObject:unsubscribe.topics forKey:@(self->_currentID)];
        return [self->_socket write:data];
    }
    
    return false;
}

- (void) unsubscribeWithUserInfo : (id) userInfo {

    if ([userInfo isKindOfClass:[NSTimer class]]) {
        [self unsubscribeFromTopics:((NSTimer *)userInfo).userInfo];
    }
}

- (NSData *) encodeObject : (id<IBMessage>) object {

    NSData *result = nil;
    @try {
        result = (NSData *)[self->_parser encode:object];
    }
    @catch (NSException *exception) {
        NSLog(@"\nENCODE ERROR!\nNAME : %@ \nREASON : %@", exception.name, exception.reason);
    }
    return result;
}

- (id<IBMessage>) decodeObjcet : (NSData *) data {
    
    id<IBMessage> object = nil;
    if (data != nil) {
        @try {
            object = [self->_parser decode:[NSMutableData dataWithData:data]];
        }
        @catch (NSException *exception) {
            NSLog(@"\nDECODE ERROR!\nNAME : %@ \nREASON : %@", exception.name, exception.reason);
        }
    }
    return object;
}

- (NSInteger) generateNextID {

    NSInteger returnValue = 0;
    
    do {
        if (self->_currentID <= 0 || self->_currentID > 65535 - 1) {
            self->_currentID = 0;
        }
        self->_currentID++;
        NSNumber *number = [NSNumber numberWithInteger:self->_currentID];
        returnValue = [number integerValue];
        
    } while ([self isIDAlreadyExist:self->_currentID]);
    
    [self->_arrayOfGenerationID addObject:@(returnValue)];
    return returnValue;
}

- (BOOL) isIDAlreadyExist : (NSInteger) ID {
    
    for (NSNumber *item in self->_arrayOfGenerationID) {
        if ([item integerValue] == ID) {
            return true;
        }
    }
    return false;
}

@end
