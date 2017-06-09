//
//  iotbroker.m
//  iotbroker.cloud-client
//
//  Created by MacOS on 01.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IBMutableData.h"

#import "IBAMQPWrapper.h"
#import "IBAMQPUnwrapper.h"
#import "IBAMQPTLVList.h"

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

// wrapper & unwrapper

- (void)testWU_UByte {

    short value = 32;
    IBTLVAMQP *tlv = [IBAMQPWrapper wrapObject:@(value) withType:IBAMQPUByteType];
    
    id object = [IBAMQPUnwrapper unwrap:tlv];
    
    if (![object isKindOfClass:[NSNumber class]]) {
        XCTFail(@"Uncorrect class : %@",[[object class] description]);
    } else {
        short result = [object shortValue];
        XCTAssertEqual(value, result, @"(%zd) == (%zd)", value, result);
    }
}

- (void)testWU_BOOL {
    
    BOOL value = true;
    IBTLVAMQP *tlv = [IBAMQPWrapper wrapObject:@(value) withType:IBAMQPBooleanType];
    
    id object = [IBAMQPUnwrapper unwrap:tlv];
    
    if (![object isKindOfClass:[NSNumber class]]) {
        XCTFail(@"Uncorrect class : %@",[[object class] description]);
    } else {
        BOOL result = [object boolValue];
        XCTAssertEqual(value, result, @"(%i) == (%i)", value, result);
    }
}

- (void)testWU_Byte {
    
    Byte value = 23;
    IBTLVAMQP *tlv = [IBAMQPWrapper wrapObject:@(value) withType:IBAMQPByteType];
    
    id object = [IBAMQPUnwrapper unwrap:tlv];
    
    if (![object isKindOfClass:[NSNumber class]]) {
        XCTFail(@"Uncorrect class : %@",[[object class] description]);
    } else {
        Byte result = (Byte)[object charValue];
        XCTAssertEqual(value, result, @"(%i) == (%i)", value, result);
    }
}

- (void)testWU_UShort {
    
    unsigned short value = 34;
    IBTLVAMQP *tlv = [IBAMQPWrapper wrapObject:@(value) withType:IBAMQPUShortType];
    
    id object = [IBAMQPUnwrapper unwrap:tlv];
    
    if (![object isKindOfClass:[NSNumber class]]) {
        XCTFail(@"Uncorrect class : %@",[[object class] description]);
    } else {
        unsigned short result = [object unsignedShortValue];
        XCTAssertEqual(value, result, @"(%i) == (%i)", value, result);
    }
}

- (void)testWU_Short {
    
    short value = 43;
    IBTLVAMQP *tlv = [IBAMQPWrapper wrapObject:@(value) withType:IBAMQPShortType];
    
    id object = [IBAMQPUnwrapper unwrap:tlv];
    
    if (![object isKindOfClass:[NSNumber class]]) {
        XCTFail(@"Uncorrect class : %@",[[object class] description]);
    } else {
        short result = [object shortValue];
        NSLog(@"%zd - %zd", result, value);
        XCTAssertEqual(value, result, @"(%i) == (%i)", value, result);
    }
}

- (void)testWU_Int {
    
    int value = 68;
    IBTLVAMQP *tlv = [IBAMQPWrapper wrapObject:@(value) withType:IBAMQPIntType];
    
    id object = [IBAMQPUnwrapper unwrap:tlv];
    
    if (![object isKindOfClass:[NSNumber class]]) {
        XCTFail(@"Uncorrect class : %@",[[object class] description]);
    } else {
        int result = [object intValue];
        XCTAssertEqual(value, result, @"(%i) == (%i)", value, result);
    }
}

- (void)testWU_UInt {
    
    unsigned int value = 0;
    IBTLVAMQP *tlv = [IBAMQPWrapper wrapObject:@(value) withType:IBAMQPUIntType];
    
    id object = [IBAMQPUnwrapper unwrap:tlv];
    
    if (![object isKindOfClass:[NSNumber class]]) {
        XCTFail(@"Uncorrect class : %@",[[object class] description]);
    } else {
        unsigned int result = [object unsignedIntValue];
        XCTAssertEqual(value, result, @"(%i) == (%i)", value, result);
    }
}

