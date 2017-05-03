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
#import "IBSNParser.h"

#import "IBSNAdvertise.h"
#import "IBSNSearchGW.h"
#import "IBSNGWInfo.h"
#import "IBSNConnect.h"
#import "IBSNConnack.h"
#import "IBSNWillTopicReq.h"
#import "IBSNWillTopic.h"
#import "IBSNWillMsgReq.h"
#import "IBSNWillMsg.h"
#import "IBSNRegister.h"
#import "IBSNRegack.h"
#import "IBSNPublish.h"
#import "IBSNPuback.h"
#import "IBSNPubrec.h"
#import "IBSNPubrel.h"
#import "IBSNPubcomp.h"
#import "IBSNSubscribe.h"
#import "IBSNSuback.h"
#import "IBSNUnsubscribe.h"
#import "IBSNUnsuback.h"
#import "IBSNPingreq.h"
#import "IBSNPingresp.h"
#import "IBSNDisconnect.h"
#import "IBSNWillTopicUpd.h"
#import "IBSNWillMsgUpd.h"
#import "IBSNWillTopicResp.h"
#import "IBSNWillMsgResp.h"
#import "IBSNEncapsulated.h"
#import "IBSNValuesValidator.h"
#import "IBSNFlags.h"
#import "IBSNShortTopic.h"
#import "IBSNIdentifierTopic.h"
#import "IBSNControls.h"

#import "IBMQTTSN.h"
#import "IBUDPSocket.h"
#import "IBSocketTransport.h"
#import "IBMQTT.h"

