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

#import "IBSNWillTopicUpd.h"

@implementation IBSNWillTopicUpd

- (instancetype) initWithTopic : (IBSNFullTopic *) topic andRetainFlag : (BOOL) retainFlag {
    self = [super init];
    if (self != nil) {
        self->_topic = topic;
        self->_retainFlag = retainFlag;
    }
    return self;
}

- (NSInteger)getLength {
    NSInteger length = 2;
    if (self->_topic != nil) {
        length += self->_topic.length + 1;
        if (self->_topic.length > 252) {
            length += 2;
        }
    }
    return length;
}

- (NSInteger)getMessageType {
    return IBWillTopicUpdMessage;
}

- (BOOL)isRetainFlag {
    return self->_retainFlag;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n - topic = %@\n retainFlag = %@", self->_topic, self->_retainFlag?@"yes":@"no"];
}

@end
