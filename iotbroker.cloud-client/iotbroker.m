//
//  iotbroker.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 01.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IBMutableData.h"

@interface iotbroker : XCTestCase

@property (strong, nonatomic) NSMutableData *data;

@end

@implementation iotbroker

- (void)setUp {
    [super setUp];
    
    self->_data = [NSMutableData data];
}

- (void)testExample {
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testReadWriteIntInMutableData {
    
    int number = 7;
        
    for (int i = 0; i < number; i++) {
        double value = (rand() % 300);
        [self->_data appendUInt24:value];
        
        double result = [self->_data readUInt24];
        XCTAssertEqual(value, result, @"(%zd) == (%zd)", value, result);
        
    }
}

@end
