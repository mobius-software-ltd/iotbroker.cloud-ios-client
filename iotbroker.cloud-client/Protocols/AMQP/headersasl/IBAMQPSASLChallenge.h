//
//  IBAMQPSASLChallenge.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAMQPHeader.h"
#import "IBMutableData.h"

@interface IBAMQPSASLChallenge : IBAMQPHeader

@property (strong, nonatomic) NSMutableData *challenge;

@end
