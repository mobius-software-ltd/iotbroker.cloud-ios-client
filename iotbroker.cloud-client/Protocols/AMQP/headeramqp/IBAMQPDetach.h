//
//  IBAMQPDetach.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPHeader.h"
#import "IBAMQPError.h"

@interface IBAMQPDetach : IBAMQPHeader

@property (strong, nonatomic) NSNumber *handle;
@property (strong, nonatomic) NSNumber *closed;
@property (strong, nonatomic) IBAMQPError *error;

@end
