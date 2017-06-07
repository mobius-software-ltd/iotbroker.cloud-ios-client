//
//  IBAMQPSendCode.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(short, IBAMQPSendCodes)
{
    IBAMQPUnsettledSendCode = 0,
    IBAMQPSettledSendCode = 1,
    IBAMQPMixedSendCode = 2,
};

@interface IBAMQPSendCode : NSObject

@property (assign, nonatomic) IBAMQPSendCodes value;

- (instancetype) initWithSendCode : (IBAMQPSendCodes) type;
+ (instancetype) enumWithSendCode : (IBAMQPSendCodes) type;

- (NSString *) nameByValue;
- (IBAMQPSendCodes) valueByName : (NSString *) name;

- (NSDictionary *) items;

@end
