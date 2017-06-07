//
//  IBAMQPStateCode.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(Byte, IBAMQPStateCodes)
{
    IBAMQPAcceptedStateCode = 0x23,
    IBAMQPRejectedStateCode = 0x24,
    IBAMQPReleasedStateCode = 0x25,
    IBAMQPModifiedStateCode = 0x26,
    IBAMQPReceivedStateCode = 0x27,
};

@interface IBAMQPStateCode : NSObject

@property (assign, nonatomic) IBAMQPStateCodes value;

- (instancetype) initWithStateCode : (IBAMQPStateCodes) type;
+ (instancetype) enumWithStateCode : (IBAMQPStateCodes) type;

- (NSString *) nameByValue;
- (IBAMQPStateCodes) valueByName : (NSString *) name;

- (NSDictionary *) items;

@end
