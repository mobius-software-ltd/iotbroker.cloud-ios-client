//
//  IBAMQPSimpleConstructor.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAMQPType.h"
#import "IBMutableData.h"

@interface IBAMQPSimpleConstructor : NSObject

@property (assign, nonatomic) IBAMQPType *type;
@property (strong, nonatomic, readonly) NSMutableData *data;
@property (assign, nonatomic, readonly) NSInteger length;
@property (assign, nonatomic, readonly) Byte descriptorCode;

- (instancetype) initWithType : (IBAMQPType *) type;

@end
