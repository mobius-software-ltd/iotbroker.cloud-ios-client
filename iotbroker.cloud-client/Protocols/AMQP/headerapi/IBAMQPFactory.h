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

@interface IBAMQPFactory : NSObject

+ (id<IBAMQPOutcome>) outcome : (IBAMQPTLVList *) list;

@end
