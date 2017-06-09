//
//  IBAMQPAttach.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 08.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPHeader.h"
#import "IBAMQPRoleCode.h"
#import "IBAMQPSendCode.h"
#import "IBAMQPReceiverSettleMode.h"
#import "IBAMQPSource.h"
#import "IBAMQPTarget.h"

@interface IBAMQPAttach : IBAMQPHeader

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *handle;
@property (strong, nonatomic) IBAMQPRoleCode *role;
@property (strong, nonatomic) IBAMQPSendCode *sendCodes;
@property (strong, nonatomic) IBAMQPReceiverSettleMode *receivedCodes;
@property (strong, nonatomic) IBAMQPSource *source;
@property (strong, nonatomic) IBAMQPTarget *target;
@property (strong, nonatomic) NSMutableDictionary<IBAMQPSymbol *, NSObject *> *unsettled;
@property (strong, nonatomic) NSNumber *incompleteUnsettled;
@property (strong, nonatomic) NSNumber *initialDeliveryCount;
@property (strong, nonatomic) NSNumber *maxMessageSize;
@property (strong, nonatomic) NSMutableArray<IBAMQPSymbol *> *offeredCapabilities;
@property (strong, nonatomic) NSMutableArray<IBAMQPSymbol *> *desiredCapabilities;
@property (strong, nonatomic) NSMutableDictionary<IBAMQPSymbol *, NSObject *> *properties;

- (void) addUnsettled : (NSString *) key value : (NSObject *) value;
- (void) addOfferedCapability : (NSArray<NSString *> *) array;
- (void) addDesiredCapability : (NSArray<NSString *> *) array;
- (void) addProperty : (NSString *) key value : (NSObject *) value;

@end
