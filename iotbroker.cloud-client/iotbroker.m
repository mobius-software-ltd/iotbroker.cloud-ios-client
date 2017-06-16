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

#import "IBAMQPParser.h"
#import "IBAMQPProtoHeader.h"
#import "IBAMQPOpen.h"
#import "IBAMQPBegin.h"
#import "IBAMQPPing.h"
#import "IBAMQPClose.h"
#import "IBAMQPEnd.h"
#import "IBAMQPSASLChallenge.h"
#import "IBAMQPSASLMechanisms.h"
#import "IBAMQPSASLInit.h"
#import "IBAMQPSASLOutcome.h"
#import "IBAMQPSASLResponse.h"
#import "IBAMQPDetach.h"
#import "IBAMQPDisposition.h"
#import "IBAMQPModified.h"
#import "IBAMQPTransfer.h"
#import "IBAMQPReceived.h"
#import "IBAMQPAttach.h"
#import "IBAMQPFlow.h"
#import "IBAMQPBegin.h"

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

#pragma mark - Packets

- (void)testOpenPacket {

    IBAMQPOpen *open = [[IBAMQPOpen alloc] init];
    open.containerId = @"container-id";
    
    open.chanel = 32;
    open.channelMax = @(60000);
    open.hostname = @"weasel.rmq.cloudamqp.com";
    open.idleTimeout = @(1000);
    open.maxFrameSize = @(10000);
    [open addDesiredCapability:@[@"capability11", @"capability12", @"capability13"]];
    [open addOfferedCapability:@[@"capability21", @"capability22"]];
    [open addIncomingLocale:@[@"locale1"]];
    [open addOutgoingLocale:@[@"locale1.1", @"locale1.2"]];
    [open addProperty:@"key1" value:@"value1"];
    [open addProperty:@"key2" value:@"value2"];
    [open addProperty:@"key3" value:@"value3"];
    NSLog(@" t> OPEN        %zd", [open getLength]);
    
    XCTAssertNoThrow([IBAMQPParser decode:[IBAMQPParser encode:open]]);
}

- (void)testBeginPacket {
    
    IBAMQPBegin *begin = [[IBAMQPBegin alloc] init];
    begin.handleMax = @(1000);
    begin.incomingWindow = @(2000);
    begin.nextOutgoingID = @(3000);
    begin.outgoingWindow = @(4000);
    begin.remoteChannel = @(5000);
    [begin addDesiredCapability:@[@"capability11", @"capability12", @"capability13"]];
    [begin addOfferedCapability:@[@"capability21", @"capability22"]];
    [begin addProperty:@"key1" value:@"value1"];
    [begin addProperty:@"key2" value:@"value2"];
    [begin addProperty:@"key3" value:@"value3"];
    NSLog(@" t> BEGIN       %zd", [begin getLength]);
    
    XCTAssertNoThrow([IBAMQPParser decode:[IBAMQPParser encode:begin]]);
}

- (void)testAttachPacket {
    
    IBAMQPAttach *attach = [[IBAMQPAttach alloc] init];
    attach.handle = @(1000);
    attach.incompleteUnsettled = @(YES);
    attach.initialDeliveryCount = @(100L);
    attach.maxMessageSize = @(43333);
    attach.name = @"usr-name";
    attach.receivedCodes = [IBAMQPReceiverSettleMode enumWithReceiverSettleMode:IBAMQPFirstReceiverSettleMode];
    attach.role = [IBAMQPRoleCode enumWithRoleCode:IBAMQPReceiverRoleCode];
    attach.sendCodes = [IBAMQPSendCode enumWithSendCode:IBAMQPMixedSendCode];
    attach.source = [[IBAMQPSource alloc] init];
    attach.target = [[IBAMQPTarget alloc] init];
    [attach addDesiredCapability:@[@"capability11", @"capability12", @"capability13"]];
    [attach addOfferedCapability:@[@"capability21", @"capability22"]];
    [attach addProperty:@"key1" value:@"value1"];
    [attach addProperty:@"key2" value:@"value2"];
    [attach addProperty:@"key3" value:@"value3"];
    NSLog(@" t> ATTACH      %zd", [attach getLength]);
    
    XCTAssertNoThrow([IBAMQPParser decode:[IBAMQPParser encode:attach]]);
}

- (void)testFlowPacket {
    
    IBAMQPFlow *flow = [[IBAMQPFlow alloc] init];
    flow.avaliable = @(10);
    flow.deliveryCount = @(100);
    flow.drain = @(YES);
    flow.echo = @(NO);
    flow.handle = @(1000);
    flow.incomingWindow = @(10000);
    flow.linkCredit = @(10000);
    flow.nextIncomingId = @(30000);
    flow.nextOutgoingId = @(40000);
    flow.outgoingWindow = @(54000);
    [flow addProperty:@"key1" value:@"value1"];
    [flow addProperty:@"key2" value:@"value2"];
    [flow addProperty:@"key3" value:@"value3"];
    NSLog(@" t> FLOW        %zd", [flow getLength]);
    
    XCTAssertNoThrow([IBAMQPParser decode:[IBAMQPParser encode:flow]]);
}

