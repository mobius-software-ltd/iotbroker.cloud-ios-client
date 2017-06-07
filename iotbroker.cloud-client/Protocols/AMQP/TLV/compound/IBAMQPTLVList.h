//
//  IBAMQPTLVList.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBTLVAMQP.h"

@interface IBAMQPTLVList : IBTLVAMQP

@property (assign, nonatomic, readonly) NSInteger width;
@property (assign, nonatomic, readonly) NSInteger size;
@property (assign, nonatomic, readonly) NSInteger count;

@property (strong, nonatomic, readonly) NSMutableArray<IBTLVAMQP *> *list;

- (instancetype)initWithType : (IBAMQPType *) type andValue : (NSArray<IBTLVAMQP *> *) value;

- (void) addElement : (IBTLVAMQP *) element;
- (void) setElementWithIndex : (NSInteger) index element : (IBTLVAMQP *) element;
- (void) addElementWithIndex : (NSInteger) index element : (IBTLVAMQP *) element;
- (void) addToListWithIndex : (NSInteger) index elementIndex : (NSInteger) elementIndex element : (IBTLVAMQP *) element;
- (void) addToMapWithIndex : (NSInteger) index key : (IBTLVAMQP *) key value : (IBTLVAMQP *) value;
- (void) addToArrayWithIndex : (NSInteger) index element : (IBTLVAMQP *) element;

@end
