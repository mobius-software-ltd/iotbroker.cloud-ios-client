//
//  IBSNIdentifierTopic.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBSNTopic.h"
#import "IBSNQoS.h"

@interface IBSNIdentifierTopic : NSObject <IBSNTopic>

@property (assign, nonatomic) NSInteger value;
@property (strong, nonatomic) IBSNQoS *qos;

- (instancetype) initWithValue : (NSInteger) value andQoS : (IBSNQoS *) qos;

@end
