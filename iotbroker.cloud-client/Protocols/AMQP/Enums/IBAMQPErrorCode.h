//
//  IBAMQPErrorCode.h
//  iotbroker.cloud-client
//
//  Created by MacOS on 06.06.17.
//  Copyright © 2017 MobiusSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IBAMQPErrorCodes)
{
    IBAMQPInternalErrorCode                 = 0,
    IBAMQPNotFoundErrorCode                 = 1,
    IBAMQPUnauthorizedAccessErrorCode       = 2,
    IBAMQPDecodeErrorCode                   = 3,
    IBAMQPResourceLimitExceededErrorCode    = 4,
    IBAMQPNotAllowedErrorCode               = 5,
    IBAMQPInvalidFieldErrorCode             = 6,
    IBAMQPNotImplementedErrorCode           = 7,
    IBAMQPResourceLockedErrorCode           = 8,
    IBAMQPPreconditionFailedErrorCode       = 9,
    IBAMQPResourceDeletedErrorCode          = 10,
    IBAMQPIllegalStateErrorCode             = 11,
    IBAMQPFrameSizeTooSmallErrorCode        = 12,
    IBAMQPConnectionForcedErrorCode         = 13,
    IBAMQPFramingErrorCode                  = 14,
    IBAMQPRedirectedErrorCode               = 15,
    IBAMQPWindowViolationErrorCode          = 16,
    IBAMQPErrantLinkErrorCode               = 17,
    IBAMQPHandleInUseErrorCode              = 18,
    IBAMQPUnattachedHandleErrorCode         = 19,
    IBAMQPDetachForcedErrorCode             = 20,
    IBAMQPTransferLimitExceededErrorCode    = 21,
    IBAMQPMessageSizeExceededErrorCode      = 22,
    IBAMQPRedirectErrorCode                 = 23,
    IBAMQPStolenErrorCode                   = 24,
};

@interface IBAMQPErrorCode : NSObject

@property (assign, nonatomic) IBAMQPErrorCodes value;

- (instancetype) initWithErrorCode : (IBAMQPErrorCodes) type;
+ (instancetype) enumWithErrorCode : (IBAMQPErrorCodes) type;

- (NSString *) nameByValue;
- (IBAMQPErrorCodes) valueByName : (NSString *) name;

- (NSDictionary *) items;

@end
