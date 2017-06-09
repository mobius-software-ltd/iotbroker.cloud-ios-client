//
//  IBAMQPDisposition.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPHeader.h"
#import "IBAMQPSymbol.h"
#import "IBAMQPRoleCode.h"
#import "IBAMQPState.h"

@interface IBAMQPDisposition : IBAMQPHeader

@property (strong, nonatomic) IBAMQPRoleCode *role;
@property (strong, nonatomic) NSNumber *first;
@property (strong, nonatomic) NSNumber *last;
@property (strong, nonatomic) NSNumber *settled;
@property (strong, nonatomic) id<IBAMQPState> state;
@property (strong, nonatomic) NSNumber *batchable;

@end
