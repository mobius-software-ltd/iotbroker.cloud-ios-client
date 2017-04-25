//
//  IBSNEncapsulated.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBSNMessage.h"

@interface IBSNEncapsulated : NSObject <IBSNMessage>

@property (assign, nonatomic) IBSNRadius radius;
@property (strong, nonatomic) NSString *wirelessNodeID;
@property (strong, nonatomic) id<IBSNMessage> message;

- (instancetype) initWithRadius : (IBSNRadius) radius wirelessNodeID : (NSString *) wirelessNodeID andMessage : (id<IBSNMessage>) message;

@end
