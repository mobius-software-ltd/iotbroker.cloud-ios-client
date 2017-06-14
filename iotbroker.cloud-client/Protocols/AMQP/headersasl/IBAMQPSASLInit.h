//
//  IBAMQPSASLInit.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPHeader.h"
#import "IBAMQPSymbol.h"
#import "IBMutableData.h"

@interface IBAMQPSASLInit : IBAMQPHeader 

@property (strong, nonatomic) IBAMQPSymbol *mechanism;
@property (strong, nonatomic) NSMutableData *initialResponse;
@property (strong, nonatomic) NSString *hostName;

@end
