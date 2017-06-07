//
//  IBAMQPState.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAMQPTLVList.h"

@protocol IBAMQPState <NSObject>

@property (strong, nonatomic, readonly) IBAMQPTLVList *list;

- (void) fill : (IBAMQPTLVList *) list;

@end
