//
//  IBAMQPDecimal.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBMutableData.h"

@interface IBAMQPDecimal : NSObject

@property (strong, nonatomic, readonly) NSMutableData *value;

- (instancetype) initWithValue : (NSMutableData *) value;
- (instancetype) initWithByte : (Byte) byte;
- (instancetype) initWithShort : (short) number;
- (instancetype) initWithInt : (int) number;
- (instancetype) initWithLong : (long) number;
- (instancetype) initWithFloat : (float) number;
- (instancetype) initWithDouble : (double) number;

- (Byte) byte;
- (short) shortNumber;
- (int) intNumber;
- (long) longNumber;
- (float) floatNumber;
- (double) doubleNumber;

@end
