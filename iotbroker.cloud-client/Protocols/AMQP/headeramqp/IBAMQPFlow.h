//
//  IBAMQPFlow.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPHeader.h"
#import "IBAMQPSymbol.h"

@interface IBAMQPFlow : IBAMQPHeader

@property (strong, nonatomic) NSNumber *nextIncomingId;
@property (strong, nonatomic) NSNumber *incomingWindow;
@property (strong, nonatomic) NSNumber *nextOutgoingId;
@property (strong, nonatomic) NSNumber *outgoingWindow;
@property (strong, nonatomic) NSNumber *handle;
@property (strong, nonatomic) NSNumber *deliveryCount;
@property (strong, nonatomic) NSNumber *linkCredit;
@property (strong, nonatomic) NSNumber *avaliable;
@property (strong, nonatomic) NSNumber *drain;
@property (strong, nonatomic) NSNumber *echo;
@property (strong, nonatomic) NSMutableDictionary<IBAMQPSymbol *, NSObject *> *properties;

- (void) addProperty : (NSString *) key value : (NSObject *) value;

@end
