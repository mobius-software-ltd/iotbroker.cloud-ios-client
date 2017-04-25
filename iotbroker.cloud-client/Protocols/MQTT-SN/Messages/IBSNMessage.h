//
//  IBSNMessage.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, IBSNMessages)
{
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
};

typedef NS_ENUM (NSInteger, IBSNRadius)
{
    IBBroadcastRadius   = 0,
    IBRadius1           = 1,
    IBRadius2           = 2,
    IBRadius3           = 3,
};

typedef NS_ENUM(NSInteger, IBSNReturnCode)
{
    IBAcceptedReturnCode        = 0,
    IBCongestionReturnCode      = 1,
    IBInvalidTopicIDReturnCode  = 2,
    IBNotSupportedReturnCode    = 3,
};

@protocol IBSNMessage <NSObject>

- (NSInteger) getLength;
- (IBSNMessages) getMessageType;

@end
