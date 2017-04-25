//
//  IBSNCountableMessage.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBSNMessage.h"

@interface IBSNCountableMessage : NSObject <IBSNMessage>

@property (assign, nonatomic) NSInteger messageID;

- (instancetype) initWithMessageID : (NSInteger) messageID;

@end
