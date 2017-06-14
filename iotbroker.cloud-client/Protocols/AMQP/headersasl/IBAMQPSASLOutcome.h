//
//  IBAMQPSASLOutcome.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPHeader.h"
#import "IBAMQPSASLCode.h"
#import "IBMutableData.h"

@interface IBAMQPSASLOutcome : IBAMQPHeader 

@property (strong, nonatomic) IBAMQPSASLCode *outcomeCode;
@property (strong, nonatomic) NSMutableData *additionalData;

@end
