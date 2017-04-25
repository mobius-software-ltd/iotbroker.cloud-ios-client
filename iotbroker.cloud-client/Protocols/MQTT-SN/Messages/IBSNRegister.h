//
//  IBSNRegister.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBSNMessage.h"

@interface IBSNRegister : NSObject <IBSNMessage>

@property (assign, nonatomic) NSInteger topicID;
@property (assign, nonatomic) NSInteger messageID;
@property (strong, nonatomic) NSString *topicName;

- (instancetype) initWithTopicID : (NSInteger) topicID messageID : (NSInteger) messageID andTopicName : (NSString *) topicName;

@end
