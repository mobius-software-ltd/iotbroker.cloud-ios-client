//
//  IBAMQPSource.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 08.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAMQPTerminusDurability.h"
#import "IBAMQPTerminusExpiryPolicy.h"
#import "IBAMQPSymbol.h"
#import "IBAMQPDistributionMode.h"
#import "IBAMQPOutcome.h"

@interface IBAMQPSource : NSObject

@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) IBAMQPTerminusDurability *durable;
@property (strong, nonatomic) IBAMQPTerminusExpiryPolicy *expiryPeriod;
@property (strong, nonatomic) NSNumber *timeout;
@property (assign, nonatomic) NSNumber *dynamic;
@property (strong, nonatomic) NSMutableDictionary<IBAMQPSymbol *, NSObject *> *dynamicNodeProperties;
@property (strong, nonatomic) IBAMQPDistributionMode *distributionMode;
@property (strong, nonatomic) NSMutableDictionary<IBAMQPSymbol *, NSObject *> *filter;
@property (strong, nonatomic) id<IBAMQPOutcome> defaultOutcome;
@property (strong, nonatomic) NSMutableArray<IBAMQPSymbol *> *outcomes;
@property (strong, nonatomic) NSMutableArray<IBAMQPSymbol *> *capabilities;

- (IBAMQPTLVList *) list;
- (void) fill : (IBAMQPTLVList *) list;

- (void) addDynamicNodeProperties : (NSString *) key value : (NSObject *) value;
- (void) addFilter : (NSString *) key value : (NSObject *) value;
- (void) addOutcomes : (NSArray<NSString *> *) array;
- (void) addCapabilities : (NSArray<NSString *> *) array;

@end
