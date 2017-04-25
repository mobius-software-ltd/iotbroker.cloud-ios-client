//
//  IBSNShortTopic.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBSNTopic.h"
#import "IBSNQoS.h"

@interface IBSNShortTopic : NSObject <IBSNTopic>

@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) IBSNQoS *qos;

- (instancetype) initWithValue : (NSString *) value andQoS : (IBSNQoS *) qos;

@end
