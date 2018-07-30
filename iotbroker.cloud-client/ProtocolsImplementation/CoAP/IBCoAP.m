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

@interface IBCoAP () <IBInternetProtocolDelegate>

@property (strong, nonatomic) IBTimersMap *timers;
@property (assign, nonatomic) NSInteger qos;
@property (strong, nonatomic) NSString *clientID;
@property (assign, nonatomic) NSInteger messageID;
@property (assign, nonatomic) NSInteger token;

@property (strong, nonatomic) NSString *host;
@property (assign, nonatomic) int port;

@end

@implementation IBCoAP

#pragma mark - Initializers -

- (instancetype) initWithHost : (NSString *) host port : (NSInteger) port andResponseDelegate : (id<IBResponsesDelegate>) delegate {
    self = [super init];
    if (self != nil) {
        
        self->_host = host;
        self->_port = (int)port;
        
        self.messageID = 1 + arc4random() % 65536;
        self.token = 1 + arc4random() % INT_MAX;
        
        self->_timers = [[IBTimersMap alloc] initWithRequest:self];
        self->_delegate = delegate;
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
    self.qos = account.qos;
}

- (void) publishMessage : (Message *) message {
    
    NSString *content = [[NSString alloc] initWithData:message.content encoding:NSUTF8StringEncoding];
    IBCoMessage *coapMessage = [IBCoMessage code:IBPOSTMethod confirmableFlag:true andPayload:content];
    [coapMessage addOption:IBNodeId withValue:self.clientID];
    [coapMessage addOption:IBAcceptOption withValue:[@(self.qos) stringValue]];
    [coapMessage addOption:IBUriPathOption withValue:message.topicName];
    coapMessage.type = IBConfirmableType;
    [self startSendTimerWithMessage:coapMessage];
}

- (void) subscribeToTopic : (Topic *) topic {
 
    IBCoMessage *coapMessage = [IBCoMessage code:IBGETMethod confirmableFlag:true andPayload:[NSString string]];
    [coapMessage addOption:IBObserveOption withValue:[@(0) stringValue]];
    [coapMessage addOption:IBNodeId withValue:self.clientID];
    [coapMessage addOption:IBUriPathOption withValue:topic.topicName];
    coapMessage.type = IBConfirmableType;
    [self startSendTimerWithMessage:coapMessage];
}

- (void) unsubscribeFromTopic : (Topic *) topic {
    
    IBCoMessage *coapMessage = [IBCoMessage code:IBGETMethod confirmableFlag:true andPayload:[NSString string]];
    [coapMessage addOption:IBObserveOption withValue:[@(1) stringValue]];
    [coapMessage addOption:IBNodeId withValue:self.clientID];
    [coapMessage addOption:IBUriPathOption withValue:topic.topicName];
    coapMessage.type = IBConfirmableType;
    [self startSendTimerWithMessage:coapMessage];
}

- (void) pingreq {
    
}

- (void) disconnectWithDuration : (NSInteger) duration {
    
}

- (id<IBMessage>) getPingreqMessage {
    return nil;
}

#pragma mark - Private methods -

- (void) startSendTimerWithMessage : (id<IBMessage>) message {

    IBCoMessage *coapMessage = (IBCoMessage *)message;
    
    self.messageID++;
    self.token++;
    
    coapMessage.messageID = self.messageID % 65536;
    coapMessage.token = self.token % INT_MAX;
    
    [self->_timers startCoAPMessageTimer:message];
}

#pragma mark - IBInternetProtocolDelegate -

- (void) internetProtocolDidStart : (id<IBInternetProtocol>) internetProtocol {
    [self.delegate ready];
    [self.delegate connackWithCode:0];
}

- (void) internetProtocolDidStop  : (id<IBInternetProtocol>) internetProtocol  {
    
}

- (void) internetProtocol : (id<IBInternetProtocol>) internetProtocol didReceiveMessage : (NSData *) buffer  {
        
    IBCoMessage *message = [IBCoParser decode:[NSMutableData dataWithData:buffer]];
    
    if (message == nil) {
        return;
    }
    
    if (message.code == IBPOSTMethod || message.code == IBPUTMethod) {
        NSString *topic = [[message option:IBUriPathOption] stringValue];
        NSData *content = message.payload;
        if (topic != nil && content.length > 0) {
            [self.delegate publishWithTopicName:topic qos:0 content:content dup:false retainFlag:false];
        } else {
            IBCoMessage *ack = [IBCoMessage code:IBMethodNotAllowedResponseCode confirmableFlag:false andPayload:nil];
            [ack addOption:IBContentFormatOption withValue:@"text/plain"];
            ack.type = IBAcknowledgmentType;
            ack.messageID = message.messageID;
            ack.token = message.token;
            [self sendMessage:ack];
        }
    }
    
    switch (message.type) {
        case IBConfirmableType:
        {
            message.type = IBAcknowledgmentType;
            [self sendMessage:message];
        }   break;
        case IBNonConfirmableType:
        {
            [self->_timers removeTimerWithPacketID:@(message.token)];
        }   break;
        case IBAcknowledgmentType:
        {
            IBCoMessage *ack = [self->_timers removeTimerWithPacketID:@(message.token)];
            if ((NSInteger)message.code == IBContentResponseCode) {
                NSString *topic = [[message option:IBUriPathOption] stringValue];
                NSData *content = message.payload;
                [self.delegate publishWithTopicName:topic qos:0 content:content dup:false retainFlag:false];
            }
            if (ack.code == IBGETMethod) {
                NSInteger observeOptionValue = [[[message option:IBObserveOption] stringValue] integerValue];
                NSString *topic = [[message option:IBUriPathOption] stringValue];
                if (observeOptionValue == 0) {
                    [self.delegate subackForSubscribeWithTopicName:topic qos:0 returnCode:0];
                } else if (observeOptionValue == 1) {
                    [self.delegate unsubackForUnsubscribeWithTopicName:topic];
                }
            } else if (ack.code == IBPUTMethod) {
                NSString *topic = [[message option:IBUriPathOption] stringValue];
                NSData *content = ack.payload;
                [self.delegate pubackForPublishWithTopicName:topic qos:0 content:content dup:false retainFlag:false andReturnCode:0];
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
