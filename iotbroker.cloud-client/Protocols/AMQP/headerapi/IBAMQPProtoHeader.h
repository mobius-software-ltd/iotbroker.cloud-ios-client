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

typedef NS_ENUM(NSInteger, IBAMQPProtocolHeaders)
{
    IBAMQPProtocolHeader        = 0,
    IBAMQPProtocolHeaderTLS     = 2,
    IBAMQPProtocolHeaderSASL    = 3,
};

extern NSString *const IBAMQPProtocolName;

@interface IBAMQPProtoHeader : IBAMQPHeader 

@property (assign, nonatomic) IBAMQPProtocolHeaders protocolID;
@property (assign, nonatomic) NSInteger versionMajor;
@property (assign, nonatomic) NSInteger versionMinor;
@property (assign, nonatomic) NSInteger versionRevision;
@property (strong, nonatomic, readonly) NSMutableData *bytes;

- (instancetype) initWithProtocolID : (NSInteger) protocolID;

@end
