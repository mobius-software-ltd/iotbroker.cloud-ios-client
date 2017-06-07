//
//  IBAMQPLifetimePolicyObject.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAMQPLifetimePolicy.h"
#import "IBAMQPOutcome.h"
#import "IBAMQPState.h"

@interface IBAMQPLifetimePolicyObject : NSObject <IBAMQPOutcome, IBAMQPState>

@property (assign, nonatomic) IBAMQPLifetimePolicies code;

- (instancetype) initWithCode : (IBAMQPLifetimePolicies) code;

@end
