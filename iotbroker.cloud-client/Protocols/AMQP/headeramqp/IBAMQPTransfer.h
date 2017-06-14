//
//  IBAMQPTransfer.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 09.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import "IBAMQPHeader.h"
#import "IBMutableData.h"
#import "IBAMQPMessageFormat.h"
#import "IBAMQPReceiverSettleMode.h"
#import "IBAMQPState.h"
#import "IBAMQPSectionCode.h"
#import "IBAMQPSection.h"

@interface IBAMQPTransfer : IBAMQPHeader 

@property (strong, nonatomic) NSNumber *handle;
@property (strong, nonatomic) NSNumber *deliveryId;
@property (strong, nonatomic) NSMutableData *deliveryTag;
@property (strong, nonatomic) IBAMQPMessageFormat *messageFormat;
@property (strong, nonatomic) NSNumber *settled;
@property (strong, nonatomic) NSNumber *more;
@property (strong, nonatomic) IBAMQPReceiverSettleMode *rcvSettleMode;
@property (strong, nonatomic) id<IBAMQPState> state;
@property (strong, nonatomic) NSNumber *resume;
@property (strong, nonatomic) NSNumber *aborted;
@property (strong, nonatomic) NSNumber *batchable;
@property (strong, nonatomic) NSMutableDictionary<IBAMQPSectionCode *, id<IBAMQPSection>> *sections;

- (id<IBAMQPSection>) header;
- (id<IBAMQPSection>) deliveryAnnotations;
- (id<IBAMQPSection>) messageAnnotations;
- (id<IBAMQPSection>) properties;
- (id<IBAMQPSection>) applicationProperties;
- (id<IBAMQPSection>) data;
- (id<IBAMQPSection>) sequence;
- (id<IBAMQPSection>) value;
- (id<IBAMQPSection>) footer;

- (void) addSections : (NSArray<id<IBAMQPSection>> *) array;

@end
