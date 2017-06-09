//
//  IBAMQPParser.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBMutableData.h"
#import "IBAMQPHeader.h"

@interface IBAMQPParser : NSObject

+ (NSInteger) next : (NSMutableData *) buffer;
+ (IBAMQPHeader *) decode : (NSMutableData *) buffer;
+ (NSMutableData *) encode : (IBAMQPHeader *) header;

@end
