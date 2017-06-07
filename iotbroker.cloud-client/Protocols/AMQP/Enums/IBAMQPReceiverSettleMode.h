//
//  IBAMQPReceiverSettleMode.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(short, IBAMQPReceiverSettleModes)
{
    IBAMQPFirstReceiverSettleMode = 0,
    IBAMQPSecondReceiverSettleMode = 1,
};

@interface IBAMQPReceiverSettleMode : NSObject

@property (assign, nonatomic) IBAMQPReceiverSettleModes value;

- (instancetype) initWithReceiverSettleMode : (IBAMQPReceiverSettleModes) type;
+ (instancetype) enumWithReceiverSettleMode : (IBAMQPReceiverSettleModes) type;

- (NSString *) nameByValue;
- (IBAMQPReceiverSettleModes) valueByName : (NSString *) name;

- (NSDictionary *) items;

@end