- (void)testWU_Long {
    
    long value = 435634;
    IBTLVAMQP *tlv = [IBAMQPWrapper wrapObject:@(value) withType:IBAMQPLongType];
    
    id object = [IBAMQPUnwrapper unwrap:tlv];
    
    if (![object isKindOfClass:[NSNumber class]]) {
        XCTFail(@"Uncorrect class : %@",[[object class] description]);
    } else {
        long result = [object longValue];
        XCTAssertEqual(value, result, @"(%zd) == (%zd)", value, result);
    }
}

- (void)testWU_ULong {
    
    unsigned long value = 435734;
    IBTLVAMQP *tlv = [IBAMQPWrapper wrapObject:@(value) withType:IBAMQPULongType];
    
    id object = [IBAMQPUnwrapper unwrap:tlv];
    
    if (![object isKindOfClass:[NSNumber class]]) {
        XCTFail(@"Uncorrect class : %@",[[object class] description]);
    } else {
        unsigned long result = [object unsignedLongValue];
        XCTAssertEqual(value, result, @"(%zd) == (%zd)", value, result);
    }
}

- (void)testWU_Float {
    
    float value = 340.321;
    float accuracy = 0.0;
    
    IBTLVAMQP *tlv = [IBAMQPWrapper wrapObject:@(value) withType:IBAMQPFloatType];
    
    id object = [IBAMQPUnwrapper unwrap:tlv];
    
    if (![object isKindOfClass:[NSNumber class]]) {
        XCTFail(@"Uncorrect class : %@",[[object class] description]);
    } else {
        float result = [object floatValue];
        XCTAssertEqualWithAccuracy(value, result, accuracy, @"(%g) == (%g) . (%g)", value, result, accuracy);
    }
}

- (void)testWU_Double {
    
    double value = 340.321;
    float accuracy = 0.0;
    
    IBTLVAMQP *tlv = [IBAMQPWrapper wrapObject:@(value) withType:IBAMQPDoubleType];
    
    id object = [IBAMQPUnwrapper unwrap:tlv];
    
    if (![object isKindOfClass:[NSNumber class]]) {
        XCTFail(@"Uncorrect class : %@",[[object class] description]);
    } else {
        double result = [object doubleValue];
        XCTAssertEqualWithAccuracy(value, result, accuracy, @"(%g) == (%g) . (%g)", value, result, accuracy);
    }
}

- (void)testWU_Char {
    
    char value = 'c';
    
    IBTLVAMQP *tlv = [IBAMQPWrapper wrapObject:@(value) withType:IBAMQPCharType];
    
    id object = [IBAMQPUnwrapper unwrap:tlv];
    
    if (![object isKindOfClass:[NSNumber class]]) {
        XCTFail(@"Uncorrect class : %@",[[object class] description]);
    } else {
        char result = [object charValue];
        NSLog(@" %c %c ", value, result);
        XCTAssertEqual(value, result, @"(%c) == (%c)", value, result);
    }
}

- (void)testWU_Timestamp {
    
    NSDate *value = [NSDate date];
    float accuracy = 0.0;

    IBTLVAMQP *tlv = [IBAMQPWrapper wrapObject:value withType:IBAMQPTimestampType];
    
    id object = [IBAMQPUnwrapper unwrap:tlv];
    
    if (![object isKindOfClass:[NSDate class]]) {
        XCTFail(@"Uncorrect class : %@",[[object class] description]);
    } else {
        NSDate *result = (NSDate *)object;
        XCTAssertEqualWithAccuracy(value.timeIntervalSince1970, result.timeIntervalSince1970, accuracy,
                                   @"(%g) == (%g) . (%g)", value.timeIntervalSince1970, result.timeIntervalSince1970, accuracy);
    }
}

- (void)testWU_UUID {
    
    NSUUID *value = [NSUUID UUID];
    IBTLVAMQP *tlv = [IBAMQPWrapper wrapObject:value withType:IBAMQPUUIDType];
    
    id object = [IBAMQPUnwrapper unwrap:tlv];
    
    if (![object isKindOfClass:[NSUUID class]]) {
        XCTFail(@"Uncorrect class : %@",[[object class] description]);
    } else {
        NSUUID *result = (NSUUID *)object;
        XCTAssertEqualObjects(value, result, @"(%@) == (%@)", value, result);
    }
}

