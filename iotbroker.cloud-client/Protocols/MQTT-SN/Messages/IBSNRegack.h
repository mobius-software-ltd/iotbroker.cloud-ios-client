//
//  IBSNRegack.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBSNCountableMessage.h"

@interface IBSNRegack : IBSNCountableMessage

@property (assign, nonatomic) NSInteger topicID;
@property (assign, nonatomic) IBSNReturnCode returnCode;

- (instancetype) initWithTopicID : (NSInteger) topicID messageID : (NSInteger) messageID returnCode : (IBSNReturnCode) returnCode;

@end
