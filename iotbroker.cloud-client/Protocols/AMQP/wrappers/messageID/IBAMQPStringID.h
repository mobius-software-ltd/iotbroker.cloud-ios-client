//
//  IBAMQPStringID.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAMQPMessageID.h"

@interface IBAMQPStringID : NSObject <IBAMQPMessageID>

@property (strong, nonatomic) NSString *iD;

- (instancetype) initWithStringID : (NSString *) stringID;

@end
