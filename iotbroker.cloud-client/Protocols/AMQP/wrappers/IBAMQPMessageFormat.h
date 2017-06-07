//
//  IBAMQPMessageFormat.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBAMQPMessageFormat : NSObject

@property (assign, nonatomic) NSInteger messageFormat;
@property (assign, nonatomic) NSInteger version;

- (instancetype) initWithValue : (long) value;
- (instancetype) initWithMessageFormat : (NSInteger) format andVersion : (NSInteger) version;

- (long) encode;

@end
