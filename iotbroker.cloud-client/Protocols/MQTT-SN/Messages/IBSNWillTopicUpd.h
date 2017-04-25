//
//  IBSNWillTopicUpd.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBSNFullTopic.h"
#import "IBSNMessage.h"

@interface IBSNWillTopicUpd : NSObject <IBSNMessage>

@property (assign, nonatomic) BOOL retainFlag;
@property (strong, nonatomic) IBSNFullTopic *topic;

- (instancetype) initWithTopic : (IBSNFullTopic *) topic andRetainFlag : (BOOL) retainFlag;

- (BOOL)isRetainFlag;

@end
