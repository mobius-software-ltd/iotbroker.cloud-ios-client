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

#import "IBAMQP.h"
#import "IBAMQPParser.h"
#import "IBNetwork.h"
#import "IBTimersMap.h"
#import "IBAMQPSimpleType.h"
#import "IBAMQPStringID.h"
#import "IBAMQPAccepted.h"
#import "IBAMQPTransferMap.h"

@interface IBAMQP () <IBInternetProtocolDelegate>

@property (strong, nonatomic) IBTimersMap *timers;
@property (assign, nonatomic) BOOL isSASLСonfirm;
@property (assign, nonatomic) NSInteger chanel;
@property (assign, nonatomic) long nextHandle;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSNumber *> *usedIncomingMappings;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSNumber *> *usedOutgoingMappings;
@property (strong, nonatomic) NSMutableDictionary<NSNumber *, NSString *> *usedMappings;
@property (strong, nonatomic) NSMutableArray<IBAMQPTransfer *> *pendingMessages;
@property (strong, nonatomic) Account *account;
@property (assign, nonatomic) NSInteger keepalive;
@end

@implementation IBAMQP

#pragma mark - Initializers -

- (instancetype) initWithHost : (NSString *) host port : (NSInteger) port andResponseDelegate : (id<IBResponsesDelegate>) delegate {
    self = [super init];
    if (self != nil) {
        self->_timers = [[IBTimersMap alloc] initWithRequest:self];
        self->_delegate = delegate;
        self->_isSASLСonfirm = false;
        self->_nextHandle = 1;
        self->_chanel = 0;
        self->_usedMappings = [NSMutableDictionary dictionary];
        self->_usedIncomingMappings = [NSMutableDictionary dictionary];
        self->_usedOutgoingMappings = [NSMutableDictionary dictionary];
        self->_pendingMessages = [NSMutableArray array];
        self->_internetProtocol = [[IBNetwork alloc] initWithHost:host andPort:port];
        [self->_internetProtocol configureProtocol:IBTCPProtocol security:false];
        self->_internetProtocol.delegate = self;
    }
    return self;
}

#pragma mark - API's methods -

- (void) secureWithCertificatePath : (NSString *) certificate withPassword : (NSString *) password {
    [self->_internetProtocol configureProtocol:IBTCPProtocol security:true];
    NSLog(@"%@: SET CERTFICATE", [[self class] description]);
}

- (void) setTopics:(NSArray<Topic *> *)topics {
    for (Topic *topic in topics) {
        long currentHandler = self->_nextHandle++;
        [self->_usedIncomingMappings setObject:[NSNumber numberWithLong:currentHandler] forKey:topic.topicName];
        [self->_usedMappings setObject:topic.topicName forKey:[NSNumber numberWithLong:currentHandler]];
    }
}

- (void)prepareToSendingRequest {
    [self->_internetProtocol start];
}

- (void) sendMessage : (id<IBMessage>) message {
    NSData *data = [self encodeMessage:message];
    if (data != nil) {
        [self->_internetProtocol sendData:data];
    }
}

- (void)connectWithAccount:(Account *)account {
    
    self->_account = account;
    
    IBAMQPProtoHeader *header = [[IBAMQPProtoHeader alloc] init];
    header.protocolID = IBAMQPProtocolIdSASL;
    header.versionMajor = 1;
    header.versionMinor = 0;
    header.versionRevision = 0;
    
    [self sendMessage:header];
}

