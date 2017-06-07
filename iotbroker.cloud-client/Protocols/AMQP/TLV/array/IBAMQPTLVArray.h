//
//  IBAMQPTLVArray.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBTLVAMQP.h"

@interface IBAMQPTLVArray : IBTLVAMQP

@property (assign, nonatomic, readonly) NSInteger width;
@property (assign, nonatomic, readonly) NSInteger size;
@property (assign, nonatomic, readonly) NSInteger count;

@property (strong, nonatomic, readonly) NSMutableArray<IBTLVAMQP *> *elements;

@property (strong, nonatomic, readonly) IBAMQPSimpleConstructor *elementContructor;

- (instancetype) initWithType : (IBAMQPType *) type andElements : (NSArray<IBTLVAMQP *> *) elements;

- (void) addElement : (IBTLVAMQP *) element;

@end
