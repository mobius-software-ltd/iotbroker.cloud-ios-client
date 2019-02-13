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

#import "IBSNFlags.h"

@implementation IBSNFlags

- (instancetype) initWithDup : (BOOL) dup qos : (IBQoS *) qos retainFlag : (BOOL) retainFlag will : (BOOL) will cleanSession : (BOOL) cleanSession topicType : (IBSNTopicType *) topicType {
    self = [super init];
    if (self != nil) {
        self->_dup = dup;
        self->_qos = qos;
        self->_retainFlag = retainFlag;
        self->_will = will;
        self->_cleanSession = cleanSession;
        self->_topicType = topicType;
    }
    return self;
}

+ (IBSNFlags *) decodeWithData : (Byte) flagsByte andMessageType : (IBSNMessages) type {
    NSArray *flags = [NSArray arrayWithObjects:   @(IBDUplicateFlag), @(IBQoSLevelOneFlag),   @(IBQoS2Flag),          @(IBQoS1Flag),          @(IBRetainFlag),
                                                @(IBWillFlag),      @(IBCleanSessionFlag),  @(IBReservedTopicFlag), @(IBShortTopicFlag),    @(IBIdTopicFlag), nil];
    NSMutableArray *bitmask = [NSMutableArray array];
    for (NSNumber *item in flags) {
        if ((flagsByte & [item integerValue]) == [item integerValue]) {
            [bitmask addObject:item];
        }
    }
    return [IBSNFlags validateAndCreate:bitmask andType:type];
}

