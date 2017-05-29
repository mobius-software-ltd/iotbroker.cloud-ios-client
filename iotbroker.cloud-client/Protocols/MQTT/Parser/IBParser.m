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

#import "IBParser.h"

@implementation IBParser

#pragma mark - PREPARE NEXT PACKET -

+ (NSMutableData *) next : (NSMutableData **) buffer {
    
    Byte fixedHeader = [*buffer readByte];
    Byte messageType = ((fixedHeader >> 4) & 0xf);
    
    if (messageType == 0) {
        return nil;
    }
    
    IBLengthDetails *length = nil;
    
    NSRange range = {0, 0};
    
    switch (messageType) {
        case IBPingreqMessage:
        case IBPingrespMessage:
        case IBDisconnectMessage:
        {
            range.location = 0;
            range.length = 2;
            NSMutableData *returnValue = [NSMutableData dataWithData:[*buffer subdataWithRange:range]];
            [*buffer replaceBytesInRange:range withBytes:NULL length:0];
            return returnValue;
        }   break;
        default:
        {
            length = [IBLengthDetails decodeLength:*buffer];
            if (length != nil) {
                if (length.length == 0) {
                    return nil;
                }
                
                NSInteger result = length.length + length.size + 1;
                if (result <= (*buffer).length) {
                    range.location = 0;
                    range.length = result;
                    [*buffer clearNumber];
                    NSMutableData *returnValue = [NSMutableData dataWithData:[*buffer subdataWithRange:range]];
                    
                    [*buffer replaceBytesInRange:range withBytes:NULL length:0];
                    return returnValue;
                }
            }
        } break;
    }
    return nil;
}

#pragma mark - ENCODE IBMESSAGE TO DATA -

