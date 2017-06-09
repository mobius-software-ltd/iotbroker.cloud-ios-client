//
//  IBAMQPOpen.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPHeader.h"
#import "IBAMQPSymbol.h"

@interface IBAMQPOpen : IBAMQPHeader

@property (strong, nonatomic) NSString *containerId;
@property (strong, nonatomic) NSString *hostname;
@property (strong, nonatomic) NSNumber *maxFrameSize;
@property (strong, nonatomic) NSNumber *channelMax;
@property (strong, nonatomic) NSNumber *idleTimeout;
@property (strong, nonatomic) NSMutableArray<IBAMQPSymbol *> *outgoingLocales;
@property (strong, nonatomic) NSMutableArray<IBAMQPSymbol *> *incomingLocales;
@property (strong, nonatomic) NSMutableArray<IBAMQPSymbol *> *offeredCapabilities;
@property (strong, nonatomic) NSMutableArray<IBAMQPSymbol *> *desiredCapabilities;
@property (strong, nonatomic) NSMutableDictionary<IBAMQPSymbol *, NSObject *> *properties;

- (void) addOutgoingLocale : (NSArray<NSString *> *) array;
- (void) addIncomingLocale : (NSArray<NSString *> *) array;
- (void) addOfferedCapability : (NSArray<NSString *> *) array;
- (void) addDesiredCapability : (NSArray<NSString *> *) array;
- (void) addProperty : (NSString *) key value : (NSObject *) value;

@end
