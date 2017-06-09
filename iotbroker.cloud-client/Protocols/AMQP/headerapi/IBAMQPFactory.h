//
//  IBAMQPFactory.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 08.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAMQPOutcome.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPState.h"
#import "IBAMQPHeader.h"
#import "IBMutableData.h"
#import "IBAMQPSection.h"

@interface IBAMQPFactory : NSObject

+ (IBAMQPHeader *) amqp : (NSMutableData *) data;
+ (IBAMQPHeader *) sasl : (NSMutableData *) data;
+ (id<IBAMQPSection>) section : (NSMutableData *) data;
+ (id<IBAMQPState>) state : (IBAMQPTLVList *) list;
+ (id<IBAMQPOutcome>) outcome : (IBAMQPTLVList *) list;

@end
