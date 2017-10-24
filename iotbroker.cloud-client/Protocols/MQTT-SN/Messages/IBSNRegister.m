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

#import "IBSNRegister.h"

@implementation IBSNRegister

- (instancetype) initWithTopicID : (NSInteger) topicID packetID : (NSInteger) packetID andTopicName : (NSString *) topicName {
    self = [super initWithPacketID:packetID];
    if (self != nil) {
        self->_topicID = topicID;
        self->_topicName = topicName;
    }
    return self;
}

- (NSInteger)getLength {
    if (self->_topicName.length == 0) {
        @throw [NSException exceptionWithName:@"Exception" reason:[NSString stringWithFormat:@"%@ must contain a valid topic name", [[self class] description]] userInfo:nil];
    }
    NSInteger length = 6;
    length += self->_topicName.length;
    if (self->_topicName.length > 249) {
        length += 2;
    }
    return length;
}

- (NSInteger)getMessageType {
    return IBRegisterMessage;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n - topicID = %zd\n - packetID = %zd\n - topicName = %@", self->_topicID, self.packetID, self->_topicName];
}

@end
