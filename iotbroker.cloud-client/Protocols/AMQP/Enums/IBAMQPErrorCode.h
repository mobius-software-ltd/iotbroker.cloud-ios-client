/**
 * Mobius Software LTD
 * Copyright 2015-2017, Mobius Software LTD
 *
 * This is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 2.1 of
 * the License, or (at your option) any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this software; if not, write to the Free
 * Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA, or see the FSF site: http://www.fsf.org.
 */

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
