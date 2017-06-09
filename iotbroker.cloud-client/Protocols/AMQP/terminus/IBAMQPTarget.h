//
//  IBAMQPTarget.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBAMQPTerminusDurability.h"
#import "IBAMQPTerminusExpiryPolicy.h"
#import "IBAMQPSymbol.h"
#import "IBAMQPTLVList.h"

@interface IBAMQPTarget : NSObject

@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) IBAMQPTerminusDurability *durable;
@property (strong, nonatomic) IBAMQPTerminusExpiryPolicy *expiryPeriod;
@property (strong, nonatomic) NSNumber *timeout;
@property (strong, nonatomic) NSNumber *dynamic;
@property (strong, nonatomic) NSMutableDictionary<IBAMQPSymbol *, NSObject *> *dynamicNodeProperties;
@property (strong, nonatomic) NSMutableArray<IBAMQPSymbol *> *capabilities;

- (IBAMQPTLVList *) list;
- (void) fill : (IBAMQPTLVList *) list;

- (void) addDynamicNodeProperties : (NSString *) key value : (NSObject *) value;
- (void) addCapabilities : (NSArray<NSString *> *) array;

@end
