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

#import "IBSNParser.h"
#import "IBSNValuesValidator.h"
#import "IBSNFlags.h"
#import "IBSNShortTopic.h"
#import "IBSNIdentifierTopic.h"
#import "IBSNControls.h"

static NSStringEncoding const IBStringEncoding = NSUTF8StringEncoding;
static Byte const IBThreeOctetLengthSuffix = 0x01;

@implementation IBSNParser

#pragma mark - ENCODE IBSNMESSAGE TO DATA -

+ (NSMutableData *) encode : (id<IBMessage>) message {
    
    NSMutableData *data = [NSMutableData data];
    
    NSInteger length = [message getLength];
    
    if (length <= 255) {
        [data appendByte:length];
    } else {
        [data appendByte:IBThreeOctetLengthSuffix];
        [data appendShort:length];
    }
    
    IBSNMessages type = [message getMessageType];
    [data appendByte:type];
    
    switch (type) {
        case IBAdvertiseMessage:
        {
            IBSNAdvertise *advertise = (IBSNAdvertise *)message;
            [data appendByte:advertise.gwID];
            [data appendShort:advertise.duration];
        } break;
        case IBSearchGWMessage:
        {
            IBSNSearchGW *searchGw = (IBSNSearchGW *)message;
            [data appendByte:searchGw.radius];
        } break;
        case IBGWInfoMessage:
        {
            IBSNGWInfo *gwInfo = (IBSNGWInfo *)message;
            [data appendByte:gwInfo.gwID];
            if (gwInfo.gwAddress != nil) {
                [data appendData:[gwInfo.gwAddress dataUsingEncoding:IBStringEncoding]];
            }
        } break;
        case IBConnectMessage:
        {
            IBSNConnect *connect = (IBSNConnect *)message;
            Byte connectFlagsByte = [IBSNFlags encodeWithDup:false qos:nil retainFlag:false will:connect.isWillPresent cleanSession:connect.isCleanSession topicType:nil];
            [data appendByte:connectFlagsByte];
            [data appendByte:connect.protocolID];
            [data appendShort:connect.duration];
            [data appendData:[connect.clientID dataUsingEncoding:IBStringEncoding]];
        } break;
        case IBConnackMessage:
        case IBWillTopicRespMessage:
        case IBWillMsgRespMessage:
        {
            IBSNResponseMessage *responseMessage = (IBSNResponseMessage *)message;
            [data appendByte:responseMessage.returnCode];
        } break;
        case IBWillTopicMessage:
        {
            IBSNWillTopic *willTopic = (IBSNWillTopic *)message;
            if (willTopic.topic != nil) {
                Byte willTopicFlagsByte = [IBSNFlags encodeWithDup:false qos:willTopic.topic.qos retainFlag:willTopic.isRetainFlag will:false cleanSession:false topicType:willTopic.topic.getType];
                [data appendByte:willTopicFlagsByte];
                [data appendData:[willTopic.topic.value dataUsingEncoding:IBStringEncoding]];
            }
        } break;
        case IBWillMsgMessage:
        {
            IBSNWillMsg *willMsg = (IBSNWillMsg *)message;
            [data appendData:willMsg.content];
        } break;
        case IBRegisterMessage:
        {
            IBSNRegister *registerSN = (IBSNRegister *)message;
            [data appendShort:registerSN.topicID];
            [data appendShort:registerSN.packetID];
            [data appendData:[registerSN.topicName dataUsingEncoding:IBStringEncoding]];
        } break;
        case IBRegackMessage:
        {
            IBSNRegack *regack = (IBSNRegack *)message;
            [data appendShort:regack.topicID];
            [data appendShort:regack.packetID];
            [data appendByte:regack.returnCode];
        } break;
        case IBPublishMessage:
        {
            IBSNPublish *publish = (IBSNPublish *)message;
            Byte publishFlagsByte = [IBSNFlags encodeWithDup:publish.isDup qos:[publish.topic getQoS] retainFlag:publish.isRetainFlag will:false cleanSession:false topicType:[publish.topic getType]];
            [data appendByte:publishFlagsByte];
            [data appendData:[publish.topic encode]];
            [data appendShort:publish.packetID];
            [data appendData:publish.content];
        } break;
        case IBPubackMessage:
        {
            IBSNPuback *puback = (IBSNPuback *)message;
            [data appendShort:puback.topicID];
            [data appendShort:puback.packetID];
            [data appendByte:puback.returnCode];
        } break;
        case IBPubrecMessage:
        case IBPubrelMessage:
        case IBPubcompMessage:
        case IBUnsubackMessage:
        {
            IBCountableMessage *contableMessage = (IBCountableMessage *)message;
            [data appendShort:contableMessage.packetID];
        } break;
        case IBSubscribeMessage:
        {
            IBSNSubscribe *subscribe = (IBSNSubscribe *)message;
            Byte subscribeFlags = [IBSNFlags encodeWithDup:subscribe.isDup qos:[subscribe.topic getQoS] retainFlag:false will:false cleanSession:false topicType:[subscribe.topic getType]];
            [data appendByte:subscribeFlags];
            [data appendShort:subscribe.packetID];
            [data appendData:[subscribe.topic encode]];
        } break;
        case IBSubackMessage:
        {
            IBSNSuback *suback = (IBSNSuback *)message;
            Byte subackByte = [IBSNFlags encodeWithDup:false qos:suback.allowedQos retainFlag:false will:false cleanSession:false topicType:nil];
            [data appendByte:subackByte];
            [data appendShort:suback.topicID];
            [data appendShort:suback.packetID];
            [data appendByte:suback.returnCode];
        } break;
        case IBUnsubscribeMessage:
        {
            IBSNUnsubscribe *unsubscribe = (IBSNUnsubscribe *)message;
            Byte unsubscribeFlags = [IBSNFlags encodeWithDup:false qos:nil retainFlag:false will:false cleanSession:false topicType:[unsubscribe.topic getType]];
            [data appendByte:unsubscribeFlags];
            [data appendShort:unsubscribe.packetID];
            [data appendData:[unsubscribe.topic encode]];
        } break;
        case IBPingreqMessage:
        {
            if (length > 2) {
                IBSNPingreq *pingreq = (IBSNPingreq *)message;
                [data appendData:[pingreq.clientID dataUsingEncoding:IBStringEncoding]];
            }
        } break;
        case IBDisconnectMessage:
        {
            if (length > 2) {
                IBSNDisconnect *disconnect = (IBSNDisconnect *)message;
                [data appendShort:disconnect.duration];
            }
        } break;
        case IBWillTopicUpdMessage:
        {
            IBSNWillTopicUpd *willTopicUpd = (IBSNWillTopicUpd *)message;
            if (willTopicUpd.topic != nil) {
                Byte willTopicUpdByte = [IBSNFlags encodeWithDup:false qos:willTopicUpd.topic.qos retainFlag:willTopicUpd.isRetainFlag will:false cleanSession:false topicType:nil];
                [data appendByte:willTopicUpdByte];
                [data appendData:[willTopicUpd.topic.value dataUsingEncoding:IBStringEncoding]];
            }
        } break;
        case IBWillMsgUpdMessage:
        {
            IBSNWillMsgUpd *willMsgUpd = (IBSNWillMsgUpd *)message;
            [data appendData:willMsgUpd.content];
        } break;
        case IBWillTopicReqMessage:
        case IBWillMsgReqMessage:
        case IBPingrespMessage:
            break;
        case IBEncapsulatedMessage:
        {
            IBSNEncapsulated *encapsulated = (IBSNEncapsulated *)message;
            [data appendByte:[IBSNControls encode:encapsulated.radius]];
            [data appendData:[encapsulated.wirelessNodeID dataUsingEncoding:IBStringEncoding]];
            [data appendData:[IBSNParser encode:encapsulated.message]];
        } break;
    }
        
    if (type != IBEncapsulatedMessage && [message getLength] != data.length) {
        @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"invalid message encoding: expected length = %zd actual = %zd", [message getLength], [data length]] userInfo:nil];
    }
    
    [data clearNumber];
    return data;
}

