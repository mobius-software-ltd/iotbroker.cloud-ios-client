//
//  IBAMQPClose.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPHeader.h"
#import "IBAMQPError.h"

@interface IBAMQPClose : IBAMQPHeader

@property (strong, nonatomic) IBAMQPError *error;

@end
