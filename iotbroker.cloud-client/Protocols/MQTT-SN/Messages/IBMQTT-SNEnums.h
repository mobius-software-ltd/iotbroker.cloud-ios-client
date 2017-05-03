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

#ifndef IBMQTT_SNEnums_h
#define IBMQTT_SNEnums_h

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

#endif /* IBMQTT_SNEnums_h */
