//
//  IBAMQPSection.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAMQPSectionCode.h"
#import "IBTLVAMQP.h"

@protocol IBAMQPSection <NSObject>

@property (strong, nonatomic, readonly) IBTLVAMQP *value;
@property (strong, nonatomic, readonly) IBAMQPSectionCode *code;

- (void) fill : (IBTLVAMQP *) value;

@end
