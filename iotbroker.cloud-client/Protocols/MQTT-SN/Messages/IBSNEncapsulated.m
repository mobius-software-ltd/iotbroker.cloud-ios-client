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

#import "IBSNEncapsulated.h"

@implementation IBSNEncapsulated

- (instancetype) initWithRadius : (IBSNRadius) radius wirelessNodeID : (NSString *) wirelessNodeID andMessage : (id<IBMessage>) message {
    self = [super init];
    if (self != nil) {
        self->_radius = radius;
        self->_wirelessNodeID = wirelessNodeID;
        self->_message = message;
    }
    return self;
}

- (NSInteger)getLength {
    NSInteger length = 3;
    if (self->_wirelessNodeID.length != 0) {
        length += self->_wirelessNodeID.length;
    }
    return length;
}

- (NSInteger)getMessageType {
    return IBEncapsulatedMessage;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\n - radius = %zd\n - wirelessNodeID = %@\n - message = %@", self->_radius, self->_wirelessNodeID, self->_message];
}

@end
