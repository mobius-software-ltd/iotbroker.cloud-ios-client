//
//  IBAMQPDistributionMode.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IBAMQPDistributionModes)
{
    IBAMQPMoveDistributionMode = 0,
    IBAMQPCopyDistributionMode = 1,
};

@interface IBAMQPDistributionMode : NSObject

@property (assign, nonatomic) IBAMQPDistributionModes value;

- (instancetype) initWithDistributionMode : (IBAMQPDistributionModes) type;
+ (instancetype) enumWithDistributionMode : (IBAMQPDistributionModes) type;

- (NSString *) nameByValue;
- (IBAMQPDistributionModes) valueByName : (NSString *) name;

- (NSDictionary *) items;

@end
