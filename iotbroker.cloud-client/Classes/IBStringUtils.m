//
//  IBStringUtils.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 05.10.2018.
//  Copyright © 2018 MobiusSoftware. All rights reserved.
//

#import "IBStringUtils.h"

@implementation IBStringUtils

+ (NSString *)toHexString:(NSInteger)number {
    NSString *str = [@(number) stringValue];
    NSString * hexStr = [NSString stringWithFormat:@"%@",
                         [NSData dataWithBytes:[str cStringUsingEncoding:NSUTF8StringEncoding]
                                        length:strlen([str cStringUsingEncoding:NSUTF8StringEncoding])]];
    
    for(NSString * toRemove in [NSArray arrayWithObjects:@"<", @">", @" ", nil])
        hexStr = [hexStr stringByReplacingOccurrencesOfString:toRemove withString:@""];
    
    return hexStr;
}

@end
