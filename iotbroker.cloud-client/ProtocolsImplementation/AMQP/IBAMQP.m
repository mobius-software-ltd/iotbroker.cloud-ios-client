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
#import "IBSocketTransport.h"
#import "IBTimersMap.h"
#import "IBAMQPSimpleType.h"
#import "IBAMQPStringID.h"
#import "IBAMQPAccepted.h"
#import "IBAMQPTransferMap.h"

@interface IBAMQP () <IBInternetProtocolDelegate>

@property (strong, nonatomic) IBTimersMap *timers;
@property (assign, nonatomic) BOOL isSASLСonfirm;
@property (assign, nonatomic) BOOL isPublishAllow;
@property (assign, nonatomic) NSInteger chanel;
@property (strong, nonatomic) IBAMQPTransferMap *transferMap;

@end

@implementation IBAMQP

#pragma mark - Initializers -

- (instancetype) initWithHost : (NSString *) host port : (NSInteger) port andResponseDelegate : (id<IBResponsesDelegate>) delegate {
    self = [super init];
    if (self != nil) {
        self->_timers = [[IBTimersMap alloc] initWithRequest:self];
        self->_internetProtocol = [[IBSocketTransport alloc] initWithHost:host andPort:port];
        self->_internetProtocol.delegate = self;
        self->_delegate = delegate;
        self->_isSASLСonfirm = false;
        self->_isPublishAllow = false;
        self->_transferMap = [[IBAMQPTransferMap alloc] init];
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
        [self->_internetProtocol sendData:data];
        return true;
    }
    return false;
}

- (void)connectWithAccount:(Account *)account {
    
    IBAMQPProtoHeader *header = [[IBAMQPProtoHeader alloc] init];
    header.protocolID = IBAMQPProtocolIdSASL;
    header.versionMajor = 1;
    header.versionMinor = 0;
    header.versionRevision = 0;
    
    [self sendMessage:header];
}

- (void) publishMessage:(Message *)message {
    
    if (self->_isPublishAllow == true) {
        
        IBAMQPTransfer *transfer = [[IBAMQPTransfer alloc] init];
        transfer.chanel = self->_chanel;
        transfer.handle = @(0);
        transfer.deliveryId = @(0);
        transfer.deliveryTag = [NSMutableData dataWithData:[@"dTag" dataUsingEncoding:NSUTF8StringEncoding]];
        transfer.settled = @(false);
        transfer.more = @(false);
        transfer.messageFormat = [[IBAMQPMessageFormat alloc] initWithValue:0];
        
        IBAMQPMessageHeader *messageHeader = [[IBAMQPMessageHeader alloc] init];
        messageHeader.durable = @(true);
        messageHeader.priority = @(3);
        messageHeader.milliseconds = @(1000);
        
        IBAMQPData *data = [[IBAMQPData alloc] init];
        data.data = [NSMutableData dataWithData:message.content];
        
        [transfer addSections:@[data]];
        
        [self sendMessage:[self->_transferMap addTransfer:transfer]];
    }
}

- (void) subscribeToTopic:(Topic *)topic {
    
    IBAMQPFlow *flow = [[IBAMQPFlow alloc] init];
    flow.chanel = self->_chanel;
    flow.handle = @(1);
    flow.incomingWindow = @(65535);
    flow.outgoingWindow = @(65535);
    flow.linkCredit = @(65535);
    flow.nextOutgoingId = @(0);
    flow.nextIncomingId = @(0);
    flow.drain = @(false);
    flow.echo = @(false);
    
    [self sendMessage:flow];
    [self.delegate subackForSubscribeWithTopicName:nil qos:0 returnCode:0];
}

- (void) unsubscribeFromTopic:(Topic *)topic {
    [self.delegate unsubackForUnsubscribeWithTopicName:nil];
}

- (void) pingreq {
    
    IBAMQPPing *ping = [[IBAMQPPing alloc] init];
    
    [self sendMessage:ping];
}

- (void) disconnectWithDuration : (NSInteger) duration {
    
    IBAMQPDetach *detach = [[IBAMQPDetach alloc] init];
    detach.chanel = self->_chanel;
    detach.handle = @(1);
    detach.closed = @(true);
    
    [self sendMessage:detach];
}

