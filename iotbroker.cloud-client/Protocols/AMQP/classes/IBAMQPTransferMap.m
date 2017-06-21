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

#import "IBAMQPTransferMap.h"

@implementation IBAMQPTransferMap
{
    NSInteger _index;
}

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        self->_transfers = [NSMutableDictionary dictionary];
        self->_index = 0;
    }
    return self;
}

- (IBAMQPTransfer *) addTransfer : (IBAMQPTransfer *) item {

    NSInteger number = self->_index;

    [self->_transfers setValue:item forKey:[@(self->_index) description]];
    
    [self newIndex];
    
    item.deliveryId = @(number);
    
    return item;
}

- (IBAMQPTransfer *) removeTransferByDeliveryId : (NSInteger) Id {

    NSString *key = [@(Id) description];
    
    IBAMQPTransfer *item = [self->_transfers valueForKey:key];
    
    if (item != nil) {
        //[self->_transfers removeObjectForKey:key];
    }
    return item;
}

#pragma mark - Private methods -

- (void) newIndex {
    
    self->_index++;
    
    if (self->_index == 65535) {
        self->_index = 1;
    }
}

@end
