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
#import "IBAMQPSection.h"
#import "IBAMQPMessageID.h"
#import "IBMutableData.h"

@interface IBAMQPProperties : NSObject <IBAMQPSection>

@property (strong, nonatomic) id<IBAMQPMessageID> messageID;
@property (strong, nonatomic) NSMutableData *userID;
@property (strong, nonatomic) NSString *to;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *replyTo;
@property (strong, nonatomic) NSMutableData *correlationID;
@property (strong, nonatomic) NSString *contentType;
@property (strong, nonatomic) NSString *contentEncoding;
@property (strong, nonatomic) NSDate *absoluteExpiryTime;
@property (strong, nonatomic) NSDate *creationTime;
@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) NSNumber *groupSequence;
@property (strong, nonatomic) NSString *replyToGroupId;

@end
