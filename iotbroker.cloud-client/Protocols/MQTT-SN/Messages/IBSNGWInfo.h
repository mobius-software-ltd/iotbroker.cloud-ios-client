//
//  IBSNGWInfo.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBSNMessage.h"

@interface IBSNGWInfo : NSObject <IBSNMessage>

@property (assign, nonatomic) NSInteger gwID;
@property (strong, nonatomic) NSString *gwAddress;

- (instancetype) initWithGatewayID : (NSInteger) gwID andGatewayAddress : (NSString *) gwAddress;

@end
