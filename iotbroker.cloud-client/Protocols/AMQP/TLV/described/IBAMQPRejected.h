//
//  IBAMQPRejected.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAMQPOutcome.h"
#import "IBAMQPState.h"
#import "IBAMQPError.h"

@interface IBAMQPRejected : NSObject <IBAMQPOutcome, IBAMQPState>

@property (strong, nonatomic) IBAMQPError *error;

@end
