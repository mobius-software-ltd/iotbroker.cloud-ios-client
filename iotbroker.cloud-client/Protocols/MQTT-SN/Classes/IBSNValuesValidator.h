//
//  IBSNValuesValidator.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBMutableData.h"

@interface IBSNValuesValidator : NSObject

+ (BOOL) validateMessageID : (NSInteger) messageID;
+ (BOOL) validateTopicID : (NSInteger) topicID;
+ (BOOL) validateRegistrationTopicID : (NSInteger) topicID;
+ (BOOL) canReadData : (NSMutableData *) data withBytesLeft : (NSInteger) bytesLeft;
+ (BOOL) validateClientID : (NSString *) clientID;

@end
