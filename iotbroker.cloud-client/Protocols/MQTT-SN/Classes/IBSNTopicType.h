//
//  IBSNTopicType.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 24.04.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, IBSNTopicTypes)
{
    IBNamedTopicType    = 0,
    IBIDTopicType       = 1,
    IBShortTopicType    = 2,
};

@interface IBSNTopicType : NSObject

@property (assign, nonatomic, readonly) IBSNTopicTypes value;

- (instancetype) initWithValue : (Byte) value;

- (BOOL) isValid;

@end