- (void) publishMessage:(Message *)message {
    
    IBAMQPTransfer *transfer = [[IBAMQPTransfer alloc] init];
    transfer.chanel = self->_chanel;
    if (message.qos == IBAtMostOnce) {
        transfer.settled = @(true);
    } else {
        transfer.settled = @(false);
    }
    transfer.more = @(false);
    transfer.messageFormat = [[IBAMQPMessageFormat alloc] initWithValue:0];
    
    IBAMQPData *data = [[IBAMQPData alloc] init];
    data.data = [NSMutableData dataWithData:message.content];
    
    [transfer addSections:@[data]];

    if ([self->_usedOutgoingMappings objectForKey:message.topicName]) {
        transfer.handle = [self->_usedOutgoingMappings objectForKey:message.topicName];
        [self->_timers startMessageTimer:transfer];
        if (transfer.settled != nil && [transfer.settled boolValue]) {
            if (transfer.deliveryId != nil) {
                [self->_timers removeTimerWithPacketID:transfer.deliveryId];
            }
        }
    } else {
        long currentHandler = self->_nextHandle++;
        [self->_usedOutgoingMappings setObject:[NSNumber numberWithLong:currentHandler] forKey:message.topicName];
        [self->_usedMappings setObject:message.topicName forKey:[NSNumber numberWithLong:currentHandler]];
        
        transfer.handle = [NSNumber numberWithLong:currentHandler];
        [self->_pendingMessages addObject:transfer];
        
        IBAMQPAttach *attach = [[IBAMQPAttach alloc] init];
        attach.chanel = self->_chanel;
        attach.name = message.topicName;
        attach.handle = [NSNumber numberWithLong:currentHandler];
        attach.role = [[IBAMQPRoleCode alloc] initWithRoleCode:IBAMQPSenderRoleCode];
        attach.sendCodes = [[IBAMQPSendCode alloc] initWithSendCode:IBAMQPMixedSendCode];
        attach.initialDeliveryCount = @(0);
        
        IBAMQPSource *source = [[IBAMQPSource alloc] init];
        source.address = message.topicName;
        source.durable = [[IBAMQPTerminusDurability alloc] initWithTerminusDurability:IBAMQPNoneTerminusDurabilities];
        source.timeout = [NSNumber numberWithLong:0];
        source.dynamic = [NSNumber numberWithBool:false];
        
        attach.source = source;
        
        [self sendMessage:attach];
    }
}

- (void) subscribeToTopic:(Topic *)topic {
    [self subscribeTo:topic.topicName];
}

- (void) unsubscribeFromTopic:(Topic *)topic {

    if ([self->_usedIncomingMappings objectForKey:topic.topicName]) {
        IBAMQPDetach *detach = [[IBAMQPDetach alloc] init];
        detach.chanel = self->_chanel;
        detach.closed = [NSNumber numberWithBool:true];
        detach.handle = [self->_usedIncomingMappings objectForKey:topic.topicName];
        [self sendMessage:detach];
    } else {
        [self.delegate unsubackForUnsubscribeWithTopicName:topic.topicName];
    }
}

- (void) pingreq {
    
    IBAMQPPing *ping = [[IBAMQPPing alloc] init];
    
    [self sendMessage:ping];
}

- (void) disconnectWithDuration : (NSInteger) duration {
    
    IBAMQPEnd *end = [[IBAMQPEnd alloc] init];
    end.chanel = self->_chanel;
    [self sendMessage:end];
    [self->_timers stopAllTimers];
}

- (id<IBMessage>) getPingreqMessage {
    return [[IBAMQPPing alloc] init];
}

- (void)connectionTimeout {
    [self.delegate timeout];
}

#pragma mark - IBInternetProtocolDelegate -

- (void) internetProtocolDidStart : (id<IBInternetProtocol>) internetProtocol {
    [self.delegate ready];
}

- (void) internetProtocolDidStop  : (id<IBInternetProtocol>) internetProtocol {
    
}

