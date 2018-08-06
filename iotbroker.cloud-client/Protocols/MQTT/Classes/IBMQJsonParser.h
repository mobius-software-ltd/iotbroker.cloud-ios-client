//
//  IBMQJsonParser.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 02.08.2018.
//  Copyright © 2018 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBMessage.h"

@interface IBMQJsonParser : NSObject

+ (NSData *)json: (id<IBMessage>)message;
+ (id<IBMessage>)message: (NSData *)json;

@end
