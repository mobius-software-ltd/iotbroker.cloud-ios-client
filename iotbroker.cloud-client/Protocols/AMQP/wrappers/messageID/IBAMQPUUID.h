//
//  IBAMQPUUID.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAMQPMessageID.h"

@interface IBAMQPUUID : NSObject <IBAMQPMessageID>

@property (strong, nonatomic) NSUUID *iD;

- (instancetype) initWithUUID : (NSUUID *) uuid;

@end