- (void) internetProtocol : (id<IBInternetProtocol>) internetProtocol didReceiveMessage : (NSData *) data {
    
    NSMutableData *buffer = [NSMutableData dataWithData:data];
    
    if (buffer.length == 0) return;
    
    do {
        NSInteger length = [IBAMQPParser next:buffer];
        
        if (length <= 0) {
            @throw [NSException exceptionWithName:@"Wrong AMQP version" reason:@"AMQP version must be 1.0.0" userInfo:nil];
        }
        
        NSData *packet = [buffer subdataWithRange:NSMakeRange(0, length)];
        NSData *sub = [buffer subdataWithRange:NSMakeRange(length, buffer.length - length)];
        buffer = [NSMutableData dataWithData:sub];
        
        IBAMQPHeader *message = [self decodeData:packet];
        
        switch ([message getMessageType]) {
            case IBAMQPProtocolHeaderCode: {
                IBAMQPProtoHeader *protoHeader = (IBAMQPProtoHeader *)message;
                if (self->_isSASLСonfirm == true && protoHeader.protocolID == IBAMQPProtocolId) {
                    self.chanel = protoHeader.chanel;
                    IBAMQPOpen *open = [[IBAMQPOpen alloc] init];
                    open.containerId = self->_account.clientID;
                    open.chanel = protoHeader.chanel;
                    open.idleTimeout = @(self->_account.keepalive * 1000);
                    [self sendMessage:open];
                }
                break;
            }
            case IBAMQPOpenHeaderCode: {
                IBAMQPOpen *open = (IBAMQPOpen *)message;
                if (open.idleTimeout == nil) {
                    self->_keepalive = self->_account.keepalive;
                } else {
                    self->_keepalive = [open.idleTimeout integerValue] / 1000;
                }
                
                IBAMQPBegin *begin = [[IBAMQPBegin alloc] init];
                begin.chanel = self->_chanel;
                begin.nextOutgoingID = @(0);
                begin.incomingWindow = @(2147483647);
                begin.outgoingWindow = @(0);
                
                [self sendMessage:begin];
                
                break;
            }
            case IBAMQPBeginHeaderCode: {
                [self.delegate connackWithCode:0];
                [self->_timers startPingTimerWithKeepAlive:self->_keepalive];
                for (NSString *key in self->_usedIncomingMappings.allKeys) {
                    [self subscribeTo:key];
                }
                break;
            }
            case IBAMQPAttachHeaderCode: {
                IBAMQPAttach *attach = (IBAMQPAttach *)message;
                
                if (attach.role.value == IBAMQPReceiverRoleCode) {
                    // publish
                    for (int i = 0; i < self->_pendingMessages.count; i++) {
                        IBAMQPTransfer *message = [self->_pendingMessages objectAtIndex:i];
                        if ([message.handle integerValue] == [attach.handle integerValue]) {
                            [self->_pendingMessages removeObject:message];
                            i--;
                            [self->_timers startMessageTimer:message];
                            if (message.settled != nil && [message.settled boolValue]) {
                                if (message.deliveryId != nil) {
                                    [self->_timers removeTimerWithPacketID:message.deliveryId];
                                }
                            }
                        }
                    }
                } else {
                    // subscribe
                    [self->_usedIncomingMappings setObject:attach.handle forKey:attach.name];
                    [self.delegate subackForSubscribeWithTopicName:attach.name qos:IBAtLeastOnce returnCode:0];
                }
                break;
            }
            case IBAMQPFlowHeaderCode: {
                // not implemented for now
                break;
            }
            case IBAMQPTransferHeaderCode: {
                IBAMQPTransfer *transfer = (IBAMQPTransfer *)message;
                IBAMQPData *data = [transfer data];
                
                IBQoS *qos = [[IBQoS alloc] initWithValue:IBAtLeastOnce];
                
                if ([transfer.settled boolValue]) {
                    qos = [[IBQoS alloc] initWithValue:IBAtMostOnce];
                } else {
                    IBAMQPDisposition *disposition = [[IBAMQPDisposition alloc] init];
                    disposition.chanel = self->_chanel;
                    disposition.role = [[IBAMQPRoleCode alloc] initWithRoleCode:IBAMQPReceiverRoleCode];
                    disposition.first = transfer.deliveryId;
                    disposition.last = transfer.deliveryId;
                    disposition.settled = @(true);
                    disposition.state = [[IBAMQPAccepted alloc] init];
                    [self sendMessage:disposition];
                }
                
                NSString *topicName = nil;
                if (![self->_usedMappings objectForKey:transfer.handle]) {
                    return;
                }
                
                topicName = [self->_usedMappings objectForKey:transfer.handle];
                [self.delegate publishWithTopicName:topicName qos:qos.value content:data.data dup:false retainFlag:false];
                
                break;
            }
            case IBAMQPDispositionHeaderCode: {
                IBAMQPDisposition *disposition = (IBAMQPDisposition *)message;
                if (disposition.first != nil) {
                    NSInteger first = [disposition.first integerValue];
                    if (disposition.last != nil) {
                        NSInteger last = [disposition.last integerValue];
                        for (NSInteger i = first; i < last; i++) {
                            IBAMQPTransfer *transfer = (IBAMQPTransfer *)[self->_timers removeTimerWithPacketID:disposition.first];
                            if (transfer != nil) {
                                NSString *topicName = [self->_usedMappings objectForKey:transfer.handle];
                                IBAMQPData *data = (IBAMQPData *)transfer.data;
                                [self.delegate pubackForPublishWithTopicName:topicName qos:IBAtLeastOnce content:data.data dup:false retainFlag:false andReturnCode:0];
                            }
                        }
                    } else {
                        IBAMQPTransfer *transfer = (IBAMQPTransfer *)[self->_timers removeTimerWithPacketID:disposition.first];
                        if (transfer != nil) {
                            NSString *topicName = [self->_usedMappings objectForKey:transfer.handle];
                            IBAMQPData *data = (IBAMQPData *)transfer.data;
                            [self.delegate pubackForPublishWithTopicName:topicName qos:IBAtLeastOnce content:data.data dup:false retainFlag:false andReturnCode:0];
                        }
                    }
                }
                break;
            }
            case IBAMQPDetachHeaderCode: {
                IBAMQPDetach *detach = (IBAMQPDetach *)message;
                
                if (detach.handle != nil && [self->_usedMappings objectForKey:detach.handle]) {
                    NSString *topicName = [self->_usedMappings objectForKey:detach.handle];
                    [self->_usedMappings removeObjectForKey:detach.handle];
                    if ([self->_usedOutgoingMappings objectForKey:topicName]) {
                        [self->_usedOutgoingMappings removeObjectForKey:topicName];
                    }
                    [self->_usedIncomingMappings removeObjectForKey:topicName];
                    [self.delegate unsubackForUnsubscribeWithTopicName:topicName];
                }
                break;
            }
            case IBAMQPEndHeaderCode: {
                IBAMQPEnd *end = (IBAMQPEnd *)message;
                
                IBAMQPClose *close = [[IBAMQPClose alloc] init];
                close.chanel = end.chanel;
                [self sendMessage:close];
                
                break;
            }
            case IBAMQPCloseHeaderCode: {
                [self->_timers stopAllTimers];
                self->_isSASLСonfirm = false;
                break;
            }
            case IBAMQPMechanismsHeaderCode: {
                IBAMQPSASLMechanisms *mechanisms = (IBAMQPSASLMechanisms *)message;

                IBAMQPSymbol *plainMechanism = nil;
                for (IBAMQPSymbol *mechanism in mechanisms.mechanisms) {
                    if ([[mechanism.value lowercaseString] isEqualToString:@"plain"]) {
                        plainMechanism = mechanism;
                        break;
                    }
                }
                
                if (plainMechanism == nil) {
                    [self->_timers stopAllTimers];
                    return;
                }
                
                IBAMQPSASLInit *saslInit = [[IBAMQPSASLInit alloc] init];
                saslInit.type = mechanisms.type;
                saslInit.chanel = mechanisms.chanel;
                saslInit.mechanism = plainMechanism;
                saslInit.hostName = self->_internetProtocol.host;
                
                NSData *userBytes = [self->_account.username dataUsingEncoding:NSUTF8StringEncoding];
                NSData *passwordBytes = [self->_account.password dataUsingEncoding:NSUTF8StringEncoding];
                NSMutableData *challenge = [NSMutableData data];
                [challenge appendData:userBytes];
                [challenge appendByte:(Byte)0x00];
                [challenge appendData:userBytes];
                [challenge appendByte:(Byte)0x00];
                [challenge appendData:passwordBytes];

                saslInit.initialResponse = challenge;
                
                [self sendMessage:saslInit];
                break;
            }
            case IBAMQPInitHeaderCode: {
                NSLog(@" > Init did recive");
                break;
            }
            case IBAMQPChallengeHeaderCode: {
                NSLog(@" > Challenge did recive");
                break;
            }
            case IBAMQPResponseHeaderCode: {
                NSLog(@" > Response did recive");
                break;
            }
            case IBAMQPOutcomeHeaderCode: {
                IBAMQPSASLOutcome *outcome = (IBAMQPSASLOutcome *)message;
                
                if (outcome.outcomeCode.value == IBAMQPOkSASLCode) {
                    self->_isSASLСonfirm = true;
                    IBAMQPProtoHeader *header = [[IBAMQPProtoHeader alloc] init];
                    header.protocolID = IBAMQPProtocolId;
                    header.versionMajor = 1;
                    header.versionMinor = 0;
                    header.versionRevision = 0;
                    [self sendMessage:header];
                } else if (outcome.outcomeCode.value == IBAMQPAuthSASLCode) {
                    @throw [NSException exceptionWithName:@"Connection authentication failed"
                                                   reason:@"Due to an unspecified problem with the supplied" userInfo:nil];
                } else if (outcome.outcomeCode.value == IBAMQPSysSASLCode) {
                    @throw [NSException exceptionWithName:@"Connection authentication failed"
                                                   reason:@"Due to a system error" userInfo:nil];
                } else if (outcome.outcomeCode.value == IBAMQPSysPermSASLCode) {
                    @throw [NSException exceptionWithName:@"Connection authentication failed"
                                                   reason:@"Due to a system error that is unlikely to be cor- rected without intervention" userInfo:nil];
                } else if (outcome.outcomeCode.value == IBAMQPSysTempSASLCode) {
                    @throw [NSException exceptionWithName:@"Connection authentication failed"
                                                   reason:@"Due to a transient system error" userInfo:nil];
                }
                break;
            }
            case IBAMQPPingHeaderCode: {
                NSLog(@" > Ping did recive");
                break;
            }
        }
    } while (buffer.length > 0);
}

