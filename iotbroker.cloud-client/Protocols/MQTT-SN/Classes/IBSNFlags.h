//
//  IBSNFlags.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBSNMessage.h"
#import "IBSNTopic.h"
#import "IBSNQoS.h"

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
@property (strong, nonatomic) IBSNQoS *qos;
@property (assign, nonatomic) BOOL retainFlag;
@property (assign, nonatomic) BOOL will;
@property (assign, nonatomic) BOOL cleanSession;
@property (strong, nonatomic) IBSNTopicType *topicType;

- (instancetype) initWithDup : (BOOL) dup qos : (IBSNQoS *) qos retainFlag : (BOOL) retainFlag will : (BOOL) will cleanSession : (BOOL) cleanSession topicType : (IBSNTopicType *) topicType;

+ (IBSNFlags *) decodeWithData : (Byte) flagsByte andMessageType : (IBSNMessages) type;
+ (IBSNFlags *) validateAndCreate : (NSArray *) bitMask andType : (IBSNMessages) type;
+ (Byte) encodeWithDup : (BOOL) dup qos : (IBSNQoS *) qos retainFlag : (BOOL) retainFlag will : (BOOL) will cleanSession : (BOOL) cleanSession topicType : (IBSNTopicType *) topicType;

- (BOOL)isDup;
- (BOOL)isRetainFlag;
- (BOOL)isWill;
- (BOOL)isCleanSession;

@end