#pragma mark - DECODE DATA TO IBSNMESSAGE -

+ (id<IBMessage>) decode : (NSMutableData *) data {

    [data clearNumber];
    
    id<IBMessage> message = nil;

    NSInteger messageLength = [IBSNParser decodeContentLength:data];
    NSInteger bytesLeft = messageLength - [data getByteNumber];
    
    short typeByte = [data readByte];
    IBSNMessages type = (IBSNMessages)typeByte;

    switch (type) {
        case IBAdvertiseMessage:
        {
            NSInteger advertiseGwID = [data readByte];
            NSInteger advertiseDuration = [data readShort];
            message = [[IBSNAdvertise alloc] initWithGatewayID:advertiseGwID andDuration:advertiseDuration];
        } break;
        case IBSearchGWMessage:
        {
            NSInteger radius = [data readByte];
            message = [[IBSNSearchGW alloc] initWithRadius:radius];
        } break;
        case IBGWInfoMessage:
        {
            NSInteger gwInfoGWID = [data readByte];
            bytesLeft--;
            
            NSString *gwInfoGwAddress = nil;
            if (bytesLeft > 0) {
                gwInfoGwAddress = [data readStringWithLength:bytesLeft];
            }
            message = [[IBSNGWInfo alloc] initWithGatewayID:gwInfoGWID andGatewayAddress:gwInfoGwAddress];
        } break;
        case IBConnectMessage:
        {
            IBSNFlags *connectFlags = [IBSNFlags decodeWithData:[data readByte] andMessageType:type];
            bytesLeft--;
            NSInteger protocolID = [data readByte];
            bytesLeft--;

            if (protocolID != IBMQTTSNProtocolID) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"Invalid protocolID %zd", protocolID] userInfo:nil];
            }
            NSInteger connectDuration = [data readShort];
            bytesLeft -= 2;
            if (![IBSNValuesValidator canReadData:data withBytesLeft:bytesLeft]) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd clientID can't be empty", type] userInfo:nil];

            }
            NSString *connectClientID = [data readStringWithLength:bytesLeft];
            message = [[IBSNConnect alloc] initWithWillPresent:connectFlags.isWill cleanSession:connectFlags.isCleanSession duration:connectDuration clientID:connectClientID];
        } break;
        case IBConnackMessage:
        {
            IBSNReturnCode connackCode = [data readByte];
            message = [[IBSNConnack alloc] initWithReturnCode:connackCode];
        } break;
        case IBWillTopicReqMessage:
        {
            message = [[IBSNWillTopicReq alloc] init];
        } break;
        case IBWillTopicMessage:
        {
            BOOL willTopicRetain = false;
            IBSNFullTopic *willTopic = nil;
            if (bytesLeft > 0) {
                IBSNFlags *willTopicFlags = [IBSNFlags decodeWithData:[data readByte] andMessageType:type];
                bytesLeft--;
                willTopicRetain = willTopicFlags.isRetainFlag;
                if (![IBSNValuesValidator canReadData:data withBytesLeft:bytesLeft]) {
                    @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid topic encoding", type] userInfo:nil];
                }
                NSString *willTopicValue = [data readStringWithLength:bytesLeft];
                willTopic = [[IBSNFullTopic alloc] initWithValue:willTopicValue andQoS:willTopicFlags.qos];
            }
            message = [[IBSNWillTopic alloc] initWithTopic:willTopic andRetainFlag:willTopicRetain];
        } break;
        case IBWillMsgReqMessage:
        {
            message = [[IBSNWillMsgReq alloc] init];
        } break;
        case IBWillMsgMessage:
        {
            if (![IBSNValuesValidator canReadData:data withBytesLeft:bytesLeft]) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd content must not be empty", type] userInfo:nil];
            }
            NSString *willMessageContentString = [data readStringWithLength:bytesLeft];
            NSData *willMessageContent = [willMessageContentString dataUsingEncoding:IBStringEncoding];
            
            message = [[IBSNWillMsg alloc] initWithContent:willMessageContent];
        } break;
        case IBRegisterMessage:
        {
            NSInteger registerTopicID = [data readShort];
            if (![IBSNValuesValidator validateRegistrationTopicID:registerTopicID]) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid topicID value %zd", type, registerTopicID] userInfo:nil];
            }
            bytesLeft -= 2;
            NSInteger registerPacketID = [data readShort];
            if (![IBSNValuesValidator validateRegistrationTopicID:registerPacketID]) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid packetID %zd", type, registerPacketID] userInfo:nil];
            }
            bytesLeft -= 2;
            if (![IBSNValuesValidator canReadData:data withBytesLeft:bytesLeft]) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd must contain a valid topic", type] userInfo:nil];
            }
            NSString *registerTopicName = [data readStringWithLength:bytesLeft];
            message = [[IBSNRegister alloc] initWithTopicID:registerTopicID packetID:registerPacketID andTopicName:registerTopicName];
        } break;
        case IBRegackMessage:
        {
            NSInteger regackTopicID = [data readShort];
            if (![IBSNValuesValidator validateRegistrationTopicID:regackTopicID]) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid topicID value %zd", type, regackTopicID] userInfo:nil];
            }
            NSInteger regackPacketID = [data readShort];
            if (![IBSNValuesValidator validatePacketID:regackPacketID]) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid packetID %zd", type, regackPacketID] userInfo:nil];
            }
            IBSNReturnCode returnCode = [data readByte];
            message = [[IBSNRegack alloc] initWithTopicID:regackTopicID packetID:regackPacketID returnCode:returnCode];
        } break;
        case IBPublishMessage:
        {
            IBSNFlags *publishFlags = [IBSNFlags decodeWithData:[data readByte] andMessageType:type];
            bytesLeft--;
            NSInteger publishTopicID = [data readShort];
            bytesLeft -= 2;
            NSInteger publishPacketID = [data readShort];
            bytesLeft -= 2;
            if (publishFlags.qos.value != IBAtMostOnce && publishPacketID == 0) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"invalid PUBLISH QoS-0 packetID: %zd", publishPacketID] userInfo:nil];
            }
            id<IBTopic> publishTopic = nil;
            
            if (publishFlags.topicType.value == IBShortTopicType) {
                publishTopic = [[IBSNShortTopic alloc] initWithValue:[@(publishTopicID) stringValue] andQoS:publishFlags.qos];
            } else {
                if (![IBSNValuesValidator validateTopicID:publishTopicID]) {
                    @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid topicID value %zd", type, publishTopicID] userInfo:nil];
                }
                publishTopic = [[IBSNIdentifierTopic alloc] initWithValue:publishTopicID andQoS:publishFlags.qos];
            }
            NSData *publishContent = nil;
            if (bytesLeft > 0) {
                NSString *publishContentString = [data readStringWithLength:bytesLeft];
                publishContent = [publishContentString dataUsingEncoding:IBStringEncoding];
            }
            message = [[IBSNPublish alloc] initWithPacketID:publishPacketID topic:publishTopic content:publishContent dup:publishFlags.isDup retainFlag:publishFlags.isRetainFlag];
        } break;
        case IBPubackMessage:
        {
            NSInteger pubackTopicID = [data readShort];
            if (![IBSNValuesValidator validateTopicID:pubackTopicID]) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid topicID value %zd", type, pubackTopicID] userInfo:nil];
            }
            NSInteger pubackPacketID = [data readShort];
            if (![IBSNValuesValidator validatePacketID:pubackPacketID]) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid packetID %zd", type, pubackPacketID] userInfo:nil];
            }
            IBSNReturnCode returnCode = [data readByte];
            message = [[IBSNPuback alloc] initWithTopicID:pubackTopicID packetID:pubackPacketID andReturnCode:returnCode];
        } break;
        case IBPubrecMessage:
        {
            NSInteger pubrecPacketID = [data readShort];
            if (![IBSNValuesValidator validatePacketID:pubrecPacketID]) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid packetID %zd", type, pubrecPacketID] userInfo:nil];
            }
            message = [[IBSNPubrec alloc] initWithPacketID:pubrecPacketID];
        } break;
        case IBPubrelMessage:
        {
            NSInteger pubrelPacketID = [data readShort];
            if (![IBSNValuesValidator validatePacketID:pubrelPacketID]) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid packetID %zd", type, pubrelPacketID] userInfo:nil];
            }
            message = [[IBSNPubrel alloc] initWithPacketID:pubrelPacketID];
        } break;
        case IBPubcompMessage:
        {
            NSInteger pubcompPacketID = [data readShort];
            if (![IBSNValuesValidator validatePacketID:pubcompPacketID]) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid packetID %zd", type, pubcompPacketID] userInfo:nil];
            }
            message = [[IBSNPubcomp alloc] initWithPacketID:pubcompPacketID];
        } break;
        case IBSubscribeMessage:
        {
            IBSNFlags *subscribeFlags = [IBSNFlags decodeWithData:[data readByte] andMessageType:type];
            bytesLeft--;
            NSInteger subscribePacketID = [data readShort];
            if (subscribePacketID == 0) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid packetID %zd", type, subscribePacketID] userInfo:nil];

            }
            bytesLeft -= 2;
            if (![IBSNValuesValidator canReadData:data withBytesLeft:bytesLeft] || bytesLeft < 2) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid topic encoding", type] userInfo:nil];
            }
            
            id<IBTopic> topic = nil;
                        
            switch (subscribeFlags.topicType.value) {
                case IBNamedTopicType:
                {
                    NSString *subscribeTopicName = [data readStringWithLength:bytesLeft];
                    topic = [[IBSNFullTopic alloc] initWithValue:subscribeTopicName andQoS:subscribeFlags.qos];
                } break;
                case IBIDTopicType:
                {
                    NSInteger subscribeTopicID = [data readShort];
                    if (![IBSNValuesValidator validateTopicID:subscribeTopicID]) {
                        @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid topicID value %zd", type, subscribeTopicID] userInfo:nil];
                    }
                    topic = [[IBSNIdentifierTopic alloc] initWithValue:subscribeTopicID andQoS:subscribeFlags.qos];
                } break;
                case IBShortTopicType:
                {
                    NSString *subscribeTopicShortName = [data readStringWithLength:bytesLeft];
                    topic = [[IBSNShortTopic alloc] initWithValue:subscribeTopicShortName andQoS:subscribeFlags.qos];
                } break;
            }
            message = [[IBSNSubscribe alloc] initWithPacketID:subscribePacketID topic:topic dup:subscribeFlags.isDup];
        } break;
        case IBSubackMessage:
        {
            IBSNFlags *subackFlags = [IBSNFlags decodeWithData:[data readByte] andMessageType:type];
            NSInteger subackTopicID = [data readShort];
            if (![IBSNValuesValidator validateTopicID:subackTopicID]) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid topicID value %zd", type, subackTopicID] userInfo:nil];
            }
            NSInteger subackPacketID = [data readShort];
            if (![IBSNValuesValidator validatePacketID:subackPacketID]) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid packetID %zd", type, subackPacketID] userInfo:nil];
            }
            IBSNReturnCode returnCode = [data readByte];
            message = [[IBSNSuback alloc] initWithTopicID:subackTopicID packetID:subackPacketID returnCode:returnCode lowedQos:subackFlags.qos];
        } break;
        case IBUnsubscribeMessage:
        {
            IBSNFlags *unsubscribeFlags = [IBSNFlags decodeWithData:[data readByte] andMessageType:type];
            bytesLeft--;
            NSInteger unsubscribePacketID = [data readShort];
            if (![IBSNValuesValidator validatePacketID:unsubscribePacketID]) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid packetID %zd", type, unsubscribePacketID] userInfo:nil];

            }
            bytesLeft -= 2;
            
            id<IBTopic> topic = nil;
        
            switch (unsubscribeFlags.topicType.value) {
                case IBNamedTopicType:
                {
                    NSString *unsubscribeTopicName = [data readStringWithLength:bytesLeft];
                    topic = [[IBSNFullTopic alloc] initWithValue:unsubscribeTopicName andQoS:unsubscribeFlags.qos];
                } break;
                case IBIDTopicType:
                {
                    NSInteger unsubscribeTopicID = [data readShort];
                    if (![IBSNValuesValidator validateTopicID:unsubscribeTopicID]) {
                        @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid topicID value %zd", type, unsubscribeTopicID] userInfo:nil];
                    }
                    topic = [[IBSNIdentifierTopic alloc] initWithValue:unsubscribeTopicID andQoS:unsubscribeFlags.qos];
                } break;
                case IBShortTopicType:
                {
                    NSString *unsubscribeTopicShortName = [data readStringWithLength:bytesLeft];
                    topic = [[IBSNShortTopic alloc] initWithValue:unsubscribeTopicShortName andQoS:unsubscribeFlags.qos];
                } break;
            }
            message = [[IBSNUnsubscribe alloc] initWithPacketID:unsubscribePacketID topic:topic];
        } break;
        case IBUnsubackMessage:
        {
            NSInteger unsubackPacketID = [data readShort];
            if (![IBSNValuesValidator validatePacketID:unsubackPacketID]) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid packetID %zd", type, unsubackPacketID] userInfo:nil];
            }
            message = [[IBSNUnsuback alloc] initWithPacketID:unsubackPacketID];
        } break;
        case IBPingreqMessage:
        {
            NSString *pingreqClientID = nil;
            if (bytesLeft > 0) {
                pingreqClientID = [data readStringWithLength:bytesLeft];
            }
            message = [[IBSNPingreq alloc] initWithClientID:pingreqClientID];
        } break;
        case IBPingrespMessage:
        {
            message = [[IBSNPingresp alloc] init];
        } break;
        case IBDisconnectMessage:
        {
            NSInteger duration = 0;
            if (bytesLeft > 0) {
                duration = [data readShort];
            }
            message = [[IBSNDisconnect alloc] initWithDuration:duration];
        } break;
        case IBWillTopicUpdMessage:
        {
            IBSNFullTopic *topic = nil;
            BOOL willTopicUpdateRetain = false;
            if (bytesLeft > 0) {
                IBSNFlags *willTopicUpdFlags = [IBSNFlags decodeWithData:[data readByte] andMessageType:type];
                willTopicUpdateRetain = willTopicUpdFlags.isRetainFlag;
                bytesLeft--;
                NSString *willTopicUpdTopicValue = [data readStringWithLength:bytesLeft];
                topic = [[IBSNFullTopic alloc] initWithValue:willTopicUpdTopicValue andQoS:willTopicUpdFlags.qos];
            }
            message = [[IBSNWillTopicUpd alloc] initWithTopic:topic andRetainFlag:willTopicUpdateRetain];
        } break;
        case IBWillMsgUpdMessage:
        {
            if (![IBSNValuesValidator canReadData:data withBytesLeft:bytesLeft]) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd must contain content data", type] userInfo:nil];
            }
            NSString *willMsgUpdContentString = [data readStringWithLength:bytesLeft];
            NSData *willMsgUpdContent = [willMsgUpdContentString dataUsingEncoding:IBStringEncoding];
            message = [[IBSNWillMsgUpd alloc] initWithContent:willMsgUpdContent];
        } break;
        case IBWillTopicRespMessage:
        {
            IBSNReturnCode returnCode = [data readByte];
            message = [[IBSNWillTopicResp alloc] initWithReturnCode:returnCode];
        } break;
        case IBWillMsgRespMessage:
        {
            IBSNReturnCode returnCode = [data readByte];
            message = [[IBSNWillMsgResp alloc] initWithReturnCode:returnCode];
        } break;
        case IBEncapsulatedMessage:
        {
            IBSNControls *control = [IBSNControls decode:[data readByte]];
            bytesLeft--;
            NSString *wirelessNodeID = [data readStringWithLength:bytesLeft];
            
            NSData *subdata = [data subdataWithRange:NSMakeRange([data getByteNumber] - 1, data.length - [data getByteNumber] + 1)];
            NSMutableData *messageData = [NSMutableData dataWithData:subdata];
            id<IBMessage> encapsulatedMessage = [IBSNParser decode:messageData];
            
            message = [[IBSNEncapsulated alloc] initWithRadius:control.radius wirelessNodeID:wirelessNodeID andMessage:encapsulatedMessage];
        } break;
    }
    if ([data getByteNumber] < data.length) {
        @throw [NSException exceptionWithName:[[self class] description] reason:@"not all bytes have been read from buffer" userInfo:nil];
    }

    [data clearNumber];
    return message;
}

#pragma mark - Private methods -

+ (NSInteger) decodeContentLength : (NSMutableData *) data {

    NSInteger length = 0;
    short firstLengthByte = [data readByte];
    if (firstLengthByte == IBThreeOctetLengthSuffix) {
        length = [data readShort];
    } else {
        length = firstLengthByte;
    }
    return length;
}

@end
