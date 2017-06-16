//
//  IBAMQPSimpleType.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 16.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAMQPType.h"

@interface IBAMQPSimpleType : NSObject

@property (strong, nonatomic) id value;
@property (assign, nonatomic) IBAMQPTypes type;

+ (instancetype) simpleType : (IBAMQPTypes) type withValue : (id) value;

- (instancetype) initSimpleType : (IBAMQPTypes) type withValue : (id) value;

@end
