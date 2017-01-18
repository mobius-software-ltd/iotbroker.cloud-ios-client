/**
 * Mobius Software LTD
 * Copyright 2015-2016, Mobius Software LTD
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
#import "IBLengthDetails.h"
#import "IBMutableData.h"

#import "IBMessage.h"

#import "IBConnect.h"
#import "IBConnack.h"
#import "IBPublish.h"
#import "IBPuback.h"
#import "IBPubrec.h"
#import "IBPubrel.h"
#import "IBPubcomp.h"
#import "IBSubscribe.h"
#import "IBSuback.h"
#import "IBUnsubscribe.h"
#import "IBUnsuback.h"
#import "IBPingreq.h"
#import "IBPingresp.h"
#import "IBDisconnect.h"

@interface IBParser : NSObject

- (NSMutableData *) next : (NSMutableData *) buffer;

- (NSMutableData *) encode : (id<IBMessage>) message;
- (id<IBMessage>) decode : (NSMutableData *) buffer;

@end