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

#import "IBAMQPHeader.h"
#import "IBAMQPSymbol.h"

@interface IBAMQPFlow : IBAMQPHeader

@property (strong, nonatomic) NSNumber *nextIncomingId;
@property (strong, nonatomic) NSNumber *incomingWindow;
@property (strong, nonatomic) NSNumber *nextOutgoingId;
@property (strong, nonatomic) NSNumber *outgoingWindow;
@property (strong, nonatomic) NSNumber *handle;
@property (strong, nonatomic) NSNumber *deliveryCount;
@property (strong, nonatomic) NSNumber *linkCredit;
@property (strong, nonatomic) NSNumber *avaliable;
@property (strong, nonatomic) NSNumber *drain;
@property (strong, nonatomic) NSNumber *echo;
@property (strong, nonatomic) NSMutableDictionary<IBAMQPSymbol *, NSObject *> *properties;

- (void) addProperty : (NSString *) key value : (NSObject *) value;

@end
