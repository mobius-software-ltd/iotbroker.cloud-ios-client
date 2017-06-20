//
//  IBAMQPTransferMap.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 20.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAMQPTransfer.h"

@interface IBAMQPTransferMap : NSObject

@property (strong, nonatomic) NSMutableDictionary *transfers;

- (IBAMQPTransfer *) addTransfer : (IBAMQPTransfer *) item;
- (IBAMQPTransfer *) removeTransferByDeliveryId : (NSInteger) Id;

@end
