//
//  IBAMQPConnectionProperty.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IBAMQPConnectionProperties)
{
    IBAMQPPlatformConnectionProperty            = 0,
    IBAMQPProductConnectionProperty             = 1,
    IBAMQPQPidClientPidConnectionProperty       = 2,
    IBAMQPQPidClientPpidConnectionProperty      = 3,
    IBAMQPQPidClientProcessConnectionProperty   = 4,
    IBAMQPVersionConnectionProperty             = 5,
};

@interface IBAMQPConnectionProperty : NSObject

@property (assign, nonatomic) IBAMQPConnectionProperties value;

- (instancetype) initWithConnectionProperty : (IBAMQPConnectionProperties) type;
+ (instancetype) enumWithConnectionProperty : (IBAMQPConnectionProperties) type;

- (NSString *) nameByValue;
- (IBAMQPConnectionProperties) valueByName : (NSString *) name;

- (NSDictionary *) items;

@end
