/**
 * Mobius Software LTD
 * Copyright 2015-2017, Mobius Software LTD
 *
 * This is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 2.1 of
 * the License, or (at your option) any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this software; if not, write to the Free
 * Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA, or see the FSF site: http://www.fsf.org.
 */

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
