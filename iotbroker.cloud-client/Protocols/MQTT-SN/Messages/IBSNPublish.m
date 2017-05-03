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

#import "IBSNPublish.h"

@implementation IBSNPublish

- (instancetype) initWithPacketID: (NSInteger) packetID topic : (id<IBTopic>) topic content : (NSData *) content dup : (BOOL) dup retainFlag : (BOOL) retainFlag {
    self = [super init];
    if (self != nil) {
        self->_packetID = packetID;
        self->_topic = topic;
        self->_content = content;
        self->_dup = dup;
        self->_retainFlag = retainFlag;
    }
    return self;
}

- (NSInteger)getLength {
    NSInteger length = 7;
    length += self->_content.length;
    if (self->_content.length > 248) {
        length += 2;
    }
    return length;
}

- (NSInteger)getMessageType {
    return IBPublishMessage;
}

- (BOOL)isDup {
    return self->_dup;
}

- (BOOL)isRetainFlag {
    return self->_retainFlag;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n - packetID = %zd\n - topic = %@\n - content = %@\n - dup = %@\n - retainFlag = %@", self->_packetID, self->_topic, [[NSString alloc] initWithData:self->_content encoding:NSUTF8StringEncoding], self->_dup?@"yes":@"no", self->_retainFlag?@"yes":@"no"];
}

@end
