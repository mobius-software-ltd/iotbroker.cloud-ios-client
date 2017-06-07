//
//  IBAMQPLifetimePolicy.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(Byte, IBAMQPLifetimePolicies)
{
    IBAMQPDeleteOnCloseLifetimePolicy               = 0x2b,
    IBAMQPDeleteOnNoLinksLifetimePolicy             = 0x2c,
    IBAMQPDeleteOnNoMessagesLifetimePolicy          = 0x2d,
    IBAMQPDeleteOnNoLinksOrMessagesLifetimePolicy   = 0x2e,
};

@interface IBAMQPLifetimePolicy : NSObject

@property (assign, nonatomic) IBAMQPLifetimePolicies value;

- (instancetype) initWithLifetimePolicies : (IBAMQPLifetimePolicies) type;
+ (instancetype) enumWithLifetimePolicies : (IBAMQPLifetimePolicies) type;

- (NSString *) nameByValue;
- (IBAMQPLifetimePolicies) valueByName : (NSString *) name;

- (NSDictionary *) items;

@end
