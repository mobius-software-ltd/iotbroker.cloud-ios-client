//
//  IBSNPublish.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBSNMessage.h"
#import "IBSNTopic.h"

@interface IBSNPublish : NSObject <IBSNMessage>

@property (assign, nonatomic) NSInteger messageID;
@property (strong, nonatomic) id<IBSNTopic> topic;
@property (strong, nonatomic) NSData *content;
@property (assign, nonatomic) BOOL dup;
@property (assign, nonatomic) BOOL retainFlag;

- (instancetype) initWithMessageID : (NSInteger) messageID topic : (id<IBSNTopic>) topic content : (NSData *) content dup : (BOOL) dup retainFlag : (BOOL) retainFlag;

- (BOOL)isDup;
- (BOOL)isRetainFlag;

@end
