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

#import <Foundation/Foundation.h>
#import "IBAMQPTerminusDurability.h"
#import "IBAMQPTerminusExpiryPolicy.h"
#import "IBAMQPSymbol.h"
#import "IBAMQPDistributionMode.h"
#import "IBAMQPOutcome.h"

@interface IBAMQPSource : NSObject

@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) IBAMQPTerminusDurability *durable;
@property (strong, nonatomic) IBAMQPTerminusExpiryPolicy *expiryPeriod;
@property (strong, nonatomic) NSNumber *timeout;
@property (assign, nonatomic) NSNumber *dynamic;
@property (strong, nonatomic) NSMutableDictionary<IBAMQPSymbol *, NSObject *> *dynamicNodeProperties;
@property (strong, nonatomic) IBAMQPDistributionMode *distributionMode;
@property (strong, nonatomic) NSMutableDictionary<IBAMQPSymbol *, NSObject *> *filter;
@property (strong, nonatomic) id<IBAMQPOutcome> defaultOutcome;
@property (strong, nonatomic) NSMutableArray<IBAMQPSymbol *> *outcomes;
@property (strong, nonatomic) NSMutableArray<IBAMQPSymbol *> *capabilities;

- (IBAMQPTLVList *) list;
- (void) fill : (IBAMQPTLVList *) list;

- (void) addDynamicNodeProperties : (NSString *) key value : (NSObject *) value;
- (void) addFilter : (NSString *) key value : (NSObject *) value;
- (void) addOutcomes : (NSArray<NSString *> *) array;
- (void) addCapabilities : (NSArray<NSString *> *) array;

@end
