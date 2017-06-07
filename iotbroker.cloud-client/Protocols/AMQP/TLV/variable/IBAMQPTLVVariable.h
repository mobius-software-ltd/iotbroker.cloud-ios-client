//
//  IBAMQPTLVVariable.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBTLVAMQP.h"

@interface IBAMQPTLVVariable : IBTLVAMQP

@property (assign, nonatomic) NSInteger width;

- (instancetype) initWithType : (IBAMQPType *) type andValue : (NSMutableData *) value;

@end
