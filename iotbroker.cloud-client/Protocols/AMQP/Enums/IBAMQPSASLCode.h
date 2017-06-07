//
//  IBAMQPSASLCode.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(short, IBAMQPSASLCodes)
{
    IBAMQPOkSASLCode        = 0,
    IBAMQPAuthSASLCode      = 1,
    IBAMQPSysSASLCode       = 2,
    IBAMQPSysPermSASLCode   = 3,
    IBAMQPSysTempSASLCode   = 4,
};

@interface IBAMQPSASLCode : NSObject

@property (assign, nonatomic) IBAMQPSASLCodes value;

- (instancetype) initWithSASLCode : (IBAMQPSASLCodes) type;
+ (instancetype) enumWithSASLCode : (IBAMQPSASLCodes) type;

- (NSString *) nameByValue;
- (IBAMQPSASLCodes) valueByName : (NSString *) name;

- (NSDictionary *) items;

@end
