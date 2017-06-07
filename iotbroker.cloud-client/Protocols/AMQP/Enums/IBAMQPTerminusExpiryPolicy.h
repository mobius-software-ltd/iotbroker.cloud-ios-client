//
//  IBAMQPTerminusExpiryPolicy.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IBAMQPTerminusExpiryPolicies)
{
    IBAMQPLinkDetachTerminusExpiryPolicies      = 0,
    IBAMQPSessionEndTerminusExpiryPolicies      = 1,
    IBAMQPConnectionCloseTerminusExpiryPolicies = 2,
    IBAMQPNeverTerminusExpiryPolicies           = 3,
};

@interface IBAMQPTerminusExpiryPolicy : NSObject

@property (assign, nonatomic) IBAMQPTerminusExpiryPolicies value;

- (instancetype) initWithTerminusExpiryPolicy : (IBAMQPTerminusExpiryPolicies) type;
+ (instancetype) enumWithTerminusExpiryPolicy : (IBAMQPTerminusExpiryPolicies) type;

- (NSString *) nameByValue;
- (IBAMQPTerminusExpiryPolicies) valueByName : (NSString *) name;

- (NSDictionary *) items;

@end
