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
#import "IBAMQPOutcome.h"
#import "IBAMQPTLVList.h"
#import "IBAMQPState.h"
#import "IBAMQPHeader.h"
#import "IBMutableData.h"
#import "IBAMQPSection.h"
#import "IBAMQPAttach.h"
#import "IBAMQPBegin.h"
#import "IBAMQPClose.h"
#import "IBAMQPDetach.h"
#import "IBAMQPDisposition.h"
#import "IBAMQPEnd.h"
#import "IBAMQPFlow.h"
#import "IBAMQPOpen.h"
#import "IBAMQPTransfer.h"
#import "IBAMQPSASLChallenge.h"
#import "IBAMQPSASLInit.h"
#import "IBAMQPSASLMechanisms.h"
#import "IBAMQPSASLOutcome.h"
#import "IBAMQPSASLResponse.h"
#import "IBAMQPApplicationProperties.h"
#import "IBAMQPData.h"
#import "IBAMQPDeliveryAnnotation.h"
#import "IBAMQPFooter.h"
#import "IBAMQPMessageHeader.h"
#import "IBAMQPMessageAnnotations.h"
#import "IBAMQPProperties.h"
#import "IBAMQPSequence.h"
#import "IBAMQPValue.h"
#import "IBAMQPStateCode.h"
#import "IBAMQPAccepted.h"
#import "IBAMQPModified.h"
#import "IBAMQPReceived.h"
#import "IBAMQPRejected.h"
#import "IBAMQPReleased.h"

@interface IBAMQPFactory : NSObject

+ (IBAMQPHeader *) amqp : (NSMutableData *) data;
+ (IBAMQPHeader *) sasl : (NSMutableData *) data;
+ (id<IBAMQPSection>) section : (NSMutableData *) data;
+ (id<IBAMQPState>) state : (IBAMQPTLVList *) list;
+ (id<IBAMQPOutcome>) outcome : (IBAMQPTLVList *) list;

@end
