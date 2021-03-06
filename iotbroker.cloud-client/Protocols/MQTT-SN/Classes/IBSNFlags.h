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
#import <Foundation/Foundation.h>
#import "IBMQTT-SNEnums.h"
#import "IBMessage.h"
#import "IBTopic.h"
#import "IBQoS.h"

typedef NS_ENUM(NSInteger, IBSNFlag)
{
    IBDUplicateFlag     = 128,
    IBQoSLevelOneFlag   = 96,
    IBQoS2Flag          = 64,
    IBQoS1Flag          = 32,
    IBRetainFlag        = 16,
    IBWillFlag          = 8,
    IBCleanSessionFlag  = 4,
    IBReservedTopicFlag = 3,
    IBShortTopicFlag    = 2,
    IBIdTopicFlag       = 1,
};

@interface IBSNFlags : NSObject

@property (assign, nonatomic) BOOL dup;
@property (strong, nonatomic) IBQoS *qos;
@property (assign, nonatomic) BOOL retainFlag;
@property (assign, nonatomic) BOOL will;
@property (assign, nonatomic) BOOL cleanSession;
@property (strong, nonatomic) IBSNTopicType *topicType;

- (instancetype) initWithDup : (BOOL) dup qos : (IBQoS *) qos retainFlag : (BOOL) retainFlag will : (BOOL) will cleanSession : (BOOL) cleanSession topicType : (IBSNTopicType *) topicType;

+ (IBSNFlags *) decodeWithData : (Byte) flagsByte andMessageType : (IBSNMessages) type;
+ (IBSNFlags *) validateAndCreate : (NSArray *) bitMask andType : (IBSNMessages) type;
+ (Byte) encodeWithDup : (BOOL) dup qos : (IBQoS *) qos retainFlag : (BOOL) retainFlag will : (BOOL) will cleanSession : (BOOL) cleanSession topicType : (IBSNTopicType *) topicType;

- (BOOL)isDup;
- (BOOL)isRetainFlag;
- (BOOL)isWill;
- (BOOL)isCleanSession;

@end
