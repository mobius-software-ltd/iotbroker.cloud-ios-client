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

#import "IBSNValuesValidator.h"

static NSArray *IBReservedPacketIDS = nil;
static NSArray *IBReservedTopicIDS = nil;

@implementation IBSNValuesValidator

+ (BOOL) validatePacketID : (NSInteger) packetID {
    IBReservedPacketIDS = [NSArray arrayWithObjects:@(0x0000), nil];
    return packetID > 0 && ![IBReservedPacketIDS containsObject:@(packetID)];
}

+ (BOOL) validateTopicID : (NSInteger) topicID {
    IBReservedTopicIDS = [NSArray arrayWithObjects:@(0x0000), @(0xFFFF), nil];
    return topicID > 0 && ![IBReservedTopicIDS containsObject:@(topicID)];
}

+ (BOOL) validateRegistrationTopicID : (NSInteger) topicID {
    return topicID >= 0;
}

+ (BOOL) canReadData : (NSMutableData *) data withBytesLeft : (NSInteger) bytesLeft {
    return ([data getByteNumber] < data.length && bytesLeft > 0);
}

+ (BOOL) validateClientID : (NSString *) clientID {
    return (clientID != nil && clientID.length != 0);
}

@end
