//
//  IBSNConnect.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBSNMessage.h"

static NSInteger const IBMQTTSNProtocolID = 1;

@interface IBSNConnect : NSObject <IBSNMessage>

@property (assign, nonatomic) BOOL willPresent;
@property (assign, nonatomic) BOOL cleanSession;
@property (assign, nonatomic) NSInteger protocolID;
@property (assign, nonatomic) NSInteger duration;
@property (strong, nonatomic) NSString *clientID;

- (instancetype) initWithWillPresent : (BOOL) willPresent cleanSession : (BOOL) cleanSession duration : (NSInteger) duration clientID : (NSString *) clientID;

- (BOOL)isWillPresent;
- (BOOL)isCleanSession;

@end
