//
//  IBAMQPBegin.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPHeader.h"
#import "IBAMQPSymbol.h"

@interface IBAMQPBegin : IBAMQPHeader

@property (strong, nonatomic) NSNumber *remoteChannel;
@property (strong, nonatomic) NSNumber *nextOutgoingID;
@property (strong, nonatomic) NSNumber *incomingWindow;
@property (strong, nonatomic) NSNumber *outgoingWindow;
@property (strong, nonatomic) NSNumber *handleMax;
@property (strong, nonatomic) NSMutableArray<IBAMQPSymbol *> *offeredCapabilities;
@property (strong, nonatomic) NSMutableArray<IBAMQPSymbol *> *desiredCapabilities;
@property (strong, nonatomic) NSMutableDictionary<IBAMQPSymbol *, NSObject *> *properties;

- (void) addOfferedCapability : (NSArray<NSString *> *) array;
- (void) addDesiredCapability : (NSArray<NSString *> *) array;
- (void) addProperty : (NSString *) key value : (NSObject *) value;

@end