- (id<IBMessage>) getPingreqMessage {
    return [[IBAMQPPing alloc] init];
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
                    open.containerId = [[NSUUID UUID] UUIDString];
                    
                    open.chanel = protoHeader.chanel;
                    open.hostname = self->_internetProtocol.host;
                    [open addProperty:@"qpid.client_process" value:@"qpid-send"];
                    [open addProperty:@"qpid.client_pid" value:[IBAMQPSimpleType simpleType:IBAMQPIntType withValue:@(31174)]];
                    [open addProperty:@"qpid.client_ppid" value:[IBAMQPSimpleType simpleType:IBAMQPIntType withValue:@(30152)]];
                    
                    [self sendMessage:open];
                }
                break;
            }
            case IBAMQPOpenHeaderCode: {
                IBAMQPOpen *open = (IBAMQPOpen *)message;
                NSInteger idleTimeoutInSeconds = [open.idleTimeout integerValue] / 1000;
                [self->_timers startPingTimerWithKeepAlive:idleTimeoutInSeconds];
                
                IBAMQPBegin *begin = [[IBAMQPBegin alloc] init];
                begin.chanel = self->_chanel;
                begin.nextOutgoingID = @(0);
                begin.incomingWindow = @(2147483647);
                begin.outgoingWindow = @(0);
                
                [self sendMessage:begin];
                
                break;
            }
            case IBAMQPBeginHeaderCode: {                
                IBAMQPAttach *attach = [[IBAMQPAttach alloc] init];
                
                attach.chanel = self->_chanel;
                attach.name = [[NSUUID UUID] UUIDString];
                attach.handle = @(0);
                attach.role = [IBAMQPRoleCode enumWithRoleCode:IBAMQPSenderRoleCode];
                attach.sendCodes = [IBAMQPSendCode enumWithSendCode:IBAMQPMixedSendCode];
                attach.source = [[IBAMQPSource alloc] init];
                attach.source.address = @"my_queue";
                attach.source.durable = [IBAMQPTerminusDurability enumWithTerminusDurability:IBAMQPNoneTerminusDurabilities];
                attach.source.timeout = @(0);
                attach.source.dynamic = @(false);
                attach.target = [[IBAMQPTarget alloc] init];
                attach.target.address = @"my_queue";
                attach.target.durable = [IBAMQPTerminusDurability enumWithTerminusDurability:IBAMQPNoneTerminusDurabilities];
                attach.target.timeout = @(0);
                attach.target.dynamic = @(false);
                [attach.target addCapabilities:@[@"create-on-demand", @"queue", @"durable"]];
                attach.initialDeliveryCount = @(1);
                
                [self sendMessage:attach];
                
                break;
            }
            case IBAMQPAttachHeaderCode: {
                IBAMQPAttach *attach = (IBAMQPAttach *)message;
                
                if (attach.role.value == IBAMQPSenderRoleCode) {
                    
                    [self.delegate connackWithCode:0];
                } else {
                    IBAMQPAttach *attach = [[IBAMQPAttach alloc] init];
                    
                    attach.chanel = self->_chanel;
                    attach.name = [[NSUUID UUID] UUIDString];
                    attach.handle = @(1);
                    attach.role = [IBAMQPRoleCode enumWithRoleCode:IBAMQPReceiverRoleCode];
                    attach.sendCodes = [IBAMQPSendCode enumWithSendCode:IBAMQPMixedSendCode];
                    attach.source = [[IBAMQPSource alloc] init];
                    attach.source.address = @"my_queue";
                    attach.source.durable = [IBAMQPTerminusDurability enumWithTerminusDurability:IBAMQPNoneTerminusDurabilities];
                    attach.source.timeout = @(0);
                    attach.source.dynamic = @(false);
                    attach.target = [[IBAMQPTarget alloc] init];
                    attach.target.address = @"my_queue";
                    attach.target.durable = [IBAMQPTerminusDurability enumWithTerminusDurability:IBAMQPNoneTerminusDurabilities];
                    attach.target.timeout = @(0);
                    attach.target.dynamic = @(false);
                    [attach.target addCapabilities:@[@"create-on-demand", @"queue", @"durable"]];
                    attach.initialDeliveryCount = @(1);
                    
                    [self sendMessage:attach];
                }
                break;
            }
            case IBAMQPFlowHeaderCode: {
                IBAMQPFlow *flow = (IBAMQPFlow *)message;
                if (self->_chanel == flow.chanel) {
                    self->_isPublishAllow = true;
                }
                break;
            }
            case IBAMQPTransferHeaderCode: {
                IBAMQPTransfer *transfer = (IBAMQPTransfer *)message;
                IBAMQPData *data = [transfer data];
                
                if ([transfer.settled boolValue] == true) {
                    [self.delegate publishWithTopicName:nil qos:0 content:data.data dup:false retainFlag:false];
                    
                } else {
                    IBAMQPDisposition *disposition = [[IBAMQPDisposition alloc] init];
                    disposition.chanel = self->_chanel;
                    disposition.role = [IBAMQPRoleCode enumWithRoleCode:IBAMQPReceiverRoleCode];
                    disposition.first = transfer.deliveryId;
                    disposition.last = transfer.deliveryId;
                    disposition.settled = @(true);
                    disposition.state = [[IBAMQPAccepted alloc] init];
                    [self sendMessage:disposition];
                    
                    [self.delegate publishWithTopicName:nil qos:1 content:data.data dup:false retainFlag:false];
                }
                break;
            }
            case IBAMQPDispositionHeaderCode: {
                IBAMQPDisposition *disposition = (IBAMQPDisposition *)message;
                
                int first = [disposition.first intValue];
                int second = [disposition.last intValue];
                
                for (int i = first; i <= second; i++) {
                    id msg = [self->_transferMap removeTransferByDeliveryId:i];
                    if ([msg isKindOfClass:[IBAMQPTransfer class]]) {
                        IBAMQPTransfer *transfer = (IBAMQPTransfer *)msg;
                        IBAMQPData *data = [transfer data];
                        [self.delegate pubackForPublishWithTopicName:nil qos:1 content:data.data dup:false retainFlag:false andReturnCode:0];
                    }
                }
                break;
            }
            case IBAMQPDetachHeaderCode: {
                IBAMQPDetach *detach = (IBAMQPDetach *)message;
                
                IBAMQPEnd *end = [[IBAMQPEnd alloc] init];
                end.chanel = detach.chanel;
                
                [self sendMessage:end];
                
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
                [self->_timers stopPingTimer];
                self->_isSASLСonfirm = false;
                break;
            }
            case IBAMQPMechanismsHeaderCode: {
                IBAMQPSASLMechanisms *mechanisms = (IBAMQPSASLMechanisms *)message;
                
                IBAMQPSASLInit *saslInit = [[IBAMQPSASLInit alloc] init];
                saslInit.type = mechanisms.type;
                saslInit.chanel = mechanisms.chanel;
                saslInit.hostName = self->_internetProtocol.host;
                saslInit.initialResponse = [NSMutableData dataWithData:[@"username" dataUsingEncoding:NSUTF8StringEncoding]];
                saslInit.mechanism = [mechanisms.mechanisms firstObject];
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
