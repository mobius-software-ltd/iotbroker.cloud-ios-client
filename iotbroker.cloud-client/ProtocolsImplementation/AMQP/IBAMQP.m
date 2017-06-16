//
//  IBAMQP.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 14.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQP.h"
#import "IBAMQPParser.h"
#import "IBSocketTransport.h"
#import "IBTimersMap.h"
#import "IBAMQPSimpleType.h"

@interface IBAMQP () <IBInternetProtocolDelegate>

@property (strong, nonatomic) IBTimersMap *timers;
@property (assign, nonatomic) BOOL isSASLСonfirm;
@property (assign, nonatomic) NSInteger chanel;

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
    
}

- (void) subscribeToTopic:(Topic *)topic {
    
}

- (void) unsubscribeFromTopic:(Topic *)topic {

}

- (void) pingreq {

}

- (void) disconnectWithDuration : (NSInteger) duration {

    IBAMQPDetach *detach = [[IBAMQPDetach alloc] init];
    detach.chanel = self->_chanel;
    detach.handle = @(0);
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
                begin.nextOutgoingID = @(0);
                begin.incomingWindow = @(2147483647);
                begin.outgoingWindow = @(0);

                [self sendMessage:begin];
                
                break;
            }
            case IBAMQPBeginHeaderCode: {
                IBAMQPBegin *begin = (IBAMQPBegin *)begin;
                
                IBAMQPAttach *attach = [[IBAMQPAttach alloc] init];
                
                attach.name = [[NSUUID UUID] UUIDString];
                attach.handle = @(0);
                attach.role = [IBAMQPRoleCode enumWithRoleCode:IBAMQPSenderRoleCode];
                attach.sendCodes = [IBAMQPSendCode enumWithSendCode:IBAMQPMixedSendCode];
                attach.source = [[IBAMQPSource alloc] init];
                attach.source.address = @"testQueue";
                attach.source.durable = IBAMQPNoneTerminusDurabilities;
                attach.source.timeout = @(0);
                attach.source.dynamic = @(false);
                attach.target = [[IBAMQPTarget alloc] init];
                attach.target.address = @"testQueue";
                attach.target.timeout = @(0);
                attach.target.dynamic = @(false);
                //[attach.target addDynamicNodeProperties:@"supported-dist-modes" value:@"move"];
                //[attach.target addDynamicNodeProperties:@"durable" value:[IBAMQPSimpleType simpleType:IBAMQPBooleanType withValue:@(true)]];
                [attach.target addCapabilities:@[@"create-on-demand", @"queue", @"durable"]];
                attach.initialDeliveryCount = @(0);
                
                [self sendMessage:attach];
                
                break;
            }
            case IBAMQPAttachHeaderCode: {
                
                [self.delegate connackWithCode:0];
                
                break;
            }
            case IBAMQPFlowHeaderCode: {
                break;
            }
            case IBAMQPTransferHeaderCode: {
                break;
            }
            case IBAMQPDispositionHeaderCode: {
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
                break;
            }
            case IBAMQPChallengeHeaderCode: {
                break;
            }
            case IBAMQPResponseHeaderCode: {
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
