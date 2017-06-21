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
#import "IBMutableData.h"
#import "IBAMQPMessageFormat.h"
#import "IBAMQPReceiverSettleMode.h"
#import "IBAMQPState.h"
#import "IBAMQPSectionCode.h"
#import "IBAMQPSection.h"

@interface IBAMQPTransfer : IBAMQPHeader

@property (strong, nonatomic) NSNumber *handle;
@property (strong, nonatomic) NSNumber *deliveryId;
@property (strong, nonatomic) NSMutableData *deliveryTag;
@property (strong, nonatomic) IBAMQPMessageFormat *messageFormat;
@property (strong, nonatomic) NSNumber *settled;
@property (strong, nonatomic) NSNumber *more;
@property (strong, nonatomic) IBAMQPReceiverSettleMode *rcvSettleMode;
@property (strong, nonatomic) id<IBAMQPState> state;
@property (strong, nonatomic) NSNumber *resume;
@property (strong, nonatomic) NSNumber *aborted;
@property (strong, nonatomic) NSNumber *batchable;
@property (strong, nonatomic) NSMutableDictionary<IBAMQPSectionCode *, id<IBAMQPSection>> *sections;

- (id<IBAMQPSection>) header;
- (id<IBAMQPSection>) deliveryAnnotations;
- (id<IBAMQPSection>) messageAnnotations;
- (id<IBAMQPSection>) properties;
- (id<IBAMQPSection>) applicationProperties;
- (id<IBAMQPSection>) data;
- (id<IBAMQPSection>) sequence;
- (id<IBAMQPSection>) value;
- (id<IBAMQPSection>) footer;

- (void) addSections : (NSArray<id<IBAMQPSection>> *) array;

@end
