//
//  IBAMQPDescribedConstructor.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPSimpleConstructor.h"
#import "IBTLVAMQP.h"

@interface IBAMQPDescribedConstructor : IBAMQPSimpleConstructor

@property (strong, nonatomic) IBTLVAMQP *descriptor;

- (instancetype) initWithType:(IBAMQPType *)type andDescriptor:(IBTLVAMQP *)descriptor;

@end
