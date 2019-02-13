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

#import "IBSNSubscribe.h"

@implementation IBSNSubscribe

- (instancetype) initWithPacketID : (NSInteger) packetID topic : (id<IBTopic>) topic dup : (BOOL) dup {
    self = [super initWithPacketID:packetID];
    if (self != nil) {
        self->_topic = topic;
        self->_dup = dup;
    }
    return self;
}

- (NSInteger)getLength {
    NSInteger length = 5;
    length += [self->_topic length];
    if ([self->_topic length] > 250) {
        length += 2;
    }
    return length;
}

- (NSInteger)getMessageType {
    return IBSubscribeMessage;
}

- (BOOL)isDup {
    return self->_dup;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n - packetID = %@\n - topic = %@\n - dup = %@", self.packetID, self->_topic, self->_dup?@"yes":@"no"];
}

@end
