//
//  IBSNSubscribe.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBSNMessage.h"
#import "IBSNTopic.h"

@interface IBSNSubscribe : NSObject <IBSNMessage>

@property (assign, nonatomic) NSInteger messageID;
@property (strong, nonatomic) id<IBSNTopic> topic;
@property (assign, nonatomic) BOOL dup;

- (instancetype) initWithMessageID : (NSInteger) messageID topic : (id<IBSNTopic>) topic dup : (BOOL) dup;

- (BOOL)isDup;

@end
