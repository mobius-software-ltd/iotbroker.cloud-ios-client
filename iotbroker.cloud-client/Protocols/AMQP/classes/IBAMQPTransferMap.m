//
//  IBAMQPTransferMap.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 20.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

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