- (void)testWU_String {
    
    NSString *value = @"Hello World string for test";
    IBTLVAMQP *tlv = [IBAMQPWrapper wrapObject:value withType:0];
    
    id object = [IBAMQPUnwrapper unwrap:tlv];
    
    if (![object isKindOfClass:[NSString class]]) {
        XCTFail(@"Uncorrect class : %@",[[object class] description]);
    } else {
        NSString *result = (NSString *)object;
        XCTAssertEqualObjects(value, result, @"(%@) == (%@)", value, result);
    }
}

- (void)testWU_Binary {
    
    NSString *string = @"Hello World string for test";
    NSData *value = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    IBTLVAMQP *tlv = [IBAMQPWrapper wrapObject:value withType:0];
    
    id object = [IBAMQPUnwrapper unwrap:tlv];
    
    if (![object isKindOfClass:[NSData class]]) {
        XCTFail(@"Uncorrect class : %@",[[object class] description]);
    } else {
        NSData *result = (NSData *)object;
        XCTAssertEqualObjects(value, result, @"(%@) == (%@)", value, result);
    }
}

- (void)testWU_Decimal {
    
    float number = 34.3;
    
    IBAMQPDecimal *value = [[IBAMQPDecimal alloc] initWithFloat:number];
    IBTLVAMQP *tlv = [IBAMQPWrapper wrapObject:value withType:0];
    
    id object = [IBAMQPUnwrapper unwrap:tlv];
    
    if (![object isKindOfClass:[IBAMQPDecimal class]]) {
        XCTFail(@"Uncorrect class : %@",[[object class] description]);
    } else {
        IBAMQPDecimal *result = (IBAMQPDecimal *)object;
        float resultNumber = [result floatNumber];
        XCTAssertEqual(number, resultNumber, @"(%g) == (%g)", number, resultNumber);
    }
}

- (void)testWU_Symbol {
    
    IBAMQPSymbol *value = [[IBAMQPSymbol alloc] initWithString:@"symb"];
    IBTLVAMQP *tlv = [IBAMQPWrapper wrapObject:value withType:0];
    
    id object = [IBAMQPUnwrapper unwrap:tlv];
    
    if (![object isKindOfClass:[IBAMQPSymbol class]]) {
        XCTFail(@"Uncorrect class : %@",[[object class] description]);
    } else {
        IBAMQPSymbol *result = (IBAMQPSymbol *)object;
        XCTAssertEqualObjects(value, result, @"(%@) == (%@)", value, result);
    }
}

- (void)testWU_List {
    
    NSArray *array = @[@(23),@(23),@(43)];
    IBTLVAMQP *tlv = [IBAMQPWrapper wrapList:array withType:IBAMQPIntType];

    id object = [IBAMQPUnwrapper unwrap:tlv];
    
    if (![object isKindOfClass:[NSArray class]]) {
        XCTFail(@"Uncorrect class : %@",[[object class] description]);
    } else {
        NSArray *result = (NSArray *)object;
        NSLog(@"%@", result);
    }
}

- (void)testWU_Array {
    
    NSArray *array = @[@(23),@(23),@(43)];
    IBTLVAMQP *tlv = [IBAMQPWrapper wrapArray:array withType:IBAMQPIntType];
    
    id object = [IBAMQPUnwrapper unwrap:tlv];
    
    if (![object isKindOfClass:[NSArray class]]) {
        XCTFail(@"Uncorrect class : %@",[[object class] description]);
    } else {
        NSArray *result = (NSArray *)object;
        NSLog(@"%@", result);
    }
}

- (void)testWU_Map {
    
    NSDictionary *map = @{ @(11) : @(1), @(22) : @(2), @(33) : @(3)};
    IBTLVAMQP *tlv = [IBAMQPWrapper wrapMap:map withKeyType:IBAMQPIntType valueType:IBAMQPIntType];
    
    id object = [IBAMQPUnwrapper unwrap:tlv];
    
    if (![object isKindOfClass:[NSDictionary class]]) {
        XCTFail(@"Uncorrect class : %@",[[object class] description]);
    } else {
        NSDictionary *result = (NSDictionary *)object;
        NSLog(@"%@", result);
    }
}

@end
