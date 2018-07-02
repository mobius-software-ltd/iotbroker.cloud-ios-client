//
//  IBCoOption.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 02.07.2018.
//  Copyright © 2018 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IBCoOption : NSObject

@property (assign, nonatomic) int number;
@property (assign, nonatomic) int length;
@property (strong, nonatomic) NSData *value;

- (instancetype) initWithNumber: (int) number length: (int) length value: (NSData *) value;

- (NSString *) stringValue;

@end
