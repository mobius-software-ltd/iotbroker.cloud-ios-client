//
//  IBAMQPHeaderCode.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(Byte, IBAMQPHeaderCodes)
{
    IBAMQPProtocolHeaderCode        = 0x08,
    IBAMQPOpenHeaderCode            = 0x10,
    IBAMQPBeginHeaderCode           = 0x11,
    IBAMQPAttachHeaderCode          = 0x12,
    IBAMQPFlowHeaderCode            = 0x13,
    IBAMQPTransferHeaderCode        = 0x14,
    IBAMQPDispositionHeaderCode     = 0x15,
    IBAMQPDetachHeaderCode          = 0x16,
    IBAMQPEndHeaderCode             = 0x17,
    IBAMQPCloseHeaderCode           = 0x18,
    IBAMQPMechanismsHeaderCode      = 0x40,
    IBAMQPInitHeaderCode            = 0x41,
    IBAMQPChallengeHeaderCode       = 0x42,
    IBAMQPResponseHeaderCode        = 0x43,
    IBAMQPOutcomeHeaderCode         = 0x44,
    IBAMQPPingHeaderCode            = 0xff,
};

@interface IBAMQPHeaderCode : NSObject

@property (assign, nonatomic) IBAMQPHeaderCodes value;

- (instancetype) initWithHeaderCode : (IBAMQPHeaderCodes) type;
+ (instancetype) enumWithHeaderCode : (IBAMQPHeaderCodes) type;

- (NSString *) nameByValue;
- (IBAMQPHeaderCodes) valueByName : (NSString *) name;

- (NSDictionary *) items;

@end
