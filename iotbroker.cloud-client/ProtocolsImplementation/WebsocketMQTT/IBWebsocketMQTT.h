//
//  IBWebsocketMQTT.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 02.08.2018.
//  Copyright © 2018 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBRequests.h"
#import "IBResponsesDelegate.h"
#import "IBInternetProtocol.h"

@interface IBWebsocketMQTT : NSObject <IBRequests>

@property (weak, nonatomic, readonly) id<IBResponsesDelegate> delegate;
@property (strong, nonatomic, readonly) id<IBInternetProtocol> internetProtocol;

- (instancetype) initWithHost : (NSString *) host port : (NSInteger) port andResponseDelegate : (id<IBResponsesDelegate>) delegate;

@end
