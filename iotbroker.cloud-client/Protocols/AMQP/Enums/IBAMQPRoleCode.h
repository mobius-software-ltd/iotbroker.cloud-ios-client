//
//  IBAMQPRoleCode.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IBAMQPRoleCodes)
{
    IBAMQPSenderRoleCode = false,
    IBAMQPReceiverRoleCode = true,
};

@interface IBAMQPRoleCode : NSObject

@property (assign, nonatomic) IBAMQPRoleCodes value;

- (instancetype) initWithRoleCode : (IBAMQPRoleCodes) type;
+ (instancetype) enumWithRoleCode : (IBAMQPRoleCodes) type;

- (NSString *) nameByValue;
- (IBAMQPRoleCodes) valueByName : (NSString *) name;

- (NSDictionary *) items;

@end