- (void)testTransferPacket {
    
    IBAMQPTransfer *transfer = [[IBAMQPTransfer alloc] init];
    transfer.aborted = @(YES);
    transfer.batchable = @(NO);
    transfer.deliveryId = @(234);
    transfer.deliveryTag = [NSMutableData dataWithData:[@"Hello" dataUsingEncoding:NSUTF8StringEncoding]];
    transfer.handle = @(32);
    transfer.messageFormat = [[IBAMQPMessageFormat alloc] initWithValue:2352];
    transfer.more = @(YES);
    transfer.rcvSettleMode = [IBAMQPReceiverSettleMode enumWithReceiverSettleMode:IBAMQPSecondReceiverSettleMode];
    transfer.resume = @(NO);
    transfer.settled = @(YES);
    transfer.state = [[IBAMQPReceived alloc] init];
    NSLog(@" t> TRANSFER    %zd", [transfer getLength]);

    XCTAssertNoThrow([IBAMQPParser decode:[IBAMQPParser encode:transfer]]);
}

- (void)testDispositionPacket {
    
    IBAMQPDisposition *disposition = [[IBAMQPDisposition alloc] init];
    disposition.batchable = @(YES);
    disposition.first = @(3412);
    disposition.last = @(54309);
    disposition.role = [IBAMQPRoleCode enumWithRoleCode:IBAMQPSenderRoleCode];
    disposition.settled = @(NO);
    disposition.state = [[IBAMQPModified alloc] init];
    NSLog(@" t> DISPOSITION %zd", [disposition getLength]);
    
    XCTAssertNoThrow([IBAMQPParser decode:[IBAMQPParser encode:disposition]]);
}

- (void)testDetachPacket {
    
    IBAMQPDetach *detach = [[IBAMQPDetach alloc] init];
    detach.closed = @(YES);
    detach.error = [[IBAMQPError alloc] init];
    detach.handle = @(52);
    NSLog(@" t> DETACH      %zd", [detach getLength]);
    
    XCTAssertNoThrow([IBAMQPParser decode:[IBAMQPParser encode:detach]]);
}

- (void)testEndPacket {
    
    IBAMQPEnd *end = [[IBAMQPEnd alloc] init];
    end.error = [[IBAMQPError alloc] init];
    NSLog(@" t> END         %zd", [end getLength]);
    
    XCTAssertNoThrow([IBAMQPParser decode:[IBAMQPParser encode:end]]);
}

- (void)testClosePacket {
    
    IBAMQPClose *close = [[IBAMQPClose alloc] init];
    close.error = [[IBAMQPError alloc] init];
    NSLog(@" t> CLOSE       %zd", [close getLength]);
    
    XCTAssertNoThrow([IBAMQPParser decode:[IBAMQPParser encode:close]]);
}

#pragma mark SASL

- (void)testMechanismsPacket {
    
    IBAMQPSASLMechanisms *mechanisms = [[IBAMQPSASLMechanisms alloc] init];
    [mechanisms setType:1];
    [mechanisms addMechanism:@"NATIVE"];
    [mechanisms addMechanism:@"CRAM-MD5"];
    NSLog(@" t> MECHANISMS  %zd", [mechanisms getLength]);
    
    XCTAssertNoThrow([IBAMQPParser decode:[IBAMQPParser encode:mechanisms]]);
}

- (void)testInitPacket {
    
    IBAMQPSASLInit *init = [[IBAMQPSASLInit alloc] init];
    [init setType:1];
    init.hostName = @"localhost";
    init.initialResponse = [NSMutableData dataWithData:[@"hello" dataUsingEncoding:NSUTF8StringEncoding]];
    init.mechanism = [[IBAMQPSymbol alloc] initWithString:@"hello-mechanism"];
    NSLog(@" t> INIT        %zd", [init getLength]);
    
    XCTAssertNoThrow([IBAMQPParser decode:[IBAMQPParser encode:init]]);
}

- (void)testChallengePacket {
    
    IBAMQPSASLChallenge *challenge = [[IBAMQPSASLChallenge alloc] init];
    [challenge setType:1];
    challenge.challenge = [NSMutableData dataWithData:[@"hello world" dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@" t> CHALLENGE   %zd", [challenge getLength]);
    
    XCTAssertNoThrow([IBAMQPParser decode:[IBAMQPParser encode:challenge]]);
}

- (void)testResponsePacket {
    
    //IBAMQPSASLResponse *response  = [[IBAMQPSASLResponse alloc] init];
    //NSLog(@" t> RESPONSE     %zd", [response getLength]);
    
    //XCTAssertNoThrow([IBAMQPParser decode:[IBAMQPParser encode:response]]);
}

- (void)testOutcomePacket {
    
    IBAMQPSASLOutcome *outcome  = [[IBAMQPSASLOutcome alloc] init];
    [outcome setType:1];
    outcome.outcomeCode = [IBAMQPSASLCode enumWithSASLCode:IBAMQPOkSASLCode];
    outcome.additionalData = [NSMutableData dataWithData:[@"hello world" dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@" t> OUTCOME     %zd", [outcome getLength]);
    
    XCTAssertNoThrow([IBAMQPParser decode:[IBAMQPParser encode:outcome]]);
}

#pragma mark Header & Ping

- (void)testProtoHeaderPacket {
    
    IBAMQPProtoHeader *header = [[IBAMQPProtoHeader alloc] init];

    NSLog(@" t> HEADER       %zd", [header getLength]);
    
    XCTAssertNoThrow([IBAMQPParser decode:[IBAMQPParser encode:header]]);
}

- (void)testPingPacket {
    
    IBAMQPPing *ping = [[IBAMQPPing alloc] init];
    
    NSLog(@" t> PING         %zd", [ping getLength]);
    
    XCTAssertNoThrow([IBAMQPParser decode:[IBAMQPParser encode:ping]]);
}

#pragma mark - Wrapper & Unwrapper
/*
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
*/
@end
