//
//  IBAMQPProtoHeader.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 07.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IBMutableData.h"
#import "IBAMQPHeader.h"

extern NSString *const IBAMQPProtocolName;

@interface IBAMQPProtoHeader : IBAMQPHeader

@property (assign, nonatomic, readonly) NSInteger protocolID;
@property (assign, nonatomic, readonly) NSInteger versionMajor;
@property (assign, nonatomic, readonly) NSInteger versionMinor;
@property (assign, nonatomic, readonly) NSInteger versionRevision;

@property (strong, nonatomic, readonly) NSMutableData *bytes;

- (instancetype) initWithProtocolID : (NSInteger) protocolID;

@end
