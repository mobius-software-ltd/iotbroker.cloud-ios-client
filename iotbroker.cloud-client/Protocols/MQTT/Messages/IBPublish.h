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

#import "IBCountableMessage.h"
#import "IBMQTTTopic.h"

@interface IBPublish : IBCountableMessage

@property (strong, nonatomic) IBMQTTTopic *topic;
@property (strong, nonatomic) NSData<Ignore> *content;
@property (assign, nonatomic) BOOL isRetain;
@property (assign, nonatomic) BOOL dup;

- (instancetype) initWithPacketID : (NSInteger) packetID andTopic : (IBMQTTTopic *) topic andContent : (NSData *) data andIsRetain : (BOOL) isRetain andDup : (BOOL) dup;

@end
