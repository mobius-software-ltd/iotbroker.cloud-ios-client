//
//  IBSNQoS.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IBSNQualitiesOfService)
{
    IBAtMostOnce    = 0,
    IBAtLeastOnce   = 1,
    IBExactlyOnce   = 2,
    IBLevelOne      = 3,
};

@interface IBSNQoS : NSObject

@property (assign, nonatomic, readonly) IBSNQualitiesOfService value;

- (instancetype) initWithValue : (Byte) value;
+ (instancetype) claculateSubscriberQos : (IBSNQoS *) subscriberQos andPublisherQos : (IBSNQoS *) publisherQos;

- (BOOL) isValid;

@end
