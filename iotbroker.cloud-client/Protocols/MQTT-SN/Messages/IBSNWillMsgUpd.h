//
//  IBSNWillMsgUpd.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBSNMessage.h"

@interface IBSNWillMsgUpd : NSObject <IBSNMessage>

@property (strong, nonatomic) NSData *content;

- (instancetype) initWithContent : (NSData *) content;

@end
