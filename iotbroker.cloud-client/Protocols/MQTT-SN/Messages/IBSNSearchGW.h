//
//  IBSNSearchGW.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBSNMessage.h"

@interface IBSNSearchGW : NSObject <IBSNMessage>

@property (assign, nonatomic) IBSNRadius radius;

- (instancetype) initWithRadius : (IBSNRadius) radius;

@end
