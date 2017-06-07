//
//  IBAMQPTerminusDurability.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IBAMQPTerminusDurabilities)
{
    IBAMQPNoneTerminusDurabilities              = 0,
    IBAMQPConfigurationTerminusDurabilities     = 1,
    IBAMQPUnsettledStateTerminusDurabilities    = 2,
};

@interface IBAMQPTerminusDurability : NSObject

@property (assign, nonatomic) IBAMQPTerminusDurabilities value;

- (instancetype) initWithTerminusDurability : (IBAMQPTerminusDurabilities) type;
+ (instancetype) enumWithTerminusDurability : (IBAMQPTerminusDurabilities) type;

- (NSString *) nameByValue;
- (IBAMQPTerminusDurabilities) valueByName : (NSString *) name;

- (NSDictionary *) items;

@end
