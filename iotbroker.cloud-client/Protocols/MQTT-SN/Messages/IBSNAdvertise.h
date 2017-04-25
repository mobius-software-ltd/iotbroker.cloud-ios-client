//
//  IBSNAdvertise.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBSNMessage.h"

@interface IBSNAdvertise : NSObject <IBSNMessage>

@property (assign, nonatomic) NSInteger gwID;
@property (assign, nonatomic) NSInteger duration;

- (instancetype) initWithGatewayID : (NSInteger) gwID andDuration : (NSInteger) duration;

@end