+ (NSMutableData *) encode : (id<IBMessage>) message {
    
    NSInteger length = [message getLength];
    NSMutableData *buffer = [NSMutableData data];
    Byte messageType = [message getMessageType];
    
    if (messageType == IBConnectMessage) {
        
        IBConnect *connect = (IBConnect *)message;
        
        if ([connect isWillFlag] && ![connect.will isValid]) {
            @throw [NSException exceptionWithName:@"CONNECT" reason:@"invalid will encoding" userInfo:nil];
        }
        
        [buffer appendByte:(messageType << 4)];
        
        [buffer appendData:[IBParser getBufferByLength:length]];

        [buffer appendShort:4];
        
        [buffer appendData:[[connect getProtocolName] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [buffer appendByte:[connect protocolLevel]];
        
        Byte contentFlags = 0;
        
        // Reserved
        
        if ([connect isClean] == true) {                            // Clean session
            contentFlags += 2;
        }
        if ([connect isWillFlag] == true) {                         // Will
            contentFlags += 4;
            contentFlags += connect.will.topic.qos.value << 3; // QOS
            if (connect.will.isRetain == true) {                    // Retain
                contentFlags += 0x20;
            }
        }
        if ([connect isPasswordFlag] == true) {
            contentFlags += 0x40;
        }
        if ([connect isUsernameFlag] == true) {
            contentFlags += 0x80;
        }
       
        [buffer appendByte:contentFlags];
        
        [buffer appendShort:connect.keepalive];

        [buffer appendShort:connect.clientID.length];
        
        [buffer appendData:[connect.clientID dataUsingEncoding:NSUTF8StringEncoding]];
        
        if (connect.isWillFlag == true) {
            
            NSString *willTopic = connect.will.topic.name;
            if (willTopic != nil) {
                [buffer appendShort:willTopic.length];
                [buffer appendData:[willTopic dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
            NSMutableData *willMessage = (NSMutableData *)connect.will.content;
            if (willMessage != nil) {
                [buffer appendShort:willMessage.length];
                [buffer appendData:willMessage];
            }
        }
        
        if (connect.username != nil) {
            [buffer appendShort:connect.username.length];
            [buffer appendData:[connect.username dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        if (connect.password != nil) {
            [buffer appendShort:connect.password.length];
            [buffer appendData:[connect.password dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
    } else if (messageType == IBConnackMessage) {
        
        IBConnack *connack = (IBConnack *)message;
        [buffer appendByte:(messageType << 4)];
        [buffer appendData:[IBParser getBufferByLength:length]];
        [buffer appendByte:(Byte)connack.sessionPresentValue];
        [buffer appendByte:(Byte)connack.returnCode];
        
    } else if (messageType == IBPublishMessage) {
        
        IBPublish *publish = (IBPublish *)message;
        Byte firstByte = (Byte)(messageType << 4);
        firstByte |= (publish.dup == true)? 8 : 0;
        firstByte |= (publish.topic.qos.value << 1);
        firstByte |= (publish.isRetain == true)? 1 : 0;
        
        [buffer appendByte:firstByte];
        [buffer appendData:[IBParser getBufferByLength:length]];
        
        [buffer appendShort:[publish.topic length]];
        [buffer appendData:[publish.topic.name dataUsingEncoding:NSUTF8StringEncoding]];
        
        switch (publish.topic.qos.value) {
            case IBAtMostOnce:
                if (publish.packetID != 0) {
                    @throw [NSException exceptionWithName:@"PUBLISH" reason:@"publish qos-0 must not contain packetID" userInfo:nil];
                }
                break;
            case IBAtLeastOnce:
            case IBExactlyOnce:
                if (publish.packetID == 0) {
                    @throw [NSException exceptionWithName:@"PUBLISH" reason:@"publish qos-1,2 must contain packetID" userInfo:nil];
                }
                [buffer appendShort:publish.packetID];
                break;
            case IBLevelOne:
                @throw [NSException exceptionWithName:@"PUBLISH" reason:@"publish qos-3 not support in MQTT" userInfo:nil];

        }
        [buffer appendData:publish.content];
        
    } else if (messageType == IBPubackMessage) {
        
        IBPuback *puback = (IBPuback *)message;
        [buffer appendByte:(messageType << 4)];
        [buffer appendData:[IBParser getBufferByLength:length]];
        if (puback.packetID == 0) {
            @throw [NSException exceptionWithName:@"PUBACK" reason:@"puback must contain packetID" userInfo:nil];
        }
        [buffer appendShort:puback.packetID];
        
    } else if (messageType == IBPubrecMessage) {
        
        IBPubrec *pubrec = (IBPubrec *)message;
        [buffer appendByte:(messageType << 4)];
        [buffer appendData:[IBParser getBufferByLength:length]];
        if (pubrec.packetID == 0) {
            @throw [NSException exceptionWithName:@"PUBREC" reason:@"pubrec must contain packetID" userInfo:nil];
        }
        [buffer appendShort:pubrec.packetID];
        
    } else if (messageType == IBPubrelMessage) {
        
        IBPubrel *pubrel = (IBPubrel *)message;
        [buffer appendByte:(messageType << 4 | 0x2)];
        [buffer appendData:[IBParser getBufferByLength:length]];
        if (pubrel.packetID == 0) {
            @throw [NSException exceptionWithName:@"PUBREL" reason:@"pubrel must contain packetID" userInfo:nil];
        }
        [buffer appendShort:pubrel.packetID];
        
    } else if (messageType == IBPubcompMessage) {
        
        IBPubcomp *pubcomp = (IBPubcomp *)message;
        [buffer appendByte:(messageType << 4)];
        [buffer appendData:[IBParser getBufferByLength:length]];
        if (pubcomp.packetID == 0) {
            @throw [NSException exceptionWithName:@"PUBCOMP" reason:@"pubcomp must contain packetID" userInfo:nil];
        }
        [buffer appendShort:pubcomp.packetID];
        
    } else if (messageType == IBSubscribeMessage) {

        IBSubscribe *subscribe = (IBSubscribe *)message;
        [buffer appendByte:(messageType << 4 | 0x2)];
        [buffer appendData:[IBParser getBufferByLength:length]];
        if (subscribe.packetID == 0) {
            @throw [NSException exceptionWithName:@"SUBSCRIBE" reason:@"subscribe must contain packetID" userInfo:nil];
        }
        [buffer appendShort:subscribe.packetID];
        
        for (IBMQTTTopic *item in subscribe.topics) {
            [buffer appendShort:[item.name length]];
            [buffer appendData:[item.name dataUsingEncoding:NSUTF8StringEncoding]];
            [buffer appendByte:item.qos.value];
        }
        
    } else if (messageType == IBSubackMessage) {
        
        IBSuback *suback = (IBSuback *)message;
        [buffer appendByte:(messageType << 4)];
        [buffer appendData:[IBParser getBufferByLength:length]];
        if (suback.packetID == 0) {
            @throw [NSException exceptionWithName:@"SUBACK" reason:@"suback must contain packetID" userInfo:nil];
        }
        [buffer appendShort:suback.packetID];
        
        for (NSNumber *item in suback.returnCodes) {
            [buffer appendByte:item.integerValue];
        }
    
    } else if (messageType == IBUnsubscribeMessage) {
        
        IBUnsubscribe *unsubscribe = (IBUnsubscribe *)message;
        [buffer appendByte:(messageType << 4 | 0x2)];
        [buffer appendData:[IBParser getBufferByLength:length]];
        if (unsubscribe.packetID == 0) {
            @throw [NSException exceptionWithName:@"UNSUBSCRIBE" reason:@"unsubscribe must contain packetID" userInfo:nil];
        }
        [buffer appendShort:unsubscribe.packetID];
        
        for (NSString *item in unsubscribe.topics) {
            [buffer appendShort:[item length]];
            [buffer appendData:[item dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
    } else if (messageType == IBUnsubackMessage) {
        
        IBUnsuback *unsuback = (IBUnsuback *)message;
        [buffer appendByte:(messageType << 4)];
        [buffer appendData:[IBParser getBufferByLength:length]];
        if (unsuback.packetID == 0) {
            @throw [NSException exceptionWithName:@"UNSUBACK" reason:@"unsuback must contain packetID" userInfo:nil];
        }
        [buffer appendShort:unsuback.packetID];
        
    } else if (messageType == IBPingreqMessage || messageType == IBPingrespMessage || messageType == IBDisconnectMessage) {
        
        [buffer appendByte:(messageType << 4)];
        [buffer appendData:[IBParser getBufferByLength:length]];
        
    } else {
        NSLog(@"\n\n\n E: UNKNOWN TYPE! \n\n\n");
    }
    
    [buffer clearNumber];
    
    return buffer;
}

#pragma mark - DECODE DATA TO IBMESSAGE -

+ (id<IBMessage>) decode : (NSMutableData *) buffer {
    
    [buffer clearNumber];
    
    id<IBMessage> message = nil;
    
    Byte fixedHeader = [buffer readByte];
    Byte messageType = ((fixedHeader >> 4) & 0xf);
    
    IBLengthDetails *length = [IBLengthDetails decodeLength:buffer];

    if (messageType == IBConnectMessage) {
        
        NSInteger protocolNameLength = [buffer readShort];
        NSString *protocolName = [buffer readStringWithLength : protocolNameLength];
        
        IBConnect *connect = [[IBConnect alloc] init];
        
        if (![protocolName isEqualToString:[connect getProtocolName]]) {
            @throw [NSException exceptionWithName:@"CONNECT" reason:[NSString stringWithFormat:@"Protocol is %@", protocolName] userInfo:nil];
        }
        
        NSInteger protocolLevel = [buffer readByte];
        
        Byte contentFlags = [buffer readByte];
        
        BOOL usernameFlag       = (((contentFlags >> 7) & 1) == 1) ? true : false;
        BOOL userPasswordFlag   = (((contentFlags >> 6) & 1) == 1) ? true : false;
        BOOL willRetainFlag     = (((contentFlags >> 5) & 1) == 1) ? true : false;
        
        NSInteger willQoSFlag   = (((contentFlags & 0x1f) >> 3) & 3);
        IBQoS *willQos = [[IBQoS alloc] initWithValue:willQoSFlag];
        
        if ([willQos isValidForMqtt] != true) {
            @throw [NSException exceptionWithName:@"CONNECT" reason:[NSString stringWithFormat:@"will QoS set to %zd", willQos.value] userInfo:nil];
        }
        
        BOOL willFlag           = (((contentFlags >> 2) & 1) == 1) ? true : false;
        
        if (willQos.value > 0 && !willFlag) {
            @throw [NSException exceptionWithName:@"CONNECT" reason:@"will retain set, willFlag not set" userInfo:nil];
        }
        
        BOOL cleanSessionFlag   = (((contentFlags >> 1) & 1) == 1) ? true : false;
        BOOL reservedFlag       = ((contentFlags  & 1) == 1) ? true : false;
        
//        NSLog(@"User name flag      = %@", usernameFlag ? @"yes" : @"no");
//        NSLog(@"User password flag  = %@", userPasswordFlag ? @"yes" : @"no");
//        NSLog(@"Will retain flag    = %@", willRetainFlag ? @"yes" : @"no");
//        NSLog(@"User qos flag       = %@", willQoSFlag ? @"yes" : @"no");
//        NSLog(@"User flag           = %@", willFlag ? @"yes" : @"no");
//        NSLog(@"Clean session flag  = %@", cleanSessionFlag ? @"yes" : @"no");
//        NSLog(@"Reserved flag       = %@", reservedFlag ? @"yes" : @"no");
        
        if (reservedFlag == true) {
            @throw [NSException exceptionWithName:@"CONNECT" reason:@"Reserved flag set to true" userInfo:nil];
        }
        
        NSInteger keepalive = [buffer readShort];
        
        NSInteger cliendIDLength = [buffer readShort];
        NSString *clientID = [buffer readStringWithLength:cliendIDLength];
        
        if ([IBParser verifyString:clientID] != true) {
            @throw [NSException exceptionWithName:@"CONNECT" reason:@"ClientID contains restricted characters: U+0000, U+D000-U+DFFF" userInfo:nil];
        }
        
        NSData *willMessage = nil;
        NSString *username = [NSString string];
        NSString *password = [NSString string];
        
        IBWill *will = nil;
        
        if (willFlag == true) {
        
            NSInteger willTopicNameLength = [buffer readShort];
            NSString *willTopicName = [buffer readStringWithLength:willTopicNameLength];

            if ([IBParser verifyString:willTopicName] != true) {
                @throw [NSException exceptionWithName:@"CONNECT" reason:@"WillTopic contains one or more restricted characters: U+0000, U+D000-U+DFFF" userInfo:nil];
            }
            
            NSInteger willMessageStringLength = [buffer readShort];
            NSString *willMessageString = [buffer readStringWithLength:willMessageStringLength];
            willMessage = [willMessageString dataUsingEncoding:NSUTF8StringEncoding];
            
            if (willTopicName.length == 0) {
                @throw [NSException exceptionWithName:@"CONNECT" reason:@"WillTopic contains invalid will encoding" userInfo:nil];
            }
            
            IBMQTTTopic *topic = [[IBMQTTTopic alloc] initWithName:willTopicName andQoS:willQos];
            will = [[IBWill alloc] initWithTopic:topic content:willMessage andIsRetain:willRetainFlag];
            
            if ([will isValid] == false) {
                @throw [NSException exceptionWithName:@"CONNECT" reason:@"Will contains invalid will encoding" userInfo:nil];
            }
        }
        
        if (usernameFlag == true) {
            
            NSInteger usernameLength = [buffer readShort];
            username = [buffer readStringWithLength:usernameLength];
            
            if ([IBParser verifyString:username] != true) {
                @throw [NSException exceptionWithName:@"CONNECT" reason:@"username contains one or more restricted characters: U+0000, U+D000-U+DFFF" userInfo:nil];
            }
        }
        
        if (userPasswordFlag == true) {
            
            NSInteger passwordLength = [buffer readShort];
            password = [buffer readStringWithLength:passwordLength];
            
            if ([IBParser verifyString:password] != true) {
                @throw [NSException exceptionWithName:@"CONNECT" reason:@"password contains one or more restricted characters: U+0000, U+D000-U+DFFF" userInfo:nil];
            }
        }

        connect.username = username;
        connect.password = password;
        connect.clientID = clientID;
        connect.cleanSession = cleanSessionFlag;
        connect.keepalive = keepalive;
        connect.will = will;
        
        if (protocolLevel != 4) {
            [connect setCurrentProtocolLevel:protocolLevel];
        }
        
        message = connect;
        
    } else if (messageType == IBConnackMessage) {
        
        IBConnack *connack = [[IBConnack alloc] init];
        
        Byte sessionPresentValue = [buffer readByte];
        
        if (sessionPresentValue != 0 && sessionPresentValue != 1) {
            @throw [NSException exceptionWithName:@"CONNACK" reason:[NSString stringWithFormat:@"session-present set to %i", sessionPresentValue] userInfo:nil];
        }
        
        BOOL isPresent = (sessionPresentValue == 1) ? true : false;
        Byte connectReturnCode = [buffer readByte];
        
        if ([connack isValidReturnCode:connectReturnCode] != true) {
            @throw [NSException exceptionWithName:@"CONNACK" reason:@"Invalid connack code" userInfo:nil];
        }
        
        connack.sessionPresentValue = isPresent;
        connack.returnCode = connectReturnCode;
        
        message = connack;
        
    } else if (messageType == IBPublishMessage) {
        
        NSInteger dataLength = length.length;
        fixedHeader &= 0xf;
        
        BOOL dup = (((fixedHeader >> 3) & 1) == 1)? true : false;
        
        IBQoS *qos = [[IBQoS alloc] initWithValue:((fixedHeader & 0x07) >> 1)];
        
        if ([qos isValidForMqtt] == false) {
            @throw [NSException exceptionWithName:@"PUBLISH" reason:@"invalid QoS value" userInfo:nil];
        }
        
        if (dup == true && qos.value == IBAtMostOnce) {
            @throw [NSException exceptionWithName:@"PUBLISH" reason:@"PUBLISH, QoS-0 dup flag present" userInfo:nil];
        }
        
        BOOL isRetain = ((fixedHeader & 1) == 1) ? true : false;
        
        NSInteger topicNameLength = [buffer readShort];
        NSString *topicName = [buffer readStringWithLength:topicNameLength];
        
        if ([IBParser verifyString:topicName] != true) {
            @throw [NSException exceptionWithName:@"PUBLISH" reason:@"Publish-topic contains one or more restricted characters: U+0000, U+D000-U+DFFF" userInfo:nil];
        }
        
        dataLength -= (topicName.length + 2);
        
        NSInteger packetID = 0;
        
        if (qos.value != IBAtMostOnce) {
            
            packetID = [buffer readShort];
            if (packetID < 0 || packetID > 65535) {
                @throw [NSException exceptionWithName:@"PUBLISH" reason:@"Invalid PUBLISH packetID encoding" userInfo:nil];
            }
            dataLength -= 2;
        }
        
        NSData *data = [[NSData alloc] init];
        if (dataLength > 0) {
        
            NSString *string = [buffer readStringWithLength:dataLength];
            data = [string dataUsingEncoding:NSUTF8StringEncoding];
        }
        
        NSLog(@"packet ID = %zd, Topic name = %@, qos = %zd, data = %@, is return = %i", packetID, topicName, qos.value, [NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding], isRetain);
        
        message = [[IBPublish alloc] initWithPacketID:packetID andTopic:[[IBMQTTTopic alloc] initWithName:topicName andQoS:qos] andContent:data andIsRetain:isRetain andDup:dup];
        
    } else if (messageType == IBPubackMessage) {
        
        NSInteger packetID = [buffer readShort];
        message = [[IBPuback alloc] initWithPacketID:packetID];
        
    } else if (messageType == IBPubrecMessage) {
        
        NSInteger packetID = [buffer readShort];
        message = [[IBPubrec alloc] initWithPacketID:packetID];
        
    } else if (messageType == IBPubrelMessage) {
        
        NSInteger packetID = [buffer readShort];
        message = [[IBPubrel alloc] initWithPacketID:packetID];
        
    } else if (messageType == IBPubcompMessage) {
        
        NSInteger packetID = [buffer readShort];
        message = [[IBPubcomp alloc] initWithPacketID:packetID];
        
    } else if (messageType == IBSubscribeMessage) {
        
        NSInteger subscribeID = [buffer readShort];
        NSMutableArray<IBMQTTTopic *> *subscriptions = [NSMutableArray array];
        
        while ([buffer getByteNumber] < [buffer length]) {

            NSInteger topicLength = [buffer readShort];
            
            NSString *topic = [buffer readStringWithLength:topicLength];
            IBQoS *qos = [[IBQoS alloc] initWithValue:[buffer readByte]];

            if ([qos isValidForMqtt] == false) {
                @throw [NSException exceptionWithName:@"SUBSCRIBE" reason:@"Subscribe qos must be in range from 0 to 2" userInfo:nil];

            }
            if ([IBParser verifyString:topic] != true) {
                @throw [NSException exceptionWithName:@"SUBSCRIBE" reason:@"Subscribe topic contains one or more restricted characters: U+0000, U+D000-U+DFFF" userInfo:nil];
            }

            IBMQTTTopic *subscription = [[IBMQTTTopic alloc] initWithName:topic andQoS:qos];
            [subscriptions addObject:subscription];
        }
        
        IBSubscribe *subscribe = [[IBSubscribe alloc] initWithPacketID:subscribeID];
        subscribe.topics = subscriptions;
        
        message = subscribe;
        
    } else if (messageType == IBSubackMessage) {
        
        NSInteger subackID = [buffer readShort];
        NSMutableArray<NSNumber *> *subackCodes = [NSMutableArray array];
        
        IBSuback *suback = [[IBSuback alloc] initWithPacketID:subackID];
        
        while ([buffer getByteNumber] < [buffer length]) {
        
            NSInteger subackByte = [buffer readByte];
            
            if ([suback isValidCode:(IBSubackCode)subackByte] != true) {
                @throw [NSException exceptionWithName:@"SUBACK" reason:@"Invalid suback code" userInfo:nil];
            }
            [subackCodes addObject:@(subackByte)];
        }
        
        suback.returnCodes = subackCodes;
        message = suback;
        
    } else if (messageType == IBUnsubscribeMessage) {
        
        NSInteger unsubackID = [buffer readShort];
        NSMutableArray<NSString *> *unsubscribeTopics = [NSMutableArray array];
                
        while ([buffer getByteNumber] <= length.length) {
        
            NSInteger topicLength = [buffer readShort];
            NSString *topic = [buffer readStringWithLength:topicLength];
            
            if ([IBParser verifyString:topic] != true) {
                @throw [NSException exceptionWithName:@"UNSUBSCRIBE" reason:@"Unsubscribe topic contains one or more restricted characters: U+0000, U+D000-U+DFFF" userInfo:nil];
            }
                        
            [unsubscribeTopics addObject:topic];
        }
        
        IBUnsubscribe *unsuback = [[IBUnsubscribe alloc] initWithPacketID:unsubackID];
        unsuback.topics = unsubscribeTopics;
        
        message = (IBUnsubscribe *)unsuback;
        
    } else if (messageType == IBUnsubackMessage) {
        
        NSInteger packetID = [buffer readShort];
        message = [[IBUnsuback alloc] initWithPacketID:packetID];
        
    } else if (messageType == IBPingreqMessage) {
        
        message = [[IBPingreq alloc] init];
        
    } else if (messageType == IBPingrespMessage) {
        
        message = [[IBPingresp alloc] init];
        
    } else if (messageType == IBDisconnectMessage) {
        
        message = [[IBDisconnect alloc] init];
        
    } else {
        NSLog(@"\n\n\n D: UNKNOWN TYPE! \n\n\n");
    }
    
    [buffer clearNumber];
    
    if (length.length != [message getLength])
        @throw [NSException exceptionWithName:@"DECODE" reason: [NSString stringWithFormat:@"Invalid length. Encoded: %zd, actual: %zd", length.length, [message getLength]] userInfo:nil];
    
    return message;
}

#pragma mark - Private methods -

+ (NSMutableData *) getBufferByLength : (NSInteger) length {
    
    NSMutableData *data = [NSMutableData data];
    NSInteger lng = length;
    Byte encodedByte;
    
    do {
        encodedByte = (Byte)(lng % 128);
        lng /= 128;
        
        if (lng > 0) {
            [data appendByte:(Byte)(encodedByte | 128)];
        } else {
            [data appendByte:encodedByte];
        }
    } while (lng > 0);
    
    NSInteger bufferSize = 1 + data.length + length;
    NSMutableData *buffer = [NSMutableData dataWithCapacity:bufferSize];

    [buffer appendData:data];
    
    return buffer;
}

+ (BOOL) verifyString : (NSString *) topic {

    char nilCharacter = '\0';
    
    char *chars = (char *)[topic UTF8String];
    
    if (topic.length > 0) {
        for (int i = 0; i < topic.length; i++) {
            if (chars[i] == nilCharacter) {
                return false;
            }
        }
    }
    return true;
}

@end
