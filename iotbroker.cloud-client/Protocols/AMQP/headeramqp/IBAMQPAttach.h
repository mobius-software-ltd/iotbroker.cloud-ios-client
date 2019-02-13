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
#import "IBAMQPRoleCode.h"
#import "IBAMQPSendCode.h"
#import "IBAMQPReceiverSettleMode.h"
#import "IBAMQPSource.h"
#import "IBAMQPTarget.h"

@interface IBAMQPAttach : IBAMQPHeader

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *handle;
@property (strong, nonatomic) IBAMQPRoleCode *role;
@property (strong, nonatomic) IBAMQPSendCode *sendCodes;
@property (strong, nonatomic) IBAMQPReceiverSettleMode *receivedCodes;
@property (strong, nonatomic) IBAMQPSource *source;
@property (strong, nonatomic) IBAMQPTarget *target;
@property (strong, nonatomic) NSMutableDictionary<IBAMQPSymbol *, NSObject *> *unsettled;
@property (strong, nonatomic) NSNumber *incompleteUnsettled;
@property (strong, nonatomic) NSNumber *initialDeliveryCount;
@property (strong, nonatomic) NSNumber *maxMessageSize;
@property (strong, nonatomic) NSMutableArray<IBAMQPSymbol *> *offeredCapabilities;
@property (strong, nonatomic) NSMutableArray<IBAMQPSymbol *> *desiredCapabilities;
@property (strong, nonatomic) NSMutableDictionary<IBAMQPSymbol *, NSObject *> *properties;

- (void) addUnsettled : (NSString *) key value : (NSObject *) value;
- (void) addOfferedCapability : (NSArray<NSString *> *) array;
- (void) addDesiredCapability : (NSArray<NSString *> *) array;
- (void) addProperty : (NSString *) key value : (NSObject *) value;

@end
