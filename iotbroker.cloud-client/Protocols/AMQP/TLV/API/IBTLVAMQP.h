//
//  IBTLVAMQP.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAMQPSimpleConstructor.h"

@interface IBTLVAMQP : NSObject <NSCopying>

@property (assign, nonatomic) IBAMQPTypes type;
@property (strong, nonatomic) IBAMQPSimpleConstructor *constructor;

@property (strong, nonatomic, readonly) NSMutableData *data;
@property (assign, nonatomic, readonly) NSInteger length;

@property (assign, nonatomic, readonly) BOOL isNull;

@property (strong, nonatomic, readonly) NSMutableData *value;

- (instancetype) initWithConstructor : (IBAMQPSimpleConstructor *) constructor;

@end
