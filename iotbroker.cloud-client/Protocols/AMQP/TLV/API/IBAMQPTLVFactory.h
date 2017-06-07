//
//  IBAMQPTLVFactory.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBTLVAMQP.h"

@interface IBAMQPTLVFactory : NSObject

+ (IBTLVAMQP *) tlvByData : (NSMutableData *) data;

@end
