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

#import "IBCoAP.h"
#import "IBCoParser.h"
#import "IBUDPSocket.h"
#import "IBTimersMap.h"
#import "IBDTLSSocket.h"
#import "P12FileExtractor.h"
#import "IBMutableData.h"
#import "IBCoOptionParser.h"

@interface IBCoAP () <IBInternetProtocolDelegate>

@property (strong, nonatomic) IBTimersMap *timers;
@property (strong, nonatomic) NSString *clientID;
@property (strong, nonatomic) NSString *host;
@property (assign, nonatomic) int port;
@property (assign, nonatomic) int keepalive;
@property (strong, nonatomic) NSMutableDictionary<NSNumber *, NSString *> *topics;

@end

@implementation IBCoAP

#pragma mark - Initializers -

- (instancetype) initWithHost : (NSString *) host port : (NSInteger) port andResponseDelegate : (id<IBResponsesDelegate>) delegate {
    self = [super init];
    if (self != nil) {
        self->_host = host;
        self->_port = (int)port;
        self->_timers = [[IBTimersMap alloc] initWithRequest:self];
        self->_delegate = delegate;
        self->_topics = [[NSMutableDictionary alloc] init];
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
    
    NSData *data = [IBCoParser encode:message];
    if (data != nil) {
        return [self->_internetProtocol sendData:data];
    }
    return false;
}

- (void) connectWithAccount : (Account *) account {
    self.clientID = account.clientID;
    self.keepalive = account.keepalive;
}

- (void) publishMessage : (Message *) message {
    
    Byte qos = message.qos >= 1 ? 1 : message.qos;
    NSString *content = [[NSString alloc] initWithData:message.content encoding:NSUTF8StringEncoding];
    
    IBCoMessage *coapMessage = [IBCoMessage code:IBPUTMethod confirmableFlag:true andPayload:content];
    [coapMessage addOption:IBNodeId withValue:self.clientID];
    [coapMessage addOption:IBUriPathOption withValue:message.topicName];
    [coapMessage addOption:IBAcceptOption withData:[IBCoOptionParser encode:IBAcceptOption object:@(qos)]];
    [self->_timers startCoAPMessageTimer:coapMessage oneSend:(qos == IBAtMostOnce)];
}

- (void) subscribeToTopic : (Topic *) topic {

    Byte qos = topic.qos >= 1 ? 1 : topic.qos;
    
    IBCoMessage *coapMessage = [IBCoMessage code:IBGETMethod confirmableFlag:true andPayload:[NSString string]];
    [coapMessage addOption:IBNodeId withValue:self.clientID];
    [coapMessage addOption:IBUriPathOption withValue:topic.topicName];
    [coapMessage addOption:IBObserveOption withData:[IBCoOptionParser encode:IBObserveOption object:@(0)]];
    [coapMessage addOption:IBAcceptOption withData:[IBCoOptionParser encode:IBAcceptOption object:@(qos)]];
    NSInteger token = [self->_timers startCoAPMessageTimer:coapMessage oneSend:false];
    [self->_topics setObject:topic.topicName forKey:@(token)];
}

- (void) unsubscribeFromTopic : (Topic *) topic {
    
    Byte qos = topic.qos >= 1 ? 1 : topic.qos;
    
    IBCoMessage *coapMessage = [IBCoMessage code:IBGETMethod confirmableFlag:true andPayload:[NSString string]];
    [coapMessage addOption:IBNodeId withValue:self.clientID];
    [coapMessage addOption:IBUriPathOption withValue:topic.topicName];
    [coapMessage addOption:IBObserveOption withData:[IBCoOptionParser encode:IBObserveOption object:@(1)]];
    [coapMessage addOption:IBAcceptOption withData:[IBCoOptionParser encode:IBAcceptOption object:@(qos)]];
    NSInteger token = [self->_timers startCoAPMessageTimer:coapMessage oneSend:false];
    [self->_topics setObject:topic.topicName forKey:@(token)];
}

- (void) pingreq {
    
}

- (void) disconnectWithDuration : (NSInteger) duration {
    [self.timers stopAllTimers];
}

- (id<IBMessage>) getPingreqMessage {
    IBCoMessage *coapMessage = [IBCoMessage code:IBPUTMethod confirmableFlag:true andPayload:[NSString string]];
    [coapMessage addOption:IBNodeId withValue:self.clientID];
    return coapMessage;
}

- (void)connectionTimeout {
    [self.delegate timeout];
}

#pragma mark - IBInternetProtocolDelegate -

- (void) internetProtocolDidStart : (id<IBInternetProtocol>) internetProtocol {
    [self.delegate ready];
    [self.delegate connackWithCode:0];
    [self->_timers startPingTimerWithKeepAlive:self->_keepalive];
}

- (void) internetProtocolDidStop  : (id<IBInternetProtocol>) internetProtocol  {
    
}

- (void) internetProtocol : (id<IBInternetProtocol>) internetProtocol didReceiveMessage : (NSData *) buffer  {
        
    IBCoMessage *message = [IBCoParser decode:[NSMutableData dataWithData:buffer]];
    
    if (message == nil) {
        return;
    }

    if ((message.code == IBPOSTMethod || message.code == IBPUTMethod) && message.type != IBAcknowledgmentType) {
        NSNumber *number = (NSNumber *)[IBCoOptionParser decode:IBAcceptOption data:[message option:IBAcceptOption].value];
        NSString *topic = (NSString *)[IBCoOptionParser decode:IBUriPathOption data:[message option:IBUriPathOption].value];
        NSInteger qos = [number integerValue];
        if (topic != nil && topic.length > 0) {
            NSData *content = message.payload;
            [self.delegate publishWithTopicName:topic qos:qos content:content dup:false retainFlag:false];
        } else {
            IBCoMessage *ack = [IBCoMessage code:IBBadOptionResponseCode confirmableFlag:false andPayload:nil];
            [ack addOption:IBContentFormatOption withValue:@"text/plain"];
            [ack addOption:IBNodeId withValue:self->_clientID];
            ack.type = IBAcknowledgmentType;
            ack.messageID = message.messageID;
            ack.token = message.token;
            [self sendMessage:ack];
            return;
        }
    }
    
    switch (message.type) {
        case IBConfirmableType:
        {
            IBCoMessage *ack = [[IBCoMessage alloc] initWithCode:IBPUTMethod confirmableFlag:true andPayload:[NSString string]];
            [ack addOption:IBNodeId withValue:self.clientID];
            [ack setMessageID:message.messageID];
            [ack setToken:message.token];
            ack.type = IBAcknowledgmentType;
            [self sendMessage:ack];
        }   break;
        case IBNonConfirmableType:
        {
            [self->_timers removeTimerWithPacketID:@(message.token)];
        }   break;
        case IBAcknowledgmentType:
        {
            IBCoMessage *ack = [self->_timers removeTimerWithPacketID:@(message.token)];
            if ((NSInteger)ack.code == IBContentResponseCode) {
                NSString *topic = [self->_topics objectForKey:@(ack.token)];
                NSData *content = ack.payload;
                [self.delegate publishWithTopicName:topic qos:0 content:content dup:false retainFlag:false];
            }
            if (ack.code == IBGETMethod) {
                NSNumber *obsNumber = (NSNumber *)[IBCoOptionParser decode:IBObserveOption data:[ack option:IBObserveOption].value];
                NSNumber *qosNumber = (NSNumber *)[IBCoOptionParser decode:IBAcceptOption data:[ack option:IBAcceptOption].value];
                NSInteger observeOptionValue = [obsNumber integerValue];
                NSInteger qos = [qosNumber integerValue];
                NSString *topic = [self->_topics objectForKey:@(ack.token)];
                if (observeOptionValue == 0) {
                    [self.delegate subackForSubscribeWithTopicName:topic qos:qos returnCode:0];
                } else if (observeOptionValue == 1) {
                    [self.delegate unsubackForUnsubscribeWithTopicName:topic];
                }
            } else if (ack.code == IBPUTMethod) {
                NSNumber *number = (NSNumber *)[IBCoOptionParser decode:IBAcceptOption data:[ack option:IBAcceptOption].value];
                NSString *topic = (NSString *)[IBCoOptionParser decode:IBUriPathOption data:[ack option:IBUriPathOption].value];
                NSInteger qos = [number integerValue];
                if (qos != IBAtMostOnce) {
                    NSData *content = ack.payload;
                    [self.delegate pubackForPublishWithTopicName:topic qos:qos content:content dup:false retainFlag:false andReturnCode:0];
                }                
            }
        }   break;
        case IBResetType:
        {
            [self->_timers removeTimerWithPacketID:@(message.token)];
        }  break;
    }
}

- (void) internetProtocol : (id<IBInternetProtocol>) internetProtocol didFailWithError  : (NSError *) error  {
    
}

@end
