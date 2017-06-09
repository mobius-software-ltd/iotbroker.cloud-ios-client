//
//  IBAMQPMessageHeader.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAMQPSection.h"
#import "IBAMQPSymbol.h"

@interface IBAMQPMessageHeader : NSObject <IBAMQPSection>

@property (strong, nonatomic) NSNumber *durable;
@property (strong, nonatomic) NSNumber *priority;
@property (strong, nonatomic) NSNumber *milliseconds;
@property (strong, nonatomic) NSNumber *firstAquirer;
@property (strong, nonatomic) NSNumber *deliveryCount;

@end