- (void) internetProtocol : (id<IBInternetProtocol>) internetProtocol didFailWithError  : (NSError *) error {
    
}

#pragma mark - Private methods -

- (void) subscribeTo:(NSString *)topicName {
    long currentHandler;
    if ([self->_usedIncomingMappings objectForKey:topicName]) {
        currentHandler = [[self->_usedIncomingMappings objectForKey:topicName] longValue];
    } else {
        currentHandler = self->_nextHandle++;
        [self->_usedIncomingMappings setObject:[NSNumber numberWithLong:currentHandler] forKey:topicName];
        [self->_usedMappings setObject:topicName forKey:[NSNumber numberWithLong:currentHandler]];
    }
    
    IBAMQPAttach *attach = [[IBAMQPAttach alloc] init];
    attach.chanel = self->_chanel;
    attach.name = topicName;
    attach.handle = [NSNumber numberWithLong:currentHandler];
    attach.role = [[IBAMQPRoleCode alloc] initWithRoleCode:IBAMQPReceiverRoleCode];
    attach.sendCodes = [[IBAMQPSendCode alloc] initWithSendCode:IBAMQPMixedSendCode];
    
    IBAMQPTarget *target = [[IBAMQPTarget alloc] init];
    target.address = topicName;
    target.durable = [[IBAMQPTerminusDurability alloc] initWithTerminusDurability:IBAMQPNoneTerminusDurabilities];
    target.timeout = [NSNumber numberWithLong:0];
    target.dynamic = [NSNumber numberWithBool:false];
    
    attach.target = target;
    
    [self sendMessage:attach];
}

- (NSData *) encodeMessage : (id<IBMessage>) message {
    
    NSData *data = nil;
    
    @try {
        data = [IBAMQPParser encode:message];
    } @catch (NSException *exception) {
        NSLog(@" > Exception: in class %@, method encodeMessage:. Description: %@", [[self class] description], exception.description);
    }
    return data;
}

- (id<IBMessage>) decodeData : (NSData *) data {
    
    id<IBMessage> message = nil;
    NSMutableData *buffer = [NSMutableData dataWithData:data];
    
    @try {
        message = [IBAMQPParser decode:[NSMutableData dataWithData:buffer]];
    } @catch (NSException *exception) {
        NSLog(@" > Exception: in class %@, method decodeData:. Description: %@", [[self class] description], exception.description);
    }
    return message;
}

@end
