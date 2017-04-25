//
//  IBSNParser.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBMQTT-SNMessages.h"
#import "IBMutableData.h"

@interface IBSNParser : NSObject

+ (id<IBSNMessage>) decode : (NSMutableData *) data;
+ (NSMutableData *) encode : (id<IBSNMessage>) message;

@end
