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

void test(id<IBSNMessage> message) {

    NSLog(@" ------------------ %zd ------------------ ", [message getMessageType]);
    NSData *data = [IBSNParser encode:message];
    message = [IBSNParser decode:[NSMutableData dataWithData:data]];
    
    NSLog(@"%@", message);
    NSLog(@" --------------------------------------- ");

}
/*
 
 IBAdvertiseMessage      = 0,
 IBSearchGWMessage       = 1,
 IBGWInfoMessage         = 2,
 IBConnectMessage        = 4,
 IBConnackMessage        = 5,
 IBWillTopicReqMessage   = 6,
 IBWillTopicMessage      = 7,
 IBWillMsgReqMessage     = 8,
 IBWillMsgMessage        = 9,
 IBRegisterMessage       = 10,
 IBRegackMessage         = 11,
 IBPublishMessage        = 12,
 IBPubackMessage         = 13,
 IBPubcompMessage        = 14,
 IBPubrecMessage         = 15,
 IBPubrelMessage         = 16,
 IBSubscribeMessage      = 18,
 IBSubackMessage         = 19,
 IBUnsubscribeMessage    = 20,
 IBUnsubackMessage       = 21,
 IBPingreqMessage        = 22,
 IBPingrespMessage       = 23,
 IBDisconnectMessage     = 24,
 IBWillTopicUpdMessage   = 26,
 IBWillTopicRespMessage  = 27,
 
 IBWillMsgUpdMessage     = 28,
 IBWillMsgRespMessage    = 29,
 IBEncapsulatedMessage   = 254,
 
 */
int main(int argc, char * argv[]) {
    
    
    id<IBSNMessage> message = nil;
    
    NSData *content = [@"hello content" dataUsingEncoding:NSUTF8StringEncoding];
    IBSNFullTopic *topic = [[IBSNFullTopic alloc] initWithValue:@"hello topic" andQoS:[[IBSNQoS alloc] initWithValue:2]];
    IBSNQoS *qos = [[IBSNQoS alloc] initWithValue:3];
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
    message = [[IBSNRegister alloc] initWithTopicID:43 messageID:23 andTopicName:@"topic name"];                        test(message);
    message = [[IBSNRegack alloc] initWithTopicID:6 messageID:3 returnCode:IBCongestionReturnCode];                     test(message);
    message = [[IBSNPublish alloc] initWithMessageID:65 topic:idTopic content:content dup:false retainFlag:false];      test(message);
    message = [[IBSNPuback alloc] initWithTopicID:23 messageID:9 andReturnCode:IBInvalidTopicIDReturnCode];             test(message);
    message = [[IBSNPubcomp alloc] initWithMessageID:65];                                                               test(message);
    message = [[IBSNPubrec alloc] initWithMessageID:43];                                                                test(message);
    message = [[IBSNPubrel alloc] initWithMessageID:20];                                                                test(message);
    message = [[IBSNSubscribe alloc] initWithMessageID:3 topic:topic dup:false];                                        test(message);
    message = [[IBSNSuback alloc] initWithTopicID:75 messageID:25 returnCode:IBInvalidTopicIDReturnCode lowedQos:qos];  test(message);
    message = [[IBSNUnsubscribe alloc] initWithMessageID:54 topic:topic];                                               test(message);
    message = [[IBSNUnsuback alloc] initWithMessageID:4];                                                               test(message);
    message = [[IBSNPingreq alloc] initWithClientID:@"username"];                                                       test(message);
    message = [[IBSNPingresp alloc] init];                                                                              test(message);
    message = [[IBSNDisconnect alloc] initWithDuration:45];                                                             test(message);
    message = [[IBSNWillTopicUpd alloc] initWithTopic:topic andRetainFlag:true];                                        test(message);
    message = [[IBSNWillTopicResp alloc] initWithReturnCode:IBCongestionReturnCode];                                    test(message);
    message = [[IBSNWillMsgUpd alloc] initWithContent:content];                                                         test(message);
    message = [[IBSNWillMsgResp alloc] initWithReturnCode:IBCongestionReturnCode];                                      test(message);
    message = [[IBSNEncapsulated alloc] initWithRadius:IBRadius1 wirelessNodeID:@"someNodeID" andMessage:[[IBSNPingreq alloc] initWithClientID:@"username111"]];          test(message);

    @autoreleasepool {
        return 0;//UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
