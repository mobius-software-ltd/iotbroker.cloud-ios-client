//
//  IBAMQPDynamicNodeProperty.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IBAMQPDynamicNodeProperties)
{
    IBAMQPSupportedDistModesDynamicNodeProperty = 0,
    IBAMQPDurableDynamicNodeProperty            = 1,
    IBAMQPAutoDeleteDynamicNodeProperty         = 2,
    IBAMQPAlternateExchangeDynamicNodeProperty  = 3,
    IBAMQPExchangeTypeDynamicNodeProperty       = 4,
};

@interface IBAMQPDynamicNodeProperty : NSObject

@property (assign, nonatomic) IBAMQPDynamicNodeProperties value;

- (instancetype) initWithDynamicNodeProperties : (IBAMQPDynamicNodeProperties) type;
+ (instancetype) enumWithDynamicNodeProperties : (IBAMQPDynamicNodeProperties) type;

- (NSString *) nameByValue;
- (IBAMQPDynamicNodeProperties) valueByName : (NSString *) name;

- (NSDictionary *) items;


@end
