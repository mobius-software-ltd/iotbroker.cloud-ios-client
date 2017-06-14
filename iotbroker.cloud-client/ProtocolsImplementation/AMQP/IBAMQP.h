//
//  IBAMQP.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 14.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBRequests.h"
#import "IBResponsesDelegate.h"
#import "IBInternetProtocol.h"

@interface IBAMQP : NSObject <IBRequests>

@property (weak, nonatomic, readonly) id<IBResponsesDelegate> delegate;
@property (strong, nonatomic, readonly) id<IBInternetProtocol> internetProtocol;

- (instancetype) initWithHost : (NSString *) host port : (NSInteger) port andResponseDelegate : (id<IBResponsesDelegate>) delegate;

@end
