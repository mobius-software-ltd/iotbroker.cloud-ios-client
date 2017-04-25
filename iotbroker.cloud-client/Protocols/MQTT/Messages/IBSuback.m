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

#import "IBSuback.h"

@implementation IBSuback

- (instancetype)initWithPacketID:(NSInteger)packetID {
    
    self = [super initWithPacketID:packetID];
    if (self != nil) {
        self.returnCodes = [NSMutableArray array];
    }
    return self;
}

- (IBMessages) getMessageType {
    return IBSubackMessage;
}

- (NSInteger) getLength {
    return 2 + self.returnCodes.count;
}

- (BOOL) isValidCode : (IBSubackCode) code {
    
    if (code == IBAccepted_QoS0 || code == IBAccepted_QoS1 || code == IBAccepted_QoS2) {
        return true;
    }
    return false;
}

@end
