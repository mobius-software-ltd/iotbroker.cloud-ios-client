//
//  IBAMQPMessageID.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBMutableData.h"

@protocol IBAMQPMessageID <NSObject>

@property (strong, nonatomic, readonly) NSString *string;
@property (strong, nonatomic, readonly) NSMutableData *binary;
@property (strong, nonatomic, readonly) NSNumber *longValue;
@property (strong, nonatomic, readonly) NSUUID *uuid;

@end
