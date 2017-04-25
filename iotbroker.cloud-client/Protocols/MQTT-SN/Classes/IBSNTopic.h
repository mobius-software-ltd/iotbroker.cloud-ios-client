//
//  IBSNTopic.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBSNTopicType.h"
#import "IBSNQoS.h"

@protocol IBSNTopic <NSObject>

- (IBSNTopicType *) getType;
- (IBSNQoS *) getQoS;
- (NSData *) encode;
- (NSInteger) length;

@end