+ (IBSNFlags *) validateAndCreate : (NSArray *) bitMask andType : (IBSNMessages) type {

    if ([bitMask containsObject:@(IBReservedTopicFlag)] == true) {
        @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"Invalid topic type encoding. TopicType reserved bit must not be encoded"] userInfo:nil];
    }
    
    BOOL dup = [bitMask containsObject:@(IBDUplicateFlag)];
    BOOL retainFlag = [bitMask containsObject:@(IBRetainFlag)];
    BOOL will = [bitMask containsObject:@(IBWillFlag)];
    BOOL cleanSession = [bitMask containsObject:@(IBCleanSessionFlag)];

    IBQoS *qos = nil;
    
    if ([bitMask containsObject:@(IBQoSLevelOneFlag)]) {
        qos = [[IBQoS alloc] initWithValue:IBLevelOne];
    } else if ([bitMask containsObject:@(IBQoS2Flag)]) {
        qos = [[IBQoS alloc] initWithValue:IBExactlyOnce];
    } else if ([bitMask containsObject:@(IBQoS1Flag)]) {
        qos = [[IBQoS alloc] initWithValue:IBAtLeastOnce];
    } else {
        qos = [[IBQoS alloc] initWithValue:IBAtMostOnce];
    }

    IBSNTopicType *topicType = nil;
    
    if ([bitMask containsObject:@(IBShortTopicFlag)]) {
        topicType = [[IBSNTopicType alloc] initWithValue:IBShortTopicType];
    } else if ([bitMask containsObject:@(IBIdTopicFlag)]) {
        topicType = [[IBSNTopicType alloc] initWithValue:IBIDTopicType];
    } else {
        topicType = [[IBSNTopicType alloc] initWithValue:IBNamedTopicType];
    }
    
    switch (type) {
        case IBConnectMessage:
        {
            if (dup == true) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: dup flag", type] userInfo:nil];
            }
            if (qos.value != IBAtMostOnce) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: qos flag - %zd", type, qos.value] userInfo:nil];
            }
            if (retainFlag == true) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: retain flag", type] userInfo:nil];
            }
            if (topicType.value != IBNamedTopicType) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: topicIdType flag - %zd", type, topicType.value] userInfo:nil];
            }
        } break;
        case IBWillTopicMessage:
        {
            if (dup == true) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: dup flag", type] userInfo:nil];
            }
            if (qos == nil) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: qos flag", type] userInfo:nil];
            }
            if (will == true) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: will flag", type] userInfo:nil];
            }
            if (cleanSession == true) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd encoding: cleanSession flag", type] userInfo:nil];
            }
            if (topicType.value != IBNamedTopicType) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: topicIdType flag - %zd", type, topicType.value] userInfo:nil];
            }
        } break;
        case IBPublishMessage:
        {
            if (qos == nil) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: qos flag", type] userInfo:nil];
            }
            if (topicType == nil) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: topicIdType flag", type] userInfo:nil];
            }
            if (will == true) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: will flag", type] userInfo:nil];
            }
            if (cleanSession == true) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: cleanSession flag", type] userInfo:nil];
            }
            if (dup && (qos.value == IBAtMostOnce || qos.value == IBLevelOne)) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: dup flag with invalid qos: %zd", type, qos.value] userInfo:nil];
            }
        } break;
        case IBSubscribeMessage:
        {
            if (qos == nil) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: qos flag", type] userInfo:nil];
            }
            if (qos.value == IBLevelOne) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: qos %zd", type, qos.value] userInfo:nil];
            }
            if (retainFlag == true) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: retain flag", type] userInfo:nil];
            }
            if (will == true) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: will flag", type] userInfo:nil];
            }
            if (cleanSession == true) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: cleanSession flag", type] userInfo:nil];
            }
            if (topicType == nil) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: retain flag", type] userInfo:nil];
            }
        } break;
        case IBSubackMessage:
        {
            if (dup == true) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: dup flag", type] userInfo:nil];
            }
            if (qos == nil) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: qos flag", type] userInfo:nil];
            }
            if (retainFlag == true) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: retain flag", type] userInfo:nil];
            }
            if (will == true) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: will flag", type] userInfo:nil];
            }
            if (cleanSession == true) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: cleanSession flag", type] userInfo:nil];
            }
            if (topicType.value != IBNamedTopicType) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: topicIdType flag", type] userInfo:nil];
            }
        } break;
        case IBUnsubscribeMessage:
        {
            if (dup == true) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: dup flag", type] userInfo:nil];
            }
            if (qos.value != IBAtMostOnce) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: qos flag", type] userInfo:nil];
            }
            if (retainFlag == true) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: retain flag", type] userInfo:nil];
            }
            if (will == true) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: will flag", type] userInfo:nil];
            }
            if (cleanSession == true) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: cleanSession flag", type] userInfo:nil];
            }
            if (topicType == nil) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: topicIdType flag", type] userInfo:nil];
            }
        } break;
        case IBWillTopicUpdMessage:
        {
            if (dup == true) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: dup flag", type] userInfo:nil];
            }
            if (qos == nil) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: qos flag", type] userInfo:nil];
            }
            if (will == true) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: will flag", type] userInfo:nil];
            }
            if (cleanSession == true) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: cleanSession flag", type] userInfo:nil];
            }
            if (topicType.value != IBNamedTopicType) {
                @throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"%zd invalid encoding: topicIdType flag", type] userInfo:nil];
            }
        } break;
        case IBGWInfoMessage:
        case IBPubackMessage:
        case IBPubrecMessage:
        case IBPubrelMessage:
        case IBRegackMessage:
        case IBConnackMessage:
        case IBPingreqMessage:
        case IBPubcompMessage:
        case IBWillMsgMessage:
        case IBPingrespMessage:
        case IBRegisterMessage:
        case IBSearchGWMessage:
        case IBUnsubackMessage:
        case IBAdvertiseMessage:
        case IBDisconnectMessage:
        case IBWillMsgReqMessage:
        case IBWillMsgUpdMessage:
        case IBWillMsgRespMessage:
        case IBEncapsulatedMessage:
        case IBWillTopicReqMessage:
        case IBWillTopicRespMessage: break;
    }
    
    return [[IBSNFlags alloc] initWithDup:dup qos:qos retainFlag:retainFlag will:will cleanSession:cleanSession topicType:topicType];
}

+ (Byte) encodeWithDup : (BOOL) dup qos : (IBQoS *) qos retainFlag : (BOOL) retainFlag will : (BOOL) will cleanSession : (BOOL) cleanSession topicType : (IBSNTopicType *) topicType {

    Byte flagsByte = 0;
    
    if (dup == true) {
        flagsByte += IBDUplicateFlag;
    }
    if (qos != nil)
        flagsByte += qos.value << 5;
    if (retainFlag == true) {
        flagsByte += IBRetainFlag;
    }
    if (will == true) {
        flagsByte += IBWillFlag;
    }
    if (cleanSession == true) {
        flagsByte += IBCleanSessionFlag;
    }
    if (topicType != nil) {
        flagsByte += topicType.value;
    }
    return flagsByte;
}

- (BOOL)isDup {
    return self->_dup;
}

- (BOOL)isRetainFlag {
    return self->_retainFlag;
}

- (BOOL)isWill {
    return self->_will;
}

- (BOOL)isCleanSession {
    return self->_cleanSession;
}

@end