void test(id<IBMessage> message) {

    NSLog(@" ------------------ %zd ------------------ ", [message getMessageType]);
    NSData *data = [IBSNParser encode:message];
    message = [IBSNParser decode:[NSMutableData dataWithData:data]];
    
    NSLog(@"%@", message);
    NSLog(@" --------------------------------------- ");

}
/*
@interface IBTestClass : NSObject <IBResponsesDelegate>

@end

@implementation IBTestClass
{
    id<IBRequests> _requests;
}

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self->_requests = [[IBMQTT alloc] initWithHost:@"198.41.30.241" port:1883 andResponseDelegate:self];
        [self->_requests prepareToSendingRequest];
    }
    return self;
}

- (void) ready {
    IBWill *will = [[IBWill alloc] initWithTopic:[[IBMQTTTopic alloc] initWithName:@"topic" andQoS:[[IBQoS alloc] initWithValue:2]] content:[@"HELLO" dataUsingEncoding:NSUTF8StringEncoding] andIsRetain:true];

    [self->_requests connectWithUsername:@"hello" password:@"123" clientID:@"client" keepalive:7 cleanSession:true andWill:will];
}

- (void)connackWithCode:(NSInteger)returnCode {
    NSLog(@"CODE = %zd", returnCode);
}

@end
*/
int main(int argc, char * argv[]) {
    
    //IBTestClass *test = [[IBTestClass alloc] init];
    
    /*
    IBPuback *puback = [[IBPuback alloc] initWithPacketID:2];
    IBConnack *connack = [[IBConnack alloc] init];
    IBConnect *connect = [IBConnect connectWithUsername:@"user" password:@"pass" clientID:@"client" keepalive:10 cleanSession:true andWill:[[IBWill alloc] initWithTopic:[[IBMQTTTopic alloc] initWithName:@"hello" andQoS:[[IBQoS alloc] initWithValue:2]] content:[@"DATA" dataUsingEncoding:NSUTF8StringEncoding] andIsRetain:true]];
    
    NSMutableData *packets = [NSMutableData data];
    [packets appendData:[IBParser encode:puback]];    [packets appendData:[IBParser encode:connack]];
    [packets appendData:[IBParser encode:connect]];
    
    do {
        NSMutableData *data = [IBParser next:&packets];
        id<IBMessage> message = [IBParser decode:data];
        NSLog(@"%li, %li, %li", [message getMessageType], data.length, packets.length);
        
    } while (packets.length > 0);
    */
    
    
    

    /*
    id<IBMessage> message = nil;
    
    NSData *content = [@"hello content" dataUsingEncoding:NSUTF8StringEncoding];
    IBSNFullTopic *topic = [[IBSNFullTopic alloc] initWithValue:@"hello topic" andQoS:[[IBQoS alloc] initWithValue:2]];
    IBQoS *qos = [[IBQoS alloc] initWithValue:3];
    IBSNIdentifierTopic *idTopic = [[IBSNIdentifierTopic alloc] initWithValue:234 andQoS:qos];
    
    message = [[IBSNAdvertise alloc] initWithGatewayID:23 andDuration:34];                                              test(message);
    message = [[IBSNSearchGW alloc] initWithRadius:IBBroadcastRadius];                                                  test(message);
    message = [[IBSNGWInfo alloc] initWithGatewayID:6 andGatewayAddress:@"8.8.8.8"];                                    test(message);
    message = [[IBSNConnect alloc] initWithWillPresent:true cleanSession:false duration:54 clientID:@"username"];       test(message);
    message = [[IBSNConnack alloc] initWithReturnCode:IBNotSupportedReturnCode];                                        test(message);
    message = [[IBSNWillTopicReq alloc] init];                                                                          test(message);
    message = [[IBSNWillTopic alloc] initWithTopic:topic andRetainFlag:true];                                           test(message);
    message = [[IBSNWillMsgReq alloc] init];                                                                            test(message);
    message = [[IBSNWillMsg alloc] initWithContent:[@"hello content" dataUsingEncoding:NSUTF8StringEncoding]];          test(message);
    message = [[IBSNRegister alloc] initWithTopicID:43 packetID:23 andTopicName:@"topic name"];                        test(message);
    message = [[IBSNRegack alloc] initWithTopicID:6 packetID:3 returnCode:IBCongestionReturnCode];                     test(message);
    message = [[IBSNPublish alloc] initWithPacketID:65 topic:idTopic content:content dup:false retainFlag:false];      test(message);
    message = [[IBSNPuback alloc] initWithTopicID:23 packetID:9 andReturnCode:IBInvalidTopicIDReturnCode];             test(message);
    message = [[IBSNPubcomp alloc] initWithPacketID:65];                                                               test(message);
    message = [[IBSNPubrec alloc] initWithPacketID:43];                                                                test(message);
    message = [[IBSNPubrel alloc] initWithPacketID:20];                                                                test(message);
    message = [[IBSNSubscribe alloc] initWithPacketID:3 topic:topic dup:false];                                        test(message);
    message = [[IBSNSuback alloc] initWithTopicID:75 packetID:25 returnCode:IBInvalidTopicIDReturnCode lowedQos:qos];  test(message);
    message = [[IBSNUnsubscribe alloc] initWithPacketID:54 topic:topic];                                               test(message);
    message = [[IBSNUnsuback alloc] initWithPacketID:4];                                                               test(message);
    message = [[IBSNPingreq alloc] initWithClientID:@"username"];                                                       test(message);
    message = [[IBSNPingresp alloc] init];                                                                              test(message);
    message = [[IBSNDisconnect alloc] initWithDuration:45];                                                             test(message);
    message = [[IBSNWillTopicUpd alloc] initWithTopic:topic andRetainFlag:true];                                        test(message);
    message = [[IBSNWillTopicResp alloc] initWithReturnCode:IBCongestionReturnCode];                                    test(message);
    message = [[IBSNWillMsgUpd alloc] initWithContent:content];                                                         test(message);
    message = [[IBSNWillMsgResp alloc] initWithReturnCode:IBCongestionReturnCode];                                      test(message);
    //message = [[IBSNEncapsulated alloc] initWithRadius:IBRadius1 wirelessNodeID:@"someNodeID" andMessage:[[IBSNPingreq alloc] initWithClientID:@"username111"]];          test(message);
*/
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
