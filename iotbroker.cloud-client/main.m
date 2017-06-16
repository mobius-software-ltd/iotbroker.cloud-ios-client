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

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "IBCoParser.h"
#import "IBCoAP.h"

#import "IBSocketTransport.h"

#import "IBAMQPParser.h"
#import "IBAMQPProtoHeader.h"
#import "IBAMQPOpen.h"
#import "IBAMQPBegin.h"
#import "IBAMQPPing.h"
#import "IBAMQPClose.h"
#import "IBAMQPEnd.h"
#import "IBAMQPSASLChallenge.h"
#import "IBAMQPSASLMechanisms.h"
#import "IBAMQPSASLInit.h"
#import "IBAMQPSASLOutcome.h"
#import "IBAMQPSASLResponse.h"
#import "IBAMQPDetach.h"
#import "IBAMQPDisposition.h"
#import "IBAMQPModified.h"
#import "IBAMQPTransfer.h"
#import "IBAMQPReceived.h"
#import "IBAMQPAttach.h"
#import "IBAMQPFlow.h"
#import "IBAMQPBegin.h"

#import "IBAMQP.h"

@interface Test : NSObject <IBResponsesDelegate>

@end

@implementation Test
{
    IBAMQP *_amqp;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self->_amqp = [[IBAMQP alloc] initWithHost:@"23.97.209.85" port:5672 andResponseDelegate:self];
        [self->_amqp prepareToSendingRequest];
    }
    return self;
}

- (void) ready {
    
    [self->_amqp connectWithAccount:nil];
}

- (void) connackWithCode : (NSInteger) returnCode {

    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [NSThread sleepForTimeInterval:4.0];
        [self->_amqp publishMessage:nil];

    });
    
}

- (void) publishWithTopicName : (NSString *) name qos : (NSInteger) qos content : (NSData *) content dup : (BOOL) dup retainFlag : (BOOL) retainFlag {
    
}

- (void) pubackForPublishWithTopicName : (NSString *) name qos : (NSInteger) qos content : (NSData *) content dup : (BOOL) dup retainFlag : (BOOL) retainFlag andReturnCode : (NSInteger) returnCode {
    
}

- (void) pubrecForPublishWithTopicName : (NSString *) name qos : (NSInteger) qos content : (NSData *) content dup : (BOOL) dup retainFlag : (BOOL) retainFlag {
    
}

- (void) pubrelForPublishWithTopicName : (NSString *) name qos : (NSInteger) qos content : (NSData *) content dup : (BOOL) dup retainFlag : (BOOL) retainFlag {
    
}

- (void) pubcompForPublishWithTopicName : (NSString *) name qos : (NSInteger) qos content : (NSData *) content dup : (BOOL) dup retainFlag : (BOOL) retainFlag {
    
}

- (void) subackForSubscribeWithTopicName : (NSString *) name qos : (NSInteger) qos returnCode : (NSInteger) returnCode {
    
}

- (void) unsubackForUnsubscribeWithTopicName : (NSString *) name {
    
}

- (void) pingresp {
    
}

- (void) disconnectWithDuration : (NSInteger) duration {
    
}

- (void) error : (NSError *) error {

}

@end

int main(int argc, char * argv[]) {
    
    Test *test = [[Test alloc] init];
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
