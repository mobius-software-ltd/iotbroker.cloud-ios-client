//
//  IBAMQPTLVMap.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBTLVAMQP.h"

@interface IBAMQPTLVMap : IBTLVAMQP

@property (assign, nonatomic, readonly) NSInteger width;
@property (assign, nonatomic, readonly) NSInteger size;
@property (assign, nonatomic, readonly) NSInteger count;

@property (strong, atomic, readonly) NSMutableDictionary<IBTLVAMQP *, IBTLVAMQP *> *map;

- (instancetype)initWithType : (IBAMQPType *) type andMap : (NSDictionary<IBTLVAMQP *, IBTLVAMQP *> *) map;

- (void) putElementWithKey : (IBTLVAMQP *) key andValue : (IBTLVAMQP *) value;

@end
