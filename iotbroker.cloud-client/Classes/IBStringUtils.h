//
//  IBStringUtils.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 05.10.2018.
//  Copyright © 2018 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IBStringUtils : NSObject

+ (NSString *)toHexString:(NSInteger)number;

@end

NS_ASSUME_NONNULL_END
