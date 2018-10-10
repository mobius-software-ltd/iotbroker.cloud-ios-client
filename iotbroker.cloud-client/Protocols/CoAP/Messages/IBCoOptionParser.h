//
//  IBCoOptionParser.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 05.10.2018.
//  Copyright © 2018 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBCoEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface IBCoOptionParser : NSObject

+ (NSData *)encode:(IBCoAPOptionDefinitions)type object:(NSObject *)object;
+ (NSObject *)decode:(IBCoAPOptionDefinitions)type data:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
