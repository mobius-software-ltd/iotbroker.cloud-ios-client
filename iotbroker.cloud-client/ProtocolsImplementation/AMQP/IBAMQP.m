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

@interface IBAMQP () <IBInternetProtocolDelegate>

@property (strong, nonatomic) IBTimersMap *timers;

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
    header.protocolID = IBAMQPProtocolHeaderSASL;
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

        switch (message.code.value) {
            case IBAMQPOpenHeaderCode:
                break;
            case IBAMQPBeginHeaderCode:
                break;
            case IBAMQPAttachHeaderCode:
                break;
            case IBAMQPFlowHeaderCode:
                break;
            case IBAMQPTransferHeaderCode:
                break;
            case IBAMQPDispositionHeaderCode:
                break;
            case IBAMQPDetachHeaderCode:
                break;
            case IBAMQPEndHeaderCode:
                break;
            case IBAMQPCloseHeaderCode:
                break;
            case IBAMQPMechanismsHeaderCode:
                break;
            case IBAMQPInitHeaderCode:
                break;
            case IBAMQPChallengeHeaderCode:
                break;
            case IBAMQPResponseHeaderCode:
                break;
            case IBAMQPOutcomeHeaderCode:
                break;
            case IBAMQPPingHeaderCode:
                break;
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
