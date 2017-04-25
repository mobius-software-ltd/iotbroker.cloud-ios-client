//
//  IBSNValuesValidator.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBSNValuesValidator.h"

static NSArray *IBReservedMessageIDS = nil;
static NSArray *IBReservedTopicIDS = nil;

@implementation IBSNValuesValidator

+ (BOOL) validateMessageID : (NSInteger) messageID {
    IBReservedMessageIDS = [NSArray arrayWithObjects:@(0x0000), nil];
    return messageID > 0 && ![IBReservedMessageIDS containsObject:@(messageID)];
}

+ (BOOL) validateTopicID : (NSInteger) topicID {
    IBReservedTopicIDS = [NSArray arrayWithObjects:@(0x0000), @(0xFFFF), nil];
    return topicID > 0 && ![IBReservedTopicIDS containsObject:@(topicID)];
}

+ (BOOL) validateRegistrationTopicID : (NSInteger) topicID {
    return topicID >= 0;
}

+ (BOOL) canReadData : (NSMutableData *) data withBytesLeft : (NSInteger) bytesLeft {
    return ([data getByteNumber] < data.length && bytesLeft > 0);
}

+ (BOOL) validateClientID : (NSString *) clientID {
    return (clientID != nil && clientID.length != 0);
}

@end
